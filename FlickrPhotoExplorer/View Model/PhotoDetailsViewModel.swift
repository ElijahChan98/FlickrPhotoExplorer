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
		FlickrPhotoRequestManager.shared.fetchPhotoDetails(photoId: self.photoId) { result in
			switch result{
			case .success(let response):
				if let payload = response as? [String: Any] {
					if let photo = payload["photo"] as? [String: Any] {
						self.photoDetails = CodableObjectFactory.objectFromPayload(photo)
						self.delegate?.reloadData()
					}
				}
			case .failure(let error):
				if let error = error {
					
				}
			}
			
		}
	}
	
	func imageInfoExists() -> Bool {
		let exists = FlickrPhotoDetailsPersistence.shared.checkIfPhotoInfoExist(id: self.photoId)
		
		return exists
	}
	
	func saveImageInfo() {
		guard let photoDetails = photoDetails else {
			return
		}

		let photoInfo = FlickrPhotoInfo()
		photoInfo.id = photoDetails.id
		photoInfo.owner = photoDetails.owner.id
		photoInfo.title = photoDetails.title.content
		photoInfo.secret = photoDetails.secret
		photoInfo.server = photoDetails.server
		
		FlickrPhotoDetailsPersistence.shared.save(photoDetails: photoInfo)
	}
	
	func deleteImageInfo() {
		guard let photoDetails = photoDetails else {
			return
		}

		let photoInfo = FlickrPhotoInfo()
		photoInfo.id = photoDetails.id
		
		FlickrPhotoDetailsPersistence.shared.delete(photoDetails: photoInfo)
	}
}

protocol PhotoDetailsViewModelDelegate: AnyObject {
	func reloadData()
}
