
//  DiscoverVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


class MatchesVC: UIViewController {

	// MARK: Outlet Properties
	@IBOutlet weak var matchesCollectionView: UICollectionView!
	@IBOutlet weak var conversationsTableView: UITableView!

	// MARK: Properties
	var timer: Timer!
	var matches = [Lover]() {
		didSet {
			DispatchQueue.main.async {
				self.matchesCollectionView.reloadData()
			}
		}
	}
	var conversations = [Message](){
		didSet {
			DispatchQueue.main.async {
				self.conversationsTableView.reloadData()
			}
		}
	}
	var conversationsDict = [String: Message]()

    var currentLover: Lover! {
        didSet {
           // loadMatches()
            getAllMatchedLover()
        }
    }

	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableview()
		setupCollectionView()
		//getAllLoversExceptCurrent()
        loadCurrentUserProfile()
		getNewMessages()
		setupNavBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}

	//Setup Tableview
	private func setupTableview(){
		conversationsTableView.dataSource = self
		conversationsTableView.delegate = self
		conversationsTableView.allowsMultipleSelectionDuringEditing = true
	}

	private func setupCollectionView(){
		matchesCollectionView.dataSource = self
		matchesCollectionView.delegate = self
	}

	private func setupNavBar(){
		let image : UIImage = #imageLiteral(resourceName: "Logo3")
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.navigationItem.titleView = imageView
	}




	// MARK: Helper Methods

	func getLover() -> Lover {
		var lover: Lover?
		if let uid = Auth.auth().currentUser?.uid {
			DBService.manager.getLoversRef().child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
				if let dict = snapshot.value as? [String: AnyObject] {
					lover = Lover(dictionary: dict)
				}
			}, withCancel: nil)
		}
		return lover!
	}



	func getLover(uid: String) -> Lover {
		var lover: Lover!
		Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
			if let userInfoDict = snapshot.value as? [String : AnyObject] {
				lover = Lover(dictionary: userInfoDict)
			}
		}, withCancel: nil)
		return lover
	}


	// Add current user info to Nav Bar center
	func addUserInfoToNavBar(_ user: Lover){
		conversations.removeAll()
		conversationsDict.removeAll()
		conversationsTableView.reloadData()
		getNewMessages()
	}



    func loadCurrentUserProfile() {
        DBService.manager.getCurrentLover { (onlineLover, error) in
            if let lover = onlineLover {
                self.currentLover = lover
            }
            if let error = error {
                print("loading current user error: \(error)")
            }
        }
    }
    
//    private func loadMatches() {
//        guard let followers = self.currentLover.followers, let following = self.currentLover.following else {return}
//        let followerUids = Array(followers.values)
//        let followingUids = Array(following.values)
//        var matchedUids = [String]()
//        for uid in followerUids {
//            if followingUids.contains(uid) {
//                matchedUids.append(uid)
//            }
//        }
//
//        for uid in matchedUids {
//      //Database.database().reference().child("lovers").child(uid).queryOrderedByKey()
//            Database.database().reference().child("lovers").child(uid)
//            .observe(.value, with: { (snapshot) in
//                print("~~~~~~~~~~~~~~~")
//                print("uid is : \(uid)")
//                print("snapshot is : \(snapshot)")
//                if let dict = snapshot.value as? [String: AnyObject]{
//                    let lover = Lover(dictionary: dict)
//                  let index = self.matches.index(where: {$0.id == lover.id})
//                    if index == nil {
//                    self.matches.append(lover)
//                    }
//                } else {
//                    print("error getting snapshot value: match snapsho have is nil")
//                }
//            })
//        }
//    }
    
    func getAllMatchedLover() {
        guard let followers = self.currentLover.followers, let following = self.currentLover.following else {return}
        let followerUids = Array(followers.values)
        let followingUids = Array(following.values)
        var matchedUids = [String]()
        for uid in followerUids {
            if followingUids.contains(uid) {
                matchedUids.append(uid)
            }
        }
        
        Database.database().reference().child("lovers").observe(.value) { (snapshot) in
             var onlineMatches = [Lover]()
            for child in snapshot.children {
                let childDataSnapshot = child as! DataSnapshot
                let key = childDataSnapshot.key
                if matchedUids.contains(key) {
                if let dict = childDataSnapshot.value as? [String: AnyObject] {
                    let lover = Lover(dictionary: dict)
                    onlineMatches.append(lover)
                }
                }
            }
            self.matches = onlineMatches
        }
    }

	// Matches
	func getNewMessages() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let userMessageRef = DBService.manager.getConversationsRef().child(uid)

		// Observe for New Messages
		userMessageRef.observe(.childAdded, with: { (snapshot) in
			let userId = snapshot.key
			userMessageRef.child(userId).observe(.childAdded, with: { (mSnapshot) in
				let messageId = mSnapshot.key
				let messagesReference = DBService.manager.getMessagesRef().child(messageId)
				messagesReference.observeSingleEvent(of:.value, with: { (snapshot) in
					if let dict = snapshot.value as? [String: AnyObject] {
						let message = Message(dictionary: dict)
						let chatPartnerID = message.partnerId()
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
		userMessageRef.observe(.childRemoved, with: { (snapshot) in
			self.conversationsDict.removeValue(forKey: snapshot.key)
		}, withCancel: nil)
	}


	// Get Message with message ID
	fileprivate func getMessageWithID(_ messageId: String) {
		let messagesReference = DBService.manager.getMessagesRef().child(messageId)
		messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let message = Message(dictionary: dictionary)
				let chatPartnerId = message.partnerId()
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
			return Int(conversation1.timeStamp!) > Int(conversation2.timeStamp!)
		})
		DispatchQueue.main.async(execute: {self.conversationsTableView.reloadData()})
	}

}



//////////////////////// Matches CollectionView ////////////////////////
//MARK: CollectionView Datasource
extension MatchesVC: UICollectionViewDataSource {
	//Number of items in Section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return matches.isEmpty ? 0 : matches.count
	}

	//setup for each cell
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if matches.isEmpty {return collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath) as! MatchesCell}
        
		let match = matches[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchesCell", for: indexPath) as! MatchesCell
       // cell.layoutIfNeeded()
        cell.layoutIfNeeded()
        cell.matchImageView.image = nil
        cell.configureCell(match: match)
		return cell
	}
}

//MARK: CollectionView Delegate
extension MatchesVC: UICollectionViewDelegate {
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
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}

	//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//		print("pressed did Select in TableView Matches VC")
	//		let conversation = conversations[indexPath.row]
	//		let chartPartnerId = conversation.chatPartnerId()
	//		let loverRef = DBService.manager.getLoversRef().child(chartPartnerId)
	//		loverRef.observeSingleEvent(of: .value, with: { (snapshot) in
	//			guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
	//			let lover = Lover(dictionary: dictionary)
	//			if lover.id == chartPartnerId {
	//				print("go to chat")
	////				self.showChat(lover)
	//			}
	//		}, withCancel: nil)
	//	}

	//Can Edit row
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	// Editing Style
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let conversations = self.conversations[indexPath.row]
		DBService.manager.getConversationsRef().child(uid).child(conversations.partnerId()).removeValue { (error, ref) in

			//		Database.database().reference().child("user-messages").child(uid).child(conversations.chatPartnerId()).removeValue { (error, ref) in
			if error != nil { print(error!) ; return}
			self.conversations.remove(at: indexPath.row)
			self.conversationsTableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

}

// MARK: - Navigation
extension MatchesVC {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let chatVC = segue.destination as! ChatVC
		//Matches
		if sender is UICollectionViewCell {
			guard let indexPath1 = matchesCollectionView.indexPath(for: sender as! UICollectionViewCell) else {return}
			chatVC.partner = matches[indexPath1.row]
			chatVC.partnerId = matches[indexPath1.row].id
		}
		//Conversations
		if sender is UITableViewCell {
			guard let indexPath2 = conversationsTableView.indexPath(for: sender as! UITableViewCell) else {return}
			var selectedLover: Lover?
			var selectedLoverImage: UIImage?
			let conversation = conversations[indexPath2.row]

			//TODO: get partner - send partner info and uiimage
			chatVC.partnerId = conversations[indexPath2.row].partnerId()

			//get lover
			DBService.manager.retrieveLover(loverId: chatVC.partnerId, completionHandler: { (onlineLover) in
					selectedLover = onlineLover
			})
			if let selectedLover = selectedLover {
				//get image
				guard let imageUrl = selectedLover.profileImageUrl else {return}
				ImageService.manager.getImage(from: imageUrl, completionHandler: { (onlineImage) in
					selectedLoverImage = onlineImage
				}, errorHandler: { (error) in
					print(error)
					})
				if let image = selectedLoverImage {
					chatVC.partnerImage = image
					chatVC.partner = selectedLover
				}
			}
			conversationsTableView.deselectRow(at: indexPath2, animated: true)
		}
	}
}

