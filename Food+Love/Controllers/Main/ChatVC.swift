
import UIKit
import Firebase
import MobileCoreServices
import AVFoundation


class ChatVC: UIViewController {

	// MARK: Properties
	var lover : Lover? {
		didSet {
			navigationItem.title = lover?.name
			observeMessages()
		}
	}
	var messages = [Message]()
	var startingFrame: CGRect?
	var backBackgroundView: UIView?
	var startingImageView: UIImageView?
	var containerViewBottomAnchor: NSLayoutConstraint?

	@IBOutlet weak var collectionView: UICollectionView!

	// ACTIONS:
	//Send Message
	@IBAction func sendButtonPressed(){
		if inputTextField.text == "" {return}
		else {
			sendMessageWithProperty(["text":inputTextField.text! as AnyObject])
		}
	}



	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		self.configureSendContainer()
		setUpKeyboardObservers()
		configureNavBar()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Helper Functions
	func setupCollectionView(){
//		collectionView?.backgroundColor = UIColor.white
//		collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
//		collectionView?.alwaysBounceVertical = true
//		collectionView?.keyboardDismissMode = .interactive
	}

	private func configureNavBar() {
		let videoChatBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camcorder"), style: .plain, target: self, action: #selector(startVideoChat))
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

	// Objects
	var containerViewBottomAncher: NSLayoutConstraint?

	lazy var containerview: UIView = {
		let cView = UIView()
		cView.backgroundColor = UIColor.white
		return cView
	}()

	lazy var inputTextField: UITextField = {
		let inputTf = UITextField()
		inputTf.placeholder = "Enter Message ....."
		inputTf.translatesAutoresizingMaskIntoConstraints = false
		inputTf.delegate = self
		inputTf.backgroundColor = UIColor.clear
		return inputTf
	}()



	// Height for Text
	fileprivate func estimatedHeightBasedOnText(text: String) -> CGRect{
		let size = CGSize.init(width: 200, height: 1000)
		let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString.init(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
	}


	///////////////////////////////////////////
	// OBSERVE MESSAGES
	func observeMessages() {
		guard let uid = Auth.auth().currentUser?.uid,
			let toId = lover?.id
			else {return}

		let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId)

		userMessageRef.observe(.childAdded, with: { (snapshot) in
			let messageId = snapshot.key
			let messagesRef = Database.database().reference().child("messages").child(messageId)
			messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
				guard let dict = snapshot.value as? [String: AnyObject] else {return}
				let message = Message(dictionary: dict)
				self.messages.append(message)
				DispatchQueue.main.async {
//					self.collectionView?.reloadData()
					let indexpath = NSIndexPath.init(item: self.messages.count-1, section: 0)
//					self.collectionView?.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
				}
			}, withCancel: nil)
		}, withCancel: nil)
	}


	////////////////////// SEND MESSAGES //////////////////
	// Send Message
	fileprivate func sendMessageWithProperty(_ property: [String: AnyObject]){
		let ref = Database.database().reference().child("messages")
		let childRef = ref.childByAutoId()
		let toId = lover!.id
		let fromId = Auth.auth().currentUser!.uid
		let timeStamp = NSNumber.init(value: Date().timeIntervalSince1970)
		var values: [String : AnyObject] = ["toId":toId as AnyObject, "fromId":fromId as AnyObject, "timeStamp":timeStamp]
		values = values.merged(with: property)
		childRef.updateChildValues(values)
		childRef.updateChildValues(values) { (error, ref) in
			if error != nil { print(error!); return}
			self.inputTextField.text = nil
			let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId!)
			let messageId = childRef.key
			userMessageRef.updateChildValues([messageId: 1])
			let recipentUserMessageRef = Database.database().reference().child("user-messages").child(toId!).child(fromId)
			recipentUserMessageRef.updateChildValues([messageId: 1])
		}
	}

	// Send Message with Image
	private func sendMessageWithImageUrl(_ imageUrl: String , _ image: UIImage){
		sendMessageWithProperty(["imageUrl":imageUrl,"imageWidth":image.size.width , "imageHeight":image.size.height] as [String: AnyObject])
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
						self.sendMessageWithProperty(properties)
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
				self.sendMessageWithImageUrl(imageUrl, selectedImage)
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

	// UPLOAD Image  to Firebase
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


	//////// KEYBOARD //////////////
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
		containerViewBottomAncher?.constant = -keyboardFrame!.height
		UIView.animate(withDuration: keyboardDuration!) {
			self.view.layoutIfNeeded()
		}
	}

	@objc func keyboardWillHide(notification: NSNotification){
		containerViewBottomAncher?.constant = 0
		let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
		UIView.animate(withDuration: keyboardDuration!) {
			self.view.layoutIfNeeded()
		}
	}


	////////////////// SEND CONTAINER ///////////////////
	override var inputAccessoryView: UIView? {
		get { return containerview }
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}

	// Send container
	func configureSendContainer() {
		containerview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 50)
		let uploadImageView = UIImageView()
		uploadImageView.image = UIImage.init(named: "upload-image")
		uploadImageView.isUserInteractionEnabled = true
		uploadImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(upload)))
		uploadImageView.translatesAutoresizingMaskIntoConstraints = false
		containerview.addSubview(uploadImageView)
		uploadImageView.leftAnchor.constraint(equalTo: containerview.leftAnchor, constant: 10).isActive = true
		uploadImageView.centerYAnchor.constraint(equalTo: containerview.centerYAnchor).isActive = true
		uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
		uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let separatorView = UIView()
		separatorView.backgroundColor = UIColor.lightGray
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		containerview.addSubview(separatorView)
		separatorView.leftAnchor.constraint(equalTo: containerview.leftAnchor).isActive = true
		separatorView.rightAnchor.constraint(equalTo: containerview.rightAnchor).isActive = true
		separatorView.topAnchor.constraint(equalTo: containerview.topAnchor).isActive = true
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		let sendButton = UIButton(type: .system)
		sendButton.setTitle("Send", for: .normal)
		sendButton.translatesAutoresizingMaskIntoConstraints = false

		sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)

		containerview.addSubview(sendButton)
		sendButton.rightAnchor.constraint(equalTo: containerview.rightAnchor, constant: -20).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: sendButton.intrinsicContentSize.width).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: containerview.centerYAnchor).isActive = true
		sendButton.heightAnchor.constraint(equalTo: containerview.heightAnchor).isActive = true
		containerview.addSubview(inputTextField)
		inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor , constant: 10).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: containerview.centerYAnchor).isActive = true
		inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
		inputTextField.heightAnchor.constraint(lessThanOrEqualTo: containerview.heightAnchor).isActive = true
	}


	///////////////// ZOOM /////////////////////
	// Zoom In
	func zoomInForStartingImageView(startingImageView: UIImageView) {
		self.startingImageView = startingImageView
		self.startingImageView?.isHidden = true
		startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
		let zoomingImageView = UIImageView.init(frame: startingFrame!)
		zoomingImageView.image = startingImageView.image
		zoomingImageView.backgroundColor = UIColor.red
		zoomingImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoomOut)))
		zoomingImageView.isUserInteractionEnabled = true
		if let keyWindow =  UIApplication.shared.keyWindow {
			backBackgroundView = UIView.init(frame: keyWindow.frame)
			if let backBackgroundView = backBackgroundView {
				backBackgroundView.backgroundColor = UIColor.black
				backBackgroundView.alpha = 0
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
				zoomOutImageView.frame = self.startingFrame!
				self.backBackgroundView?.alpha = 0
				self.inputAccessoryView?.alpha = 1
			}, completion: { (completed) in
				zoomOutImageView.removeFromSuperview()
				self.startingImageView?.isHidden = false
			})
		}
	}
	
}


///////////////////////// TextField /////////////////////////
// MARK: TextField Delegate
extension ChatVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if inputTextField.text == "" {return false}
		else {
			sendMessageWithProperty(["text":inputTextField.text! as AnyObject])
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
extension ChatVC: UICollectionViewDataSource {
	// # of items in section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}

	// Cell for item at
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let message = self.messages[indexPath.item]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! ChatCell
		cell.chatVC = self
		cell.configureCell(message: message)
		return cell
	}
}

// MARK: CollectionView Delegate Flow Layout
extension ChatVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 80
		let message = messages[indexPath.row]
		if let text = message.text {
			height = estimatedHeightBasedOnText(text: text).height + 20
		}else if let imageWidth = message.imageWidth?.floatValue , let imageHeight = message.imageHeight?.floatValue {
			height = CGFloat(imageHeight / imageWidth * 200)
		}
		return CGSize.init(width: view.frame.width, height: height)
	}
}




	
