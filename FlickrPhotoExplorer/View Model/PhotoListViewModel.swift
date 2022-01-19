//
//  PhotoListViewModel.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation

public enum ReloadResult<T> {
	case success([IndexPath]?)
	case failure(FlickrError?)
}

class PhotoListViewModel {
	var title: String!
	var searchTags: [String]!
	var delegate: PhotoListViewModelDelegate?
	
	private var hasExistingData: Bool!
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
		if searchText == "" {
			self.title = "Recent Uploads"
		}
		else {
			self.title = "Search results for \(searchText)"
		}
		self.searchTags = searchTags
		self.hasExistingData = false
	}
	
	init() {
		self.title = "Favorites"
		self.hasExistingData = true
	}
	
	func fetchData() {
		if hasExistingData {
			self.fetchExistingData()
		}
		else {
			if self.currentPage == 1 {
				self.delegate?.showLoadingAlert()
				self.fetchAPIData()
			}
		}
	}
	
	private func fetchExistingData() {
		FlickrPhotoDetailsPersistence.shared.retrievePhotoInfosFromCache { success, photoInfos in
			self.flickrPhotoInfos = photoInfos
			self.total = photoInfos.count
			self.delegate?.reloadData(.success(.none))
		}
	}
	
	private func fetchAPIData() {
		guard isFetchInProgress == false else { return }
		isFetchInProgress = true
		
		FlickrPhotoRequestManager.shared.fetchPhotosWithTags(tags: searchTags, page: self.currentPage) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let response):
					guard let response = response as? [String: Any] else {
						self.isFetchInProgress = false
						return
					}
					self.currentPage += 1
					self.isFetchInProgress = false
					
					self.getFlickrPhotoDetailsFromResponse(response)
				case .failure(let error):
					//handle errors
					if let error = error {
						self.delegate?.reloadData(.failure(error))
					}
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
					self.delegate?.reloadData(.success(indexPathsToReload))
				}
				else {
					guard self.flickrPhotoInfos.count != 0 else {
						let error = FlickrError(message: Constants.NO_RESULT, code: 999, stat: "fail")
						self.delegate?.showErrorAlert(error: error)
						return
					}
					self.delegate?.reloadData(.success(.none))
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
	func showLoadingAlert()
	func showErrorAlert(error: FlickrError)
	func reloadData(_ reloadResult: ReloadResult<Any>)
}
