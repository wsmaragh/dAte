//  SignupVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import Firebase
import ImageIO


class SignupVC: UIViewController {

	@IBOutlet weak var imageView: UIImageView!

	@IBOutlet weak var firstNameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!

	@IBOutlet weak var passwordTF: UITextField!


	override func viewDidLoad() {
		super.viewDidLoad()
	}


//	func setupAndPlayGif(){
//		var path =
//			Bundle.main.path(forResource: "flowers", ofType: "gif")
//		var gif = Data(contentsOfFile: path)
//		var webViewBG = UIWebView()
//		imageView.
//		webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
//		webViewBG.isUserInteractionEnabled = false;
//		self.view.addSubview(webViewBG)
//	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
