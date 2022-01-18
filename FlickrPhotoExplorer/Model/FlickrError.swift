//
//  Error.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/18/22.
//

import Foundation

public struct FlickrError: Codable {
	enum CodingKeys: String, CodingKey {
		case message
		case code
		case stat
	}
	var message: String
	var code: Int
	var stat: String
}
