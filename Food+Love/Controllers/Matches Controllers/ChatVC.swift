
//  ChatVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation


class ChatVC: UIViewController {


	// MARK: Outlets
	@IBOutlet weak var chatCollectionView: UICollectionView!
	@IBOutlet weak var profileImage: UIImageViewX!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var inputText: UITextField!


	// MARK: Properties
	var loverId: String!
	var messages = [Message]()


	// MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		tabBarController?.tabBar.isHidden = true
		getMessages()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		tabBarController?.tabBar.isHidden = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.8270000219, green: 0.3529999852, blue: 0.2160000056, alpha: 1)
		view.alpha = 1.0
		configureNavBar()
		chatCollectionView.delegate = self
		chatCollectionView.dataSource = self
		inputText.delegate = self
		tabBarController?.tabBar.isHidden = true
		//setup Lover
		DBService.manager.retrieveLover(loverId: loverId, completionHandler: { (onlineLover) in
			if let myLover = onlineLover {
				self.name.text = myLover.name
				if let image = myLover.profileImageUrl{
					self.profileImage.loadImageUsingCacheWithUrlString(image)
				}
			}
		})
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		NotificationCenter.default.removeObserver(self)
	}


	// MARK: Actions
	@IBAction func sendButtonPressed(){
		if inputText.text == "" {return}
		else {
			sendMessage(["text": inputText.text! as AnyObject])
		}
	}

	@IBAction func photoButtonPressed(_ sender: UIButton) {
		//open camera for photo
		upload()

	}

	@IBAction func smileyButtonPressed(_ sender: UIButton) {
		//add smiley photo
		print("smileyButton pressed")
	}



	private func configureNavBar() {
//		navigationItem.title = lover?.name
		let videoChatBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camcorder"), style: .plain, target: self, action: #selector(startVideoChat))
		navigationItem.rightBarButtonItem = videoChatBarItem
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


	// Height for Text
	fileprivate func estimatedHeightBasedOnText(text: String) -> CGRect{
		let size = CGSize.init(width: 200, height: 1000)
		let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString.init(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
	}


	///////////////////// MESSAGES  //////////////////////
	func getMessages() {
		guard let uid = Auth.auth().currentUser?.uid, let toId = loverId else {return}
		let loverMessageRef = DBService.manager.getLoverMessagesRef().child(uid).child(toId)
		loverMessageRef.observe(.childAdded, with: { (snapshot) in
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
		let toId = loverId
		let fromId = Auth.auth().currentUser!.uid
		let timeStamp = NSNumber.init(value: Date().timeIntervalSince1970)
		var values: [String : AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timeStamp":timeStamp]
		values = values.merged(with: property)
		childRef.updateChildValues(values)
		childRef.updateChildValues(values) { (error, ref) in
			if error != nil { print(error!); return}
			self.inputText.text = "" //nil
			let loverMessageRef = DBService.manager.getLoverMessagesRef().child(fromId).child(toId!)
			let messageId = childRef.key
			loverMessageRef.updateChildValues([messageId: 1])
			let recipentUserMessageRef = DBService.manager.getLoverMessagesRef().child(toId!).child(fromId)
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
				if let thumbnailImage = self.thumnailImageForPrivateVideoUrl(videoUrl: videoURL){
					self.uploadToFirebaseStorage(thumbnailImage, completion: { (imageUrl) in
						let properties: [String: AnyObject] = ["imageUrl":imageUrl,"imageWidth":thumbnailImage.size.width , "imageHeight":thumbnailImage.size.height,"videoUrl": videoUrl] as [String: AnyObject]
						self.sendMessage(properties)
					})
				}
			}
		})
		// UPLOAD PROGRESS
		uploadTask.observe(.progress) { (snapshot) in
			print(snapshot.progress?.completedUnitCount ?? " ")
		}
	}

	// Thumbnail of Video
	private func thumnailImageForPrivateVideoUrl(videoUrl: URL) -> UIImage?{
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

	// Image
	@objc func upload() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		imagePickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
		present(imagePickerController, animated: true, completion: nil)
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

}


///////////////////////// TextField /////////////////////////
// MARK: TextField Delegate
extension ChatVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if inputText.text != "" {
			sendMessage(["text": inputText.text! as AnyObject])
		}
		textField.resignFirstResponder()
		return true
	}
}



///////////////////////// Image Picker /////////////////////////
// MARK: ImagePicker for Photo & Video
extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// pick Image or Video
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
			selectedVideoForUrl(videoURL: videoURL)
		} else {
			selectedImageForInfo(info: info as [String : AnyObject])
		}
		dismiss(animated: true, completion: nil)
	}

	// Cancel Image
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
		cell.chatVC = self
		cell.configureCell(message: message)
		return cell
	}
}

// MARK: CollectionView Delegate
extension ChatVC: UICollectionViewDelegate {


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
		return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 0, right: 5.0)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2.0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
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


//////////////////////////////
// MARK: KEYBOARD Handling
//extension ChatVC {
/*
func setUpKeyboardObservers() {
NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
}

@objc func keyboardDidShow() {
if messages.count > 0 {
let indexpath = NSIndexPath.init(item: self.messages.count-1, section: 0)
//			self.collectionView?.scrollToItem(at: indexpath as IndexPath, at: .top, animated: true)
}
}

@objc func keyboardWillShow(notification: NSNotification) {
let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
//		containerViewBottomAncher?.constant = -keyboardFrame!.height
UIView.animate(withDuration: keyboardDuration!) {
self.view.layoutIfNeeded()
}
}

@objc func keyboardWillHide(notification: NSNotification){
//		containerViewBottomAncher?.constant = 0
let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
UIView.animate(withDuration: keyboardDuration!) {
self.view.layoutIfNeeded()
}
}
*/
//}

