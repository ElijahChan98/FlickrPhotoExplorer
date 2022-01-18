//
//  UIViewController+Extension.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/18/22.
//

import UIKit

extension UIViewController {
	func hideBackButtonText() {
		if #available(iOS 14.0, *) {
			navigationItem.backButtonDisplayMode = .minimal
		} else if #available(iOS 11.0, *) {
			navigationItem.backButtonTitle = ""
		} else {
			let backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
			navigationItem.backBarButtonItem = backBarButtonItem
		}
	}
}
