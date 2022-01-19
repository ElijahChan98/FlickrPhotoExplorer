//
//  FlickrPhotoExplorerTests.swift
//  FlickrPhotoExplorerTests
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import XCTest
@testable import FlickrPhotoExplorer

class FlickrPhotoExplorerTests: XCTestCase {
	var flickrPhotoDetail: FlickrPhotoDetail?
	var persistence = FlickrPhotoDetailsPersistence.shared
	
	func testCodableObjectFactory() {
		testFlickrResponse()
		testFlickrDetails()
	}
	
	func testFlickrResponse() {
		let flickrResponseDummy = Constants.dummyFlickrResponse
		if let flickrResponse: FlickrResponse = CodableObjectFactory.objectFromPayload(flickrResponseDummy) {
			XCTAssert(flickrResponse.page == 1)
			XCTAssert(flickrResponse.pages == 10)
			XCTAssert(flickrResponse.perpage == 100)
			XCTAssert(flickrResponse.total == 1000)
			
			if let infos = flickrResponse.infos {
				XCTAssert(infos.count == 2)
				let info1 = infos[0]
				XCTAssert(info1.id == "51828881082")
				XCTAssert(info1.owner == "194835802@N03")
				XCTAssert(info1.secret == "0514f1d480")
				XCTAssert(info1.server == "65535")
				XCTAssert(info1.title == "20210528_143930")
				
				
				let info2 = infos[1]
				XCTAssert(info2.id == "51828881612")
				XCTAssert(info2.owner == "193997277@N08")
				XCTAssert(info2.secret == "67dc8e8b37")
				XCTAssert(info2.server == "65535")
				XCTAssert(info2.title == "")
			}
			else {
				XCTFail("No infos found")
			}
		}
		else {
			XCTFail("Response is not FlickrResponse compatible")
		}
	}
	
	func testFlickrDetails() {
		let flickrPhotoDetailDummy = Constants.dummyFlickrPhotoDetail
		if let flickrPhotoDetail: FlickrPhotoDetail = CodableObjectFactory.objectFromPayload(flickrPhotoDetailDummy) {
			self.flickrPhotoDetail = flickrPhotoDetail
			XCTAssert(flickrPhotoDetail.id == "51789168005")
			XCTAssert(flickrPhotoDetail.secret == "22165b77b9")
			XCTAssert(flickrPhotoDetail.server == "65535")
			
			//owner
			XCTAssert(flickrPhotoDetail.owner.id == "22541015@N00")
			XCTAssert(flickrPhotoDetail.owner.username == "Disney Dan")
			XCTAssert(flickrPhotoDetail.owner.realName == "")
			XCTAssert(flickrPhotoDetail.owner.location == nil)
			
			//title
			XCTAssert(flickrPhotoDetail.title.content == "Galaxy's Edge")
			
			//description
			XCTAssert(flickrPhotoDetail.description.content == "Disneyland Resort in California.\nOctober 2021.\n<a href=\"http://www.charactercentral.net\" rel=\"noreferrer nofollow\">www.charactercentral.net</a>")
			
			let expectedUrl = URL(string: "\(Constants.LIVE_URL)\("65535")/\("51789168005")_\("22165b77b9")_\("z").jpg")
			
			let receivedUrl = flickrPhotoDetail.getUrlForPhoto(size: .normal)
			
			XCTAssert(expectedUrl == receivedUrl)
		}
		else {
			XCTFail("Response is not FlickrPhotoDetail compatible")
		}
		
		let viewModel = PhotoDetailsViewModel(photoId: self.flickrPhotoDetail!.id)
		viewModel.photoDetails = flickrPhotoDetail
		viewModel.saveImageInfo()
		
		sleep(2)
		
		XCTAssert(viewModel.imageInfoExists())
		viewModel.deleteImageInfo()
		
		sleep(2)
		
		XCTAssert(!viewModel.imageInfoExists())
	}
}
