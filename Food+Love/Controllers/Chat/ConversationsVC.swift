
import UIKit
import Firebase


//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}




class ConversationsVC: UITableViewController {

	// MARK: Properties
	let cellId = "cellId"
	var timer: Timer?
	var messages = [Message]()
	var messagesDictionary = [String: Message]()


	// MARK: view Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavBar()
		checkIfUserIsLoggedIn()
		tableView.register(LoverCell.self, forCellReuseIdentifier: cellId)
	}


	// MARK: Helper Methods
	func setupNavBar(){
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
		let image = UIImage(named: "new_message_icon")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
	}


	// Observe Messages for changes
	func observeUserMessages() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let ref = Database.database().reference().child("user-messages").child(uid)
		ref.observe(.childAdded, with: { (snapshot) in
			let newId = snapshot.key
			Database.database().reference().child("user-messages").child(uid).child(newId).observe(.childAdded, with: { (snapshot) in
				let messageId = snapshot.key
				self.fetchMessageWithMessageId(messageId)
			}, withCancel: nil)
		}, withCancel: nil)
	}


	// Fetch Message with message ID
	fileprivate func fetchMessageWithMessageId(_ messageId: String) {
		let messagesReference = Database.database().reference().child("messages").child(messageId)
		messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let message = Message(dictionary: dictionary)
				if let chatPartnerId = message.chatPartnerId() {
					self.messagesDictionary[chatPartnerId] = message
				}
				self.attemptReloadOfTable()
			}
		}, withCancel: nil)
	}


	// (Timer) Attempt to Reload Table
	fileprivate func attemptReloadOfTable() {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
	}


	// Reload Table
	@objc func handleReloadTable() {
		self.messages = Array(self.messagesDictionary.values)
		self.messages.sort(by: { (message1, message2) -> Bool in
			//				return message1.timestamp?.int32Value > message2.timestamp?.int32Value
			return Int(message1.timestamp!) > Int(message2.timestamp!)

		})
		DispatchQueue.main.async(execute: {self.tableView.reloadData()})
	}


	// New Message
	@objc func handleNewMessage() {
		let newConversationVC = NewConversationVC()
		newConversationVC.messagesController = self
		let navController = UINavigationController(rootViewController: newConversationVC)
		present(navController, animated: true, completion: nil)
	}


	// Chat for User
	func showChatControllerForUser(_ lover: Lover) {
		let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
		chatLogController.lover = lover
		navigationController?.pushViewController(chatLogController, animated: true)
	}


	// Check Login
	func checkIfUserIsLoggedIn() {
		if Auth.auth().currentUser?.uid == nil {
			perform(#selector(handleLogout), with: nil, afterDelay: 0)
		} else {
			fetchUserAndSetupNavBarTitle()
		}
	}


	// Logout
	@objc func handleLogout() {
		do {try Auth.auth().signOut()} catch let logoutError {print(logoutError)}
		let loginController = LoginController()
		loginController.messagesController = self
		present(loginController, animated: true, completion: nil)
	}


	// Fetch User and set Title for person chatting with
	func fetchUserAndSetupNavBarTitle() {
		guard let uid = Auth.auth().currentUser?.uid else {	return }
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dict = snapshot.value as? [String: String] {
				let lover = Lover(dictionary: dict)
				lover.setValuesForKeys(dict)
				self.setupNavBarWithUser(lover)
			}
		}, withCancel: nil)
	}


	// Setup Nav Bar with User
	func setupNavBarWithUser(_ lover: Lover) {
		messages.removeAll()
		messagesDictionary.removeAll()
		tableView.reloadData()
		observeUserMessages()
		let titleView = UIView()
		titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		titleView.addSubview(containerView)
		let profileImageView = UIImageView()
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.contentMode = .scaleAspectFill
		profileImageView.layer.cornerRadius = 20
		profileImageView.clipsToBounds = true
		if let profileImageUrl = lover.profileImageUrl {
			profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
		}
		containerView.addSubview(profileImageView)
		profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
		profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		let nameLabel = UILabel()
		containerView.addSubview(nameLabel)
		nameLabel.text = lover.name
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
		nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
		nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
		containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
		containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
		self.navigationItem.titleView = titleView
	}

}



// MARK: TableView Delegate & Datasource
extension ConversationsVC {

	// Number of Rows In Section
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}


	// Cell for Row at
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LoverCell
		let message = messages[indexPath.row]
		cell.message = message
		return cell
	}


	// Height for Row at
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}


	// Did Select Row at
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let message = messages[indexPath.row]
		guard let chatPartnerId = message.chatPartnerId() else { return}
		let ref = Database.database().reference().child("users").child(chatPartnerId)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String: String] else { return }
			let lover = Lover(dictionary: dictionary)
			lover.id = chatPartnerId
			self.showChatControllerForUser(lover)
		}, withCancel: nil)
	}

}


