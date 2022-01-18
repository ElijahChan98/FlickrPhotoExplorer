//
//  PhotoListViewModel.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation

class PhotoListViewModel {
	var title: String!
	var searchTags: [String]!
	var delegate: PhotoListViewModelDelegate?
	
	private var isFetchInProgress: Bool = false
	
	private var flickrResponse: FlickrResponse?
	var flickrPhotoInfos: [FlickrPhotoInfo] = []
	
	private var currentPage = 1
	var currentCount: Int {
		return flickrPhotoInfos.count
	}
	var total = 0
	
	init(searchTags: [String]) {
		let searchText = searchTags.joined(separator: ", ")
		let title = "Search results for \(searchText)"
		self.title = title
		self.searchTags = searchTags
	}
	
	func fetchData() {
		guard isFetchInProgress == false else { return }
		isFetchInProgress = true
		
		FlickrPhotoRequestManager.shared.fetchPhotosWithTags(tags: searchTags, page: self.currentPage) { success, response in
			DispatchQueue.main.async {
				if success == true {
					if let response = response {
						self.currentPage += 1
						self.isFetchInProgress = false
						
						self.getFlickrPhotoDetailsFromResponse(response)
					}
				}
				else {
					//handle errors
					self.isFetchInProgress = false
				}
			}
		}
	}
	
	private func getFlickrPhotoDetailsFromResponse(_ response: [String: Any]) {
		if let photos = response["photos"] as? [String: Any] {
			if let flickrResponse: FlickrResponse = CodableObjectFactory.objectFromPayload(photos) {
				self.flickrResponse = flickrResponse
				if self.total == 0 {
					self.total = flickrResponse.total
				}
				let newInfos = flickrResponse.infos ?? []
				self.flickrPhotoInfos.append(contentsOf: newInfos)
				
				if flickrResponse.page > 1 {
					let indexPathsToReload = self.indexPathsToReload(newPhotoInfos: newInfos)
					self.delegate?.reloadData(indexPathsToReload: indexPathsToReload)
				}
				else {
					self.delegate?.reloadData(indexPathsToReload: .none)
				}
			}
		}
	}
	
	func indexPathsToReload(newPhotoInfos: [FlickrPhotoInfo]) -> [IndexPath] {
		let startIndex = flickrPhotoInfos.count - newPhotoInfos.count
		let endIndex = startIndex + newPhotoInfos.count
		let indexPaths = (startIndex..<endIndex).map {
			return IndexPath(row: $0, section: 0)
		}
		return indexPaths
	}
}

protocol PhotoListViewModelDelegate {
	func reloadData(indexPathsToReload: [IndexPath]?)
}
