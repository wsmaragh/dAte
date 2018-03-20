//  StyleSheet.swift
//  Food+Love
//  Created by Winston Maragh on 3/16/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit


struct StyleSheet {

	//app colors
	static let mainColor = UIColor(hex: 0xFB0012)
	static let color2 =  UIColor(hex: 0xd2bba0)
	static let color3 =  UIColor(hex: 0xf2efc7)
	static let color4 =  UIColor(hex: 0xf7ffe0)
	static let color5 =  UIColor(hex: 0xffeee2)

		//Navigation Bar
	static func setupNavBarAndTabBarColors(){
		UINavigationBar.appearance().backgroundColor = StyleSheet.mainColor
		UINavigationBar.appearance().tintColor = UIColor.red
		UINavigationBar.appearance().alpha = 1.0
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.blue]

		//Tab Bar
		UITabBar.appearance().backgroundColor = StyleSheet.mainColor
		UITabBar.appearance().tintColor = UIColor.red
		UITabBar.appearance().alpha = 1.0
		UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
	}



}
