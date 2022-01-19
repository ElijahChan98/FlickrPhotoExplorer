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
	
	init(navigationController: UINavigationController, searchText: String?) {
		self.viewModel = PhotoListViewModel(searchText: searchText)
		self.navigationController = navigationController
	}
	
	init(navigationController: UINavigationController) {
		self.viewModel = PhotoListViewModel()
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = PhotoListViewController(viewModel: viewModel)
		vc.coordinatorDelegate = self
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
	
	func showErrorMessage(error: FlickrError?) {
		let message = error?.message ?? Constants.SOMETHING_WENT_WRONG
		Utilities.showGenericOkAlert(title: nil, message: message) { _ in
			self.navigationController.popViewController(animated: true)
			self.childDidFinish(self)
		}
	}
}
