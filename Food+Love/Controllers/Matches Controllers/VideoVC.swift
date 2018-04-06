
//  VideoVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/22/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVKit
import CallKit



class VideoVC: UIViewController, CXProviderDelegate {

	var lover: Lover?

	init(lover: Lover) {
		super.init(nibName: nil, bundle: nil)
		self.lover = lover
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarController?.tabBar.isHidden = true
		view.backgroundColor = UIColor.orange
//		navigationItem.title = lover?.name
		setupSendCall()
//		setupReceiveCall()
	}

	//required because of CXProviderDelegate
	func providerDidReset(_ provider: CXProvider) {
	}

	////////////////////////// Send Call //////////////////////////
	func setupSendCall(){
		let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
		provider.setDelegate(self, queue: nil)
		let controller = CXCallController()
		let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Pete Za")))
		controller.request(transaction, completion: { error in })

		DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
			provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
		}
	}


  ////////////////////////// Receive Call //////////////////////////
	func setupReceiveCall(){
//		let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))
//		provider.setDelegate(self, queue: nil)
//		let update = CXCallUpdate()
//		update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
//		provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })

		let config = CXProviderConfiguration(localizedName: "My App")
		config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "pizza")!)
//		config.ringtoneSound = "ringtone.caf"
		config.includesCallsInRecents = false;
		config.supportsVideo = true;
		let provider = CXProvider(configuration: config)
		provider.setDelegate(self, queue: nil)
		let update = CXCallUpdate()
		update.remoteHandle = CXHandle(type: .generic, value: "Custom User")
		update.hasVideo = true
		provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
	}

	//If you accept the call
	func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
		action.fulfill()
	}

	//If you reject the call or hangup
	func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
		action.fulfill()
	}





}
