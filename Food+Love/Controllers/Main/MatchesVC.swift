
import UIKit
import Firebase


class MatchesVC: UIViewController {

	// MARK: Outlet Properties
	@IBOutlet var matchesTableView: UITableView!
	@IBOutlet weak var matchesCollectionView: UICollectionView!

	
	// MARK: Properties
	var timer: Timer?
	var messages = [Message]()
	var messagesDictionary = [String: Message]()
	var matches = [Lover]()


	// MARK: view Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		checkIfUserIsLoggedIn()
		matchesTableView.delegate = self
		matchesTableView.dataSource = self
		matchesTableView.register(LoverCell.self, forCellReuseIdentifier: "ConversationsCell")
	}


	// MARK: Helper Methods

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
		DispatchQueue.main.async(execute: {self.matchesTableView.reloadData()})
	}


	// Chat for User
	func showChatControllerForUser(_ lover: Lover) {
		let chatLogController = ConversationVC(collectionViewLayout: UICollectionViewFlowLayout())
		chatLogController.lover = lover
		navigationController?.pushViewController(chatLogController, animated: true)
	}


	// Check Login
	func checkIfUserIsLoggedIn() {
			fetchUserAndSetupNavBarTitle()
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
		matchesTableView.reloadData()
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
extension MatchesVC: UITableViewDataSource, UITableViewDelegate {

	// Number of Rows In Section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if messages.count > 0 { return messages.count}
		return 3
	}


	// Cell for Row at
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if messages.isEmpty {return UITableViewCell()}
		let message = messages[indexPath.row]
//		let match = messages[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsCell", for: indexPath) as! LoverCell
		cell.message = message
		return cell
	}


	// Height for Row at
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}


	// Did Select Row at
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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



// MARK: CollectionView - Datasource
extension MatchesVC: UICollectionViewDataSource {
	//Number of items in Section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if matches.isEmpty {return 4}
		return matches.count
	}

	// setup for each cell
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if matches.isEmpty {return collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath)}
//		guard let matches = matches else {return collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath)}
		let match = matches[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath) //as! MatchesCell
//		cell.configureCell(object: customObject)
		return cell
	}
}


// MARK: CollectionView - Delegate
extension MatchesVC: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) //as! CustomCell
	}
}


//MARK: CollectionView - Delegate Flow Layout
extension MatchesVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numCells: CGFloat = 2
		let spaceBetweenCells: CGFloat = 10.0
		let numSpaces: CGFloat = numCells + 1
		let cellWidth = (collectionView.layer.bounds.width - (spaceBetweenCells * numSpaces))/numCells
		let cellHeight = collectionView.layer.bounds.height * 0.95
		let cellSize = CGSize(width: cellWidth, height: cellHeight)
		return cellSize
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

