
import UIKit
import Firebase
import MobileCoreServices
import AVFoundation


class ConversationVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	// MARK: Properties
	var lover: Lover? {
		didSet {
			navigationItem.title = lover?.name
			observeMessages()
		}
	}
	var messages = [Message]()
	let cellId = "cellId"
	var startingFrame: CGRect?
	var blackBackgroundView: UIView?
	var startingImageView: UIImageView?
	var containerViewBottomAnchor: NSLayoutConstraint?



	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		collectionView?.alwaysBounceVertical = true
		collectionView?.backgroundColor = UIColor.white
		collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
		collectionView?.keyboardDismissMode = .interactive
		setupKeyboardObservers()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		collectionView?.collectionViewLayout.invalidateLayout()
	}


	// MARK: Helper Methods


	// FIREBASE
	private func configureNavBar() {
		self.navigationItem.title = "Video Chat"
		//right bar button for logging out
		let videoChatBarItem = UIBarButtonItem(title: "Video Chat", style: .plain, target: self, action: #selector(startVideoChat))
		navigationItem.rightBarButtonItem = videoChatBarItem
	}
	@objc private func startVideoChat() {
		let alertView = UIAlertController(title: "Are you sure you on Wifi?", message: nil, preferredStyle: .alert)
		let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
			////
		}
		let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alertView.addAction(yesOption)
		alertView.addAction(noOption)
		present(alertView, animated: true, completion: nil)
	}

	func observeMessages() {
		guard let uid = Auth.auth().currentUser?.uid,
			let toId = lover?.id else {return}
		let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
		userMessagesRef.observe(.childAdded, with: { (snapshot) in
			let messageId = snapshot.key
			let messagesRef = Database.database().reference().child("messages").child(messageId)
			messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
				guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
				self.messages.append(Message(dictionary: dictionary))
				DispatchQueue.main.async(execute: {
					self.collectionView?.reloadData()
					//scroll to the last index
					let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
					self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
				})
			}, withCancel: nil)
		}, withCancel: nil)
	}


	// Upload Tap
	@objc func handleUploadTap() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
		present(imagePickerController, animated: true, completion: nil)
	}


	// Video Selected for URL
	fileprivate func handleVideoSelectedForUrl(_ url: URL) {
		let filename = UUID().uuidString + ".mov"
		let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata, error) in
			if error != nil {
				print("Failed upload of video:", error!)
				return
			}
			if let videoUrl = metadata?.downloadURL()?.absoluteString {
				if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
					self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
						let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
						self.sendMessageWithProperties(properties)
					})
				}
			}
		})
		uploadTask.observe(.progress) { (snapshot) in
			if let completedUnitCount = snapshot.progress?.completedUnitCount {
				self.navigationItem.title = String(completedUnitCount)
			}
		}
		uploadTask.observe(.success) { (snapshot) in
			self.navigationItem.title = self.lover?.name
		}
	}


	// Thumbnail Image for file URL
	fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
		let asset = AVAsset(url: fileUrl)
		let imageGenerator = AVAssetImageGenerator(asset: asset)
		do {
			let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
			return UIImage(cgImage: thumbnailCGImage)
		} catch let err {print(err)}
		return nil
	}


	// Image Selected For Info
	fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
		var selectedImageFromPicker: UIImage?
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
		}
		if let selectedImage = selectedImageFromPicker {
			uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
				self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
			})
		}
	}


	// Upload Image to Firebase Storage
	fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
		let imageName = UUID().uuidString
		let ref = Storage.storage().reference().child("message_images").child(imageName)
		if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
			ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
				if error != nil {print("Failed to upload image:", error!); return}
				if let imageUrl = metadata?.downloadURL()?.absoluteString {
					completion(imageUrl)
				}
			})
		}
	}



	override var inputAccessoryView: UIView? {
		get {
			return inputContainerView
		}
	}


	override var canBecomeFirstResponder : Bool {
		return true
	}


	///////////////////////////////////
	// MARK: Keyboard

	// Setup Keyboard observers
	func setupKeyboardObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
	}

	// Keyboard did show
	@objc func handleKeyboardDidShow() {
		if messages.count > 0 {
			let indexPath = IndexPath(item: messages.count - 1, section: 0)
			collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
		}
	}

	// Keyboard will show
	func handleKeyboardWillShow(_ notification: Notification) {
		let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
		let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
		containerViewBottomAnchor?.constant = -keyboardFrame!.height
		UIView.animate(withDuration: keyboardDuration!, animations: {
			self.view.layoutIfNeeded()
		})
	}

	// Keyboard will hide
	func handleKeyboardWillHide(_ notification: Notification) {
		let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
		containerViewBottomAnchor?.constant = 0
		UIView.animate(withDuration: keyboardDuration!, animations: {
			self.view.layoutIfNeeded()
		})
	}


	// MARK: Configure Cell
	fileprivate func setupCell(_ cell: MessageCell, message: Message) {

		// PROFILE IMAGE
		if let profileImageUrl = self.lover?.profileImageUrl {
			cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
		}

		// USER OUTGOING MESSAGES
		if message.fromId == Auth.auth().currentUser?.uid {
			//outgoing blue
			cell.bubbleView.backgroundColor = MessageCell.blueColor
			cell.textView.textColor = UIColor.white
			cell.profileImageView.isHidden = true
			cell.bubbleViewRightAnchor?.isActive = true
			cell.bubbleViewLeftAnchor?.isActive = false
		}
			// INCOMING MESSAGES
		else {
			//incoming gray
			cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
			cell.textView.textColor = UIColor.black
			cell.profileImageView.isHidden = false

			cell.bubbleViewRightAnchor?.isActive = false
			cell.bubbleViewLeftAnchor?.isActive = true
		}

		// MESSAGE IMAGE
		if let messageImageUrl = message.imageUrl {
			cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
			cell.messageImageView.isHidden = false
			cell.bubbleView.backgroundColor = UIColor.clear
		} else {
			cell.messageImageView.isHidden = true // No image for message
		}
	}


	// MARK: FRAME FOR TEXT
	fileprivate func estimateFrameForText(_ text: String) -> CGRect {
		let size = CGSize(width: 200, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
	}


	///////////////////////////////////////////
	// SEND MESSAGES

	// Send Message
	@objc func handleSend() {
		let properties = ["text": inputTextField.text!]
		sendMessageWithProperties(properties as [String : AnyObject])
	}

	// Send Message with Image URL
	fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
		let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
		sendMessageWithProperties(properties)
	}

	// Send Message with Properties
	fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
		let ref = Database.database().reference().child("messages")
		let childRef = ref.childByAutoId()
		let toId = lover!.id!
		let fromId = Auth.auth().currentUser!.uid
		let timestamp = Int(Date().timeIntervalSince1970)
		var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
		//append properties dictionary onto values somehow??
		//key $0, value $1
		properties.forEach({values[$0] = $1})
		childRef.updateChildValues(values) { (error, ref) in
			if error != nil {
				print(error!)
				return
			}
			self.inputTextField.text = nil
			let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
			let messageId = childRef.key
			userMessagesRef.updateChildValues([messageId: 1])
			let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
			recipientUserMessagesRef.updateChildValues([messageId: 1])
		}
	}



	////////////////////////////////////////
	// Custom Zooming

	// ZOOM IN
	func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
		self.startingImageView = startingImageView
		self.startingImageView?.isHidden = true
		startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
		let zoomingImageView = UIImageView(frame: startingFrame!)
		zoomingImageView.backgroundColor = UIColor.red
		zoomingImageView.image = startingImageView.image
		zoomingImageView.isUserInteractionEnabled = true
		zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
		if let keyWindow = UIApplication.shared.keyWindow {
			blackBackgroundView = UIView(frame: keyWindow.frame)
			blackBackgroundView?.backgroundColor = UIColor.black
			blackBackgroundView?.alpha = 0
			keyWindow.addSubview(blackBackgroundView!)
			keyWindow.addSubview(zoomingImageView)
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.blackBackgroundView?.alpha = 1
				self.inputContainerView.alpha = 0
				let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
				zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
				zoomingImageView.center = keyWindow.center
			}, completion: { (completed) in
				//                    do nothing
			})
		}
	}

	// ZOOM OUT
	@objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
		if let zoomOutImageView = tapGesture.view {
			//need to animate back out to controller
			zoomOutImageView.layer.cornerRadius = 16
			zoomOutImageView.clipsToBounds = true
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				zoomOutImageView.frame = self.startingFrame!
				self.blackBackgroundView?.alpha = 0
				self.inputContainerView.alpha = 1
			}, completion: { (completed) in
				zoomOutImageView.removeFromSuperview()
				self.startingImageView?.isHidden = false
			})
		}
	}


	// MARK: Objects Properties
	lazy var inputTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter message..."
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.delegate = self
		return textField
	}()
	lazy var inputContainerView: UIView = {
		let containerView = UIView()
		containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
		containerView.backgroundColor = UIColor.white
		let uploadImageView = UIImageView()
		uploadImageView.isUserInteractionEnabled = true
		uploadImageView.image = UIImage(named: "upload_image_icon")
		uploadImageView.translatesAutoresizingMaskIntoConstraints = false
		uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
		containerView.addSubview(uploadImageView)
		uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
		uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
		uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let sendButton = UIButton(type: .system)
		sendButton.setTitle("Send", for: UIControlState())
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
		containerView.addSubview(sendButton)
		sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
		sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
		containerView.addSubview(self.inputTextField)
		self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
		self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
		self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
		let separatorLineView = UIView()
		separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		separatorLineView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(separatorLineView)
		separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
		separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		return containerView
	}()

}


////////////////////////////////////////
// MARK: Collection FlowLayout Delegate
extension ConversationVC {

	// Number of Items in Section
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}

	// Cell for row at
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
		cell.chatLogController = self
		let message = messages[indexPath.item]
		cell.message = message
		cell.textView.text = message.text
		setupCell(cell, message: message)
		if let text = message.text {
			//a text message
			cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
			cell.textView.isHidden = false
		} else if message.imageUrl != nil {
			//fall in here if its an image message
			cell.bubbleWidthAnchor?.constant = 200
			cell.textView.isHidden = true
		}
		cell.playButton.isHidden = message.videoUrl == nil
		return cell
	}

}


////////////////////////////////////////
// MARK: Collection Datasource
extension ConversationVC {
	// Layout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 80
		let message = messages[indexPath.item]
		if let text = message.text {
			height = estimateFrameForText(text).height + 20
		} else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
			// h1 / w1 = h2 / w2
			// solve for h1
			// h1 = h2 / w2 * w1
			height = CGFloat(imageHeight / imageWidth * 200)
		}
		let width = UIScreen.main.bounds.width
		return CGSize(width: width, height: height)
	}

}



///////////////////////////////////
// MARK: TextField Delegate
extension ConversationVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		handleSend()
		return true
	}
}



///////////////////////////////////
// MARK Image Picker
extension ConversationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// Pick Media (Video, Photo)
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
			handleVideoSelectedForUrl(videoUrl) //selected a video
		} else {
			handleImageSelectedForInfo(info as [String : AnyObject]) //selected an image
		}
		dismiss(animated: true, completion: nil)
	}

	// Cancel Image
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

}




