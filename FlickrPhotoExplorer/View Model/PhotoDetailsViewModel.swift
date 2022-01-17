//
//  PhotoDetailsViewModel.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation

class PhotoDetailsViewModel {
	var photoId: String!
	var photoDetails: FlickrPhotoDetail?
	var delegate: PhotoDetailsViewModelDelegate?
	
	init(photoId: String) {
		self.photoId = photoId
		self.fetchPhotoDetails()
	}
	
	func fetchPhotoDetails() {
		FlickrPhotoRequestManager().fetchPhotoDetails(photoId: self.photoId) { success, response in
			guard success == true, let response = response else {
				return
			}
			if let photo = response["photo"] as? [String: Any] {
				self.photoDetails = CodableObjectFactory.objectFromPayload(photo)
				self.delegate?.reloadData()
			}
		}
	}
}

protocol PhotoDetailsViewModelDelegate: AnyObject {
	func reloadData()
}
