//
//  MainFeedViewController.swift
//  Food+Love
//
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//


import UIKit
import Parchment


class FeedVC: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let feedStoryBoard = UIStoryboard(name: "Feed", bundle: nil)
		let firstViewController = feedStoryBoard.instantiateViewController(withIdentifier: "DiscoverVC")
		let secondViewController = feedStoryBoard.instantiateViewController(withIdentifier: "AdmirersVC")

		let pagingViewController = FixedPagingViewController(viewControllers: [
			firstViewController,
			secondViewController
			])

		addChildViewController(pagingViewController)
		view.addSubview(pagingViewController.view)
		pagingViewController.didMove(toParentViewController: self)
		pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
			])

		pagingViewController.menuBackgroundColor = UIColor.black
		pagingViewController.backgroundColor = UIColor.black
		pagingViewController.selectedBackgroundColor = UIColor.black
		pagingViewController.indicatorColor = UIColor.white
		pagingViewController.selectedTextColor = UIColor.red
		pagingViewController.textColor = UIColor.white

	}


}

