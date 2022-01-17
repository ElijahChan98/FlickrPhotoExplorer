//
//  Owner.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation

struct Owner: Codable {
	enum CodingKeys: String, CodingKey {
		case id = "nsid"
		case username
		case realName = "realname"
		case location
	}
	var id: String
	var username: String
	var realName: String
	var location: String?
}
