//  DiscoverVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.



import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MatchesVC: UIViewController {

	// MARK: Outlet Properties
	@IBOutlet var matchesTableView: UITableView!
	@IBOutlet weak var conversationsCollectionView: UICollectionView!

	
	// MARK: Properties
	var timer: Timer!
	var matches = [Lover]() {
		didSet {
			DispatchQueue.main.async { self.conversationsCollectionView.reloadData() }
		}
	}
	var conversations = [Message](){
		didSet {
			DispatchQueue.main.async { self.matchesTableView.reloadData() }
		}
	}
	var conversationsDict = [String: Message](){
		didSet {
			DispatchQueue.main.async { self.matchesTableView.reloadData() }
		}
	}


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableview()
		setupcollectionView()
		getAllLovers()
		observeUserMessages()
		fetchUser()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}

	//Setup Tableview
	func setupTableview(){
		matchesTableView.delegate = self
		matchesTableView.dataSource = self
		matchesTableView.allowsMultipleSelectionDuringEditing = true
	}

	func setupcollectionView(){
		conversationsCollectionView.delegate = self
		conversationsCollectionView.dataSource = self
	}


	// Get currentUser info from database
	func getUserInfoFromDatabase() -> Lover {
		let uid = Auth.auth().currentUser?.uid
		var lover: Lover!
		Database.database().reference().child("lovers").child(uid!).observe(.value, with: { (snapshot) in
			if let userInfoDict = snapshot.value as? [String : AnyObject] {
				lover = Lover(dictionary: userInfoDict)
			}
		}, withCancel: nil)
		return lover
	}

	// Show Conversation with User
	func showConversationWithUser(lover: Lover) {
		//		let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
		let chatVC = ChatVC()
		chatVC.lover = lover
		navigationController?.pushViewController(chatVC, animated: true)
	}
	


	// MARK: Helper Methods
	func getAllLovers() {
		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject]{
				let lover = Lover(dictionary: dict)
				lover.id = snapshot.key
				if lover.id != Auth.auth().currentUser?.uid {
					self.matches.append(lover)
				}
			}
		}, withCancel: nil)
	}



	// Matches
	func observeUserMessages() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let ref = Database.database().reference().child("user-messages").child(uid)

		// Observe for New Messages
		ref.observe(.childAdded, with: { (snapshot) in
			print(snapshot)
			let userId = snapshot.key
			Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (mSnapshot) in
				let messageId = mSnapshot.key
				let messagesReference = Database.database().reference().child("messages").child(messageId)
				messagesReference.observeSingleEvent(of:.value, with: { (snapshot) in
					if let dict = snapshot.value as? [String: AnyObject] {
						let message = Message(dictionary: dict)
						let chatPartnerID = message.chatPartnerId()
						self.conversationsDict[chatPartnerID] = message
						self.conversations = Array(self.conversationsDict.values)
						self.conversations =  self.conversations.sorted(by: { (message1, message2) -> Bool in
							return Date.init(timeIntervalSince1970: Double(message1.timeStamp!)) > Date.init(timeIntervalSince1970: Double(message2.timeStamp!))
						})
						self.reloadTable()
					}
				}, withCancel: nil)
			}, withCancel: nil)
		}, withCancel: nil)

		// Observe for Delete Messages
		ref.observe(.childRemoved, with: { (snapshot) in
			self.conversationsDict.removeValue(forKey: snapshot.key)
		}, withCancel: nil)
	}


	// Fetch Message with message ID
	fileprivate func fetchMessageWithMessageId(_ messageId: String) {
		let messagesReference = Database.database().reference().child("messages").child(messageId)
		messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let message = Message(dictionary: dictionary)
				let chatPartnerId = message.chatPartnerId()
				self.conversationsDict[chatPartnerId] = message
				self.attemptReloadOfTable()
			}
		}, withCancel: nil)
	}


	// (Timer) Attempt to Reload Table
	fileprivate func attemptReloadOfTable() {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
	}


	// Reload Table
	@objc func reloadTable() {
		self.conversations = Array(self.conversationsDict.values)
		self.conversations.sort(by: { (conversation1, conversation2) -> Bool in
			// return message1.timestamp?.int32Value > message2.timestamp?.int32Value
			return Int(conversation1.timeStamp!) > Int(conversation2.timeStamp!)
		})
		DispatchQueue.main.async(execute: {self.matchesTableView.reloadData()})
	}


	// Chat for User
	func showChatControllerForUser(_ lover: Lover) {
//		let chatLogController = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
		let chatLogController = ChatVC()
		chatLogController.lover = lover
		navigationController?.pushViewController(chatLogController, animated: true)
	}


	// Fetch User and set Title for person chatting with
	func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else {	return }
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject] {
				let lover = Lover(dictionary: dict)
			}
		}, withCancel: nil)
	}


	// Add current user info to Nav Bar center
	func addUserInfoToNavBar(_ user: Lover){
		conversations.removeAll()
		conversationsDict.removeAll()
		matchesTableView.reloadData()
		observeUserMessages()
	}

}




//////////////////////// Matches CollectionView ////////////////////////
//MARK: CollectionView Datasource
extension MatchesVC: UICollectionViewDataSource {
	//Number of items in Section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return matches.count
	}

	//setup for each cell
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if matches.isEmpty {return collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath) as! MatchesCell}
		let match = matches[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath) as! MatchesCell
		cell.configureCell(match: match)
		return cell
	}
}

//MARK: CollectionView Delegate
extension MatchesVC: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedMatch = matches[indexPath.row]
		showConversationWithUser(lover: selectedMatch)
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
}

//MARK: CollectionView - Delegate Flow Layout
extension MatchesVC: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numCells: CGFloat = 3.5
		let numSpaces: CGFloat = numCells + 1
		let screenWidth = UIScreen.main.bounds.width
		let screenHeight = UIScreen.main.bounds.height
		return CGSize(width: (screenWidth - (10.0 * numSpaces)) / numCells, height: screenHeight * 0.16)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 0, right: 5.0)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}
}



//////////////////////// Conversation TableView ////////////////////////
// MARK: TableView Datasource
extension MatchesVC: UITableViewDataSource {
	// Number of Rows In Section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversations.count
	}

	// Cell for Row at
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let conversation = conversations[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
		cell.configureCell(conversation: conversation)
		return cell
	}

}

// MARK: TableView Delegate & Datasource
extension MatchesVC: UITableViewDelegate {

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Conversations"
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 25
	}

	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
		header.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
		header.textLabel?.textColor = UIColor.red
		header.textLabel?.textAlignment = NSTextAlignment.left
		header.backgroundColor = .white
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let conversation = conversations[indexPath.row]
		let chartPartnerId = conversation.chatPartnerId()
		let ref = Database.database().reference().child("lovers").child(chartPartnerId)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
			let lover = Lover(dictionary: dictionary)
			lover.id = chartPartnerId
			self.showConversationWithUser(lover: lover)
		}, withCancel: nil)
	}

	//Can Edit row
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	// Editing Style
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let conversations = self.conversations[indexPath.row]
		Database.database().reference().child("user-messages").child(uid).child(conversations.chatPartnerId()).removeValue { (error, ref) in
			if error != nil { print(error!) ; return}
			self.conversations.remove(at: indexPath.row)
			self.matchesTableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

}


