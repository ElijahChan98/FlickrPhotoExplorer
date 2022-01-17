//
//  PhotoDetailsCoordinator.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation
import UIKit

class PhotoDetailsCoordinator: Coordinator {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var viewModel: PhotoDetailsViewModel!
	
	init(navigationController: UINavigationController, photoId: String) {
		self.viewModel = PhotoDetailsViewModel(photoId: photoId)
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = PhotoDetailsViewController(viewModel: self.viewModel)
		self.viewModel.delegate = vc
		self.navigationController.pushViewController(vc, animated: true)
	}
	
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
}
