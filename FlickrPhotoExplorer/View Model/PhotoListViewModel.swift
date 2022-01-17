//
//  PhotoListViewModel.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation

class PhotoListViewModel {
	var title: String!
	var flickrResponse: FlickrResponse?
	var searchTags: [String]!
	var delegate: PhotoListViewModelDelegate?
	
	init(searchTags: [String]) {
		let searchText = searchTags.joined(separator: ", ")
		let title = "Search results for \(searchText)"
		self.title = title
		self.searchTags = searchTags
		fetchData()
	}
	
	func fetchData() {
		FlickrPhotoRequestManager.shared.fetchPhotosWithTags(tags: searchTags) { success, response in
			if let response = response {
				self.getFlickrPhotoDetailsFromResponse(response)
				self.delegate?.reloadData()
			}
		}
	}
	
	private func getFlickrPhotoDetailsFromResponse(_ response: [String: Any]) {
		if let photos = response["photos"] as? [String: Any] {
			if let flickrResponse: FlickrResponse = CodableObjectFactory.objectFromPayload(photos) {
				self.flickrResponse = flickrResponse
			}
		}
	}
}

protocol PhotoListViewModelDelegate {
	func reloadData()
}
