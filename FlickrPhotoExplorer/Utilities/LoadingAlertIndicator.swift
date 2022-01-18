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
		Utilities.getTopViewController()?.present(alert, animated: true, completion: nil)
	}
	
	static func hideLoadingAlertIndicator(completion: (() -> Void)? = nil) {
		if let topVC = Utilities.getTopViewController() as? UIAlertController {
			topVC.dismiss(animated: true, completion: completion)
		}
	}
}
