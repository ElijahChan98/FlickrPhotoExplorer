//
//  FlickrResponse.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation

struct FlickrResponse: Codable {
	enum CodingKeys: String, CodingKey {
		case page
		case pages
		case perpage
		case total
		case infos = "photo"
	}
	var page: Int
	var pages: Int
	var perpage: Int
	var total: Int
	var infos: [FlickrPhotoInfo]?
}
