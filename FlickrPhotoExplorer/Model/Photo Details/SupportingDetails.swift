//
//  SupportingDetails.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation

struct Title: Codable {
	enum CodingKeys: String, CodingKey {
		case content = "_content"
	}
	var content: String
}

struct PhotoDescription: Codable {
	enum CodingKeys: String, CodingKey {
		case content = "_content"
	}
	var content: String
}

struct Dates: Codable {
	enum CodingKeys: String, CodingKey {
		case posted
		case taken
		case lastUpdate = "lastupdate"
	}
	
	var posted: String
	var taken: String
	var lastUpdate: String
	
	static func readableValue(_ unixValue: String) -> String {
		guard let unixValueDouble = Double(unixValue) else {
			return ""
		}
		let date = Date(timeIntervalSince1970: unixValueDouble)
		let dateFormatter = DateFormatter()
		dateFormatter.locale = NSLocale.current
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		let strDate = dateFormatter.string(from: date)
		
		return strDate
	}
}
