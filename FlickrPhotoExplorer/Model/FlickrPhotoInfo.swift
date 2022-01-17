//
//  FlickrPhotoDetails.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation
import UIKit

enum PhotoSize: String {
	case thumbnail = "s"
	case normal = "z"
	case big = "b"
}

class FlickrPhotoInfo: Codable {
	enum CodingKeys: String, CodingKey {
		case id
		case owner
		case secret
		case title
		case server
	}
	var id: String = ""
	var owner: String = ""
	var secret: String = ""
	var title: String = ""
	var server: String = ""
	
	//persistent data
	var image: UIImage?
	
	func getUrlForPhoto(size: PhotoSize) -> URL? {
		let imageUrl = "\(Constants.LIVE_URL)\(server)/\(id)_\(secret)_\(size.rawValue).jpg"
		return URL(string: imageUrl)
	}
}
