//
//  FlickrPhotoDetail.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation

class FlickrPhotoDetail: Codable {
	enum CodingKeys: String, CodingKey {
		case id
		case owner
		case server
		case secret
		case title
		case description
		case dates
	}
	var id: String
	var server: String
	var secret: String
	var owner: Owner
	var title: Title
	var description: PhotoDescription
	var dates: Dates
	
	func getUrlForPhoto(size: PhotoSize) -> URL? {
		let imageUrl = "\(Constants.LIVE_URL)\(server)/\(id)_\(secret)_\(size.rawValue).jpg"
		return URL(string: imageUrl)
	}
}
