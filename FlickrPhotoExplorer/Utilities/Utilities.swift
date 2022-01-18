//
//  Utilities.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/18/22.
//

import Foundation
import UIKit

class Utilities {
	static func showGenericOkAlert(title: String?, message: String, handler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
		let okAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Okay", style: .default, handler: handler)
		okAlert.addAction(okAction)
		
		getTopViewController()?.present(okAlert, animated: true, completion: completion)
	}
	
	static func getTopViewController() -> UIViewController? {
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		
		if var topController = keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			return topController
		}
		return nil
	}
}
