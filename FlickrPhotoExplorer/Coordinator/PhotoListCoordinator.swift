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
	
	init(navigationController: UINavigationController) {
		self.viewModel = PhotoListViewModel()
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
	
	func showErrorMessage(error: FlickrError?) {
		let message = error?.message ?? Constants.SOMETHING_WENT_WRONG
		let okAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Okay", style: .default) { alert in
			self.navigationController.popViewController(animated: true)
			self.childDidFinish(self)
		}
		okAlert.addAction(okAction)
		
		self.navigationController.present(okAlert, animated: true, completion: nil)
	}
}
