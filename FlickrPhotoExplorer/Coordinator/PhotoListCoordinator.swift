//
//  PhotoListCoordinator.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import UIKit

class PhotoListCoordinator: Coordinator, PhotoListDelegate {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	private var viewModel: PhotoListViewModel!
	
	init(navigationController: UINavigationController, searchTags: [String]) {
		self.viewModel = PhotoListViewModel(searchTags: searchTags)
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = PhotoListViewController(viewModel: viewModel)
		vc.delegate = self
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
	
	func cellSelected(photoId: String) {
		let coordinator = PhotoDetailsCoordinator(navigationController: self.navigationController, photoId: photoId)
		coordinator.start()
	}
}
