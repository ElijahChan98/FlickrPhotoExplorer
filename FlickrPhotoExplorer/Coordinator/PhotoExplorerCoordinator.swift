//
//  PhotoExplorerCoordinator.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import UIKit

class PhotoSearchCoordinator: Coordinator, PhotoSearchDelegate {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let searchVC = PhotoSearchViewController()
		searchVC.delegate = self
		self.navigationController.pushViewController(searchVC, animated: false)
	}
	
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
	
	func search(tags: [String]) {
		let photoListCoordinator = PhotoListCoordinator(navigationController: self.navigationController, searchTags: tags)
		photoListCoordinator.start()
	}
}
