//
//  FlickrPhotoExplorerTestConstants.swift
//  FlickrPhotoExplorerTests
//
//  Created by Elijah Tristan H. Chan on 1/19/22.
//

import Foundation

struct Constants {
	static let dummyFlickrResponse: [String: Any] = [
		"page": 1,
		"pages": 10,
		"perpage": 100,
		"total": 1000,
		"photo": [
			[
				"id": "51828881082",
				"owner": "194835802@N03",
				"secret": "0514f1d480",
				"server": "65535",
				"farm": 66,
				"title": "20210528_143930",
				"ispublic": 1,
				"isfriend": 0,
				"isfamily": 0
			],
			[
				"id": "51828881612",
				"owner": "193997277@N08",
				"secret": "67dc8e8b37",
				"server": "65535",
				"farm": "66",
				"title": "",
				"ispublic": 1,
				"isfriend": 0,
				"isfamily": 0
			]
		]
	]
	
	static let dummyFlickrPhotoDetail: [String: Any] = [
		"id": "51789168005",
		"secret": "22165b77b9",
		"server": "65535",
		"farm": 66,
		"dateuploaded": "1640904706",
		"isfavorite": 0,
		"license": "0",
		"safety_level": "0",
		"rotation": 0,
		"owner":
			[
				"nsid": "22541015@N00",
				"username": "Disney Dan",
				"realname": "",
				"location": nil,
				"iconserver": "2882",
				"iconfarm": 3,
				"path_alias": "theverynk"
			],
		"title":
			[
				"_content": "Galaxy's Edge"
			],
		"description":
			[
				"_content": "Disneyland Resort in California.\nOctober 2021.\n<a href=\"http://www.charactercentral.net\" rel=\"noreferrer nofollow\">www.charactercentral.net</a>"
			],
		"visibility":
			[
				"ispublic": 1,
				"isfriend": 0,
				"isfamily": 0
			],
		"dates":
			[
				"posted": "1640904706",
				"taken": "2021-10-28 17:55:21",
				"takengranularity": "0",
				"takenunknown": "0",
				"lastupdate": "1640904710"
			]
	]
	
	static let LIVE_URL = "https://live.staticflickr.com/"
}
