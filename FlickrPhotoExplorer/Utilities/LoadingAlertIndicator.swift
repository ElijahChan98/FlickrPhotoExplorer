//
//  LoadingAlertIndicator.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/18/22.
//

import UIKit

class LoadingAlertIndicator {
	static func showLoadingAlertIndicator() {
		let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

		let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.style = UIActivityIndicatorView.Style.gray
		loadingIndicator.startAnimating();

		alert.view.addSubview(loadingIndicator)
		self.getTopViewController()?.present(alert, animated: true, completion: {
			
		})
	}
	
	static func hideLoadingAlertIndicator() {
		if let topVC = self.getTopViewController() as? UIAlertController {
			topVC.dismiss(animated: true, completion: nil)
		}
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
