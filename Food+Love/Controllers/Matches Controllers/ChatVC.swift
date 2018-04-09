
//  ChatVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos
import MobileCoreServices
import AVFoundation
import CoreLocation


class ChatVC: UIViewController {

	// MARK: Outlets
	@IBOutlet weak var profileImage: UIImageViewX!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var foodsLabel: UILabel!
	@IBOutlet weak var bioLabel: UILabel!
	@IBOutlet weak var chatCollectionView: UICollectionView!
	@IBOutlet weak var inputTextField: UITextField!
	@IBOutlet weak var sendContainerBottom: NSLayoutConstraint!


	// MARK: Properties
	var currentUser = Auth.auth().currentUser!
	var partner: Lover!
	var partnerId: String!
	var partnerImage: UIImage!
	var messages = [Message]()
	var canSendLocation = true
	let locationManager = CLLocationManager()


	// MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupKeyboardObservers()
		configureNavBar()
		setupTextField()
		setupCollectionView()
		setupLocation()
		getMessages()
		//setup Lover
		DBService.manager.retrieveLover(loverId: partnerId, completionHandler: { (onlineLover) in
			if let myLover = onlineLover {
				self.name.text = myLover.name
				if let first = myLover.firstFoodPrefer, let second = myLover.secondFoodPrefer, let third = myLover.thirdFoodPrefer {
					self.foodsLabel.text = first + ", " + second + ", & " + third
				} else {
					self.foodsLabel.text = "Chinese, Italian, & Japanese"
				}
				if let dob = myLover.dateOfBirth {
					let age = myLover.convertBirthDayToAge(dob: dob)
					self.bioLabel.text = "\(age!), Astoria"
				} else {
					self.bioLabel.text = "28, Astoria"
				}
				if let imageStr = myLover.profileImageUrl{
					ImageService.manager.getImage(from: imageStr, completionHandler: { (onlineImage) in
						self.partnerImage = onlineImage
						self.profileImage.image = onlineImage
					}, errorHandler: { (error) in
						print(error)
					})
				}
			}
		})

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		tabBarController?.tabBar.isHidden = false
		NotificationCenter.default.removeObserver(self)
	}

	private func configureNavBar() {
		let videoChatBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camcorder"), style: .plain, target: self, action: #selector(startVideoChat))
		let planDateBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: .plain, target: self, action: #selector(planDate))
		navigationItem.rightBarButtonItems = [videoChatBarItem, planDateBarItem]
	}

	@objc private func startVideoChat(lover: Lover) {
		let alertView = UIAlertController(title: "Are you sure you on Wifi?", message: nil, preferredStyle: .alert)
		let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
			let videoVC = VideoVC(lover: lover)
			self.navigationController?.pushViewController(videoVC, animated: true)
		}
		let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alertView.addAction(yesOption)
		alertView.addAction(noOption)
		present(alertView, animated: true, completion: nil)
	}

	@objc private func planDate() {
		let planDateVC = MakeDateVC()
		guard let fromUser = Auth.auth().currentUser?.uid else {return}
		guard let toUser = partnerId else {return}
		planDateVC.fromUser = fromUser
		planDateVC.toUser = toUser
		navigationController?.pushViewController(planDateVC, animated: true)
	}

	fileprivate func setupKeyboardObservers(){
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}

	fileprivate func setupTextField(){
		inputTextField.delegate = self
	}

	fileprivate func setupLocation(){
		self.locationManager.delegate = self
	}

	fileprivate func setupCollectionView(){
		//CollectionView
		chatCollectionView.delegate = self
		chatCollectionView.dataSource = self
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector (collectionViewTapped))
		chatCollectionView.addGestureRecognizer(tapGesture)
	}

	@objc fileprivate func collectionViewTapped() {
		inputTextField.resignFirstResponder()
	}

	// Keyboard
	@objc fileprivate func keyboardWillShow(notification: Notification) {
		guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
			let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
		let keyboardHeight = keyboardFrame.cgRectValue.height
		self.sendContainerBottom.constant = keyboardHeight

		UIView.animate(withDuration: animationDuration.doubleValue) {
			self.view.layoutIfNeeded()
			if self.messages.count > 0 {
				self.chatCollectionView.scrollToItem(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
			}
		}

	}

	@objc fileprivate func keyboardWillHide(notification: Notification) {
		guard let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
		self.sendContainerBottom.constant = 0
		UIView.animate(withDuration: animationDuration.doubleValue) {
			self.view.layoutIfNeeded()
		}
	}


	// MARK: Actions
	@IBAction func sendButtonPressed(){
		if inputTextField.text == "" {return}
		else {
			sendMessage(["text": inputTextField.text! as AnyObject])
		}
	}

	@IBAction func photoButtonPressed(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
		present(imagePickerController, animated: true, completion: nil)
	}

	@IBAction func selectLocation(_ sender: Any) {
		print("location button pressed")
		canSendLocation = true
		if checkLocationPermission() {
			locationManager.startUpdatingLocation()
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
	}


	// Height for Text
	fileprivate func estimatedHeightBasedOnText(text: String) -> CGRect{
		let size = CGSize.init(width: 200, height: 1000)
		let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString.init(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
	}


	///////////////////// MESSAGES  //////////////////////
	func getMessages() {
		guard let uid = Auth.auth().currentUser?.uid, let toId = partnerId else {return}
		let conversationsRef = DBService.manager.getConversationsRef().child(uid).child(toId)
		conversationsRef.observe(.childAdded, with: { (snapshot) in
			let messageId = snapshot.key
			let messagesRef = DBService.manager.getMessagesRef().child(messageId)
			messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
				guard let dict = snapshot.value as? [String: AnyObject] else {return}
				let message = Message(dictionary: dict)
				self.messages.append(message)
				DispatchQueue.main.async {
					if let collectionView = self.chatCollectionView {
						collectionView.reloadData()
						let indexpath = NSIndexPath.init(item: self.messages.count-1, section: 0)
						collectionView.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
					}
				}
			}, withCancel: nil)
		}, withCancel: nil)
	}


	// Send Message
	fileprivate func sendMessage(_ property: [String: AnyObject]){
		let messagesRef = DBService.manager.getMessagesRef()
		let childRef = messagesRef.childByAutoId()
		let toId = partnerId
		let fromId = Auth.auth().currentUser!.uid
		let timeStamp = NSNumber.init(value: Date().timeIntervalSince1970)
		var values: [String : AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timeStamp":timeStamp]
		values = values.merged(with: property)
		childRef.updateChildValues(values)
		childRef.updateChildValues(values) { (error, ref) in
			if error != nil { print(error!); return}
			self.inputTextField.text = "" //nil
			let conversationsRef = DBService.manager.getConversationsRef().child(fromId).child(toId!)
			let messageId = childRef.key
			conversationsRef.updateChildValues([messageId: 1])
			let recipentUserMessageRef = DBService.manager.getConversationsRef().child(toId!).child(fromId)
			recipentUserMessageRef.updateChildValues([messageId: 1])
		}
	}

	// add Image to Message
	private func addImageToMessage(_ imageUrl: String , _ image: UIImage){
		sendMessage(["imageUrl": imageUrl,"imageWidth": image.size.width , "imageHeight":image.size.height] as [String: AnyObject])
	}

	// Select Video
	fileprivate func selectedVideoForUrl(videoURL: URL) {
		let fileName = NSUUID().uuidString+".mov"
		// UPLOAD
		let uploadTask = Storage.storage().reference().child("message_videos").child(fileName).putFile(from: videoURL, metadata: nil, completion: { (metadata, error) in
			if error != nil { print("Failed to upload the video:", error!)}
			if let videoUrl = metadata?.downloadURL()?.absoluteString {
				if let thumbnailImage = self.thumbnailImageForPrivateVideoUrl(videoUrl: videoURL){
					self.uploadToFirebaseStorage(thumbnailImage, completion: { (imageUrl) in
						let properties: [String: AnyObject] = ["imageUrl":imageUrl,"imageWidth":thumbnailImage.size.width , "imageHeight":thumbnailImage.size.height,"videoUrl": videoUrl] as [String: AnyObject]
						self.sendMessage(properties)
					})
				}
			}
		})
	}

	// Thumbnail of Video
	private func thumbnailImageForPrivateVideoUrl(videoUrl: URL) -> UIImage?{
		let asset = AVAsset.init(url: videoUrl)
		let imageGenerator = AVAssetImageGenerator.init(asset: asset)
		do {
			let thumbanailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
			return UIImage.init(cgImage: thumbanailCGImage)
		} catch { print(error) }
		return nil
	}


	// Select Image
	fileprivate func selectedImageForInfo(info: [String: AnyObject]) {
		var selectedImageFromPicker: UIImage?
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
		}else if let origionalImage = info["UIImagePickerControllerOrigionalImage"] as? UIImage {
			selectedImageFromPicker = origionalImage
		}
		if let selectedImage = selectedImageFromPicker {
			uploadToFirebaseStorage(selectedImage, completion: { (imageUrl) in
				self.addImageToMessage(imageUrl, selectedImage)
			})
		}
	}

	// UPLOAD Image to Firebase
	private func uploadToFirebaseStorage(_ image: UIImage, completion:@escaping (_ imageUrl: String) -> ()) {
		let imageName = NSUUID().uuidString
		let ref = Storage.storage().reference().child("message_images").child(imageName)
		if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
			ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
				if error != nil { print("Failed to Upload Image:",error!); return}
				if let imageUrl = metadata?.downloadURL()?.absoluteString {
					completion(imageUrl)
				}
			})
		}
	}

	//Location
	func checkLocationPermission() -> Bool {
		var state = false
		switch CLLocationManager.authorizationStatus() {
		case .authorizedWhenInUse:
			state = true
		case .authorizedAlways:
			state = true
		default: break
		}
		return state
	}
}



// MARK: TextField Delegate
extension ChatVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = inputTextField.text else {return false}
		if text == "" {return false}
		sendMessage(["text": inputTextField.text! as AnyObject])
		return true
	}
}



// MARK: ImagePicker for Photo & Video
extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// pick Image or Video
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		//Video
		if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
			selectedVideoForUrl(videoURL: videoURL)
		}
		//Photo
		else {
			selectedImageForInfo(info: info as [String : AnyObject])
		}
		dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}



///////////////////////// Collection View /////////////////////////
// MARK: CollectionView Datasource
extension ChatVC: UICollectionViewDataSource  {
	// # of items in section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.isEmpty ? 0 : messages.count
	}

	// Cell for item at
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let message = self.messages[indexPath.item]
		// User Message
		if message.fromId == Auth.auth().currentUser?.uid {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
			cell.chatVC = self
			cell.configureCell(message: message)
			return cell
		}
		// Partner Message
		else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerChatCell", for: indexPath) as! PartnerChatCell
			cell.chatVC = self
			cell.configureCell(message: message)
			cell.profileImageView.image = partnerImage
			return cell
		}
	}
}

// MARK: CollectionView Delegate
extension ChatVC: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if collectionView.isDragging {
			cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
			UIView.animate(withDuration: 0.3, animations: {
				cell.transform = CGAffineTransform.identity
			})
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.inputTextField.resignFirstResponder()
		// Image
		if let image = self.messages[indexPath.item].imageUrl {
			print("Image pressed")
//			if let photo = self.items[indexPath.row].image {
//				let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
//				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
		}
		// Video
		else if let video = self.messages[indexPath.item].videoUrl {
			print("Video pressed")

		}
		// Text
		else if let text = self.messages[indexPath.item].text {
			print("Text pressed")
		} else if let location = self.messages[indexPath.item].location {
			print("Location pressed")
				//			let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
				//			let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
				//			let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
				//			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
		}

	}

}


//MARK: CollectionView - Delegate Flow Layout
extension ChatVC: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 100
		let message = messages[indexPath.row]
		if let text = message.text {
			height = estimatedHeightBasedOnText(text: text).height + 20
		}else if let imageWidth = message.imageWidth?.floatValue , let imageHeight = message.imageHeight?.floatValue {
			height = CGFloat(imageHeight / imageWidth * 200)
		}
		return CGSize(width: view.frame.width, height: height)
	}


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}
}


extension ChatVC: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.locationManager.stopUpdatingLocation()
		if let lastLocation = locations.last {
			if self.canSendLocation {
				let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
				self.sendMessage(["location": coordinate as AnyObject])
				self.canSendLocation = false
			}
		}
	}
}


//////////////////////////////
// MARK: Zoom for Video
//extension ChatVC {
/*
// Zoom In
func zoomInForStartingImageView(startingImageView: UIImageView) {
//		self.startingImageView = startingImageView
//		self.startingImageView?.isHidden = true
//		startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
let zoomingImageView = UIImageView.init(frame: startingFrame!)
zoomingImageView.image = startingImageView.image
zoomingImageView.backgroundColor = UIColor.red
zoomingImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoomOut)))
zoomingImageView.isUserInteractionEnabled = true
if let keyWindow =  UIApplication.shared.keyWindow {
//			backBackgroundView = UIView.init(frame: keyWindow.frame)
//			if let backBackgroundView = backBackgroundView {
//				backBackgroundView.backgroundColor = UIColor.black
//				backBackgroundView.alpha = 0
keyWindow.addSubview(backBackgroundView)
}
keyWindow.addSubview(zoomingImageView)
UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
self.backBackgroundView!.alpha = 1
self.inputAccessoryView?.alpha = 0
let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
zoomingImageView.frame = CGRect.init(x: 0, y: 0, width: keyWindow.frame.width, height: height)
zoomingImageView.center = keyWindow.center
}, completion: nil)
}
}

// Zoom Out
@objc func zoomOut(tapGesture: UITapGestureRecognizer){
if let zoomOutImageView = tapGesture.view {
zoomOutImageView.layer.cornerRadius = 16
zoomOutImageView.clipsToBounds = true
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//				zoomOutImageView.frame = self.startingFrame!
self.backBackgroundView?.alpha = 0
self.inputAccessoryView?.alpha = 1
}, completion: { (completed) in
zoomOutImageView.removeFromSuperview()
//				self.startingImageView?.isHidden = false
})
}
}
*/

//}
