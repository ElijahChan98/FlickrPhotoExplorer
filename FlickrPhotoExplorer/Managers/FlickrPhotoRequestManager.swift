//
//  FlickrPhotoRequestManager.swift
//  FlikrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation

public enum RequestMethod: String {
	case post = "POST"
	case put = "PUT"
	case get = "GET"
}

class FlickrPhotoRequestManager {
	static let shared = FlickrPhotoRequestManager()
	
	func fetchPhotosWithTags(tags: [String], page: Int, completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
		var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.SERVICES_REST)!
		let commaSeparatedTags = tags.joined(separator: ",")
		let queryItems = [
			URLQueryItem(name: "method", value: Constants.SEARCH),
			URLQueryItem(name: "api_key", value: Constants.API_KEY),
			URLQueryItem(name: "tags", value: commaSeparatedTags),
			URLQueryItem(name: "per_page", value: String(25)),
			URLQueryItem(name: "page", value: String(page)),
			URLQueryItem(name: "format", value: "json"),
			URLQueryItem(name: "nojsoncallback", value: "1"),
		]
		urlComponents.queryItems = queryItems
		self.createGenericRequest(url: urlComponents.url!, requestMethod: .get) { (success, response) in
			completion(success, response)
		}
	}
	
	func fetchPhotoDetails(photoId: String, completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
		var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.SERVICES_REST)!
		let queryItems = [
			URLQueryItem(name: "method", value: Constants.GET_INFO),
			URLQueryItem(name: "api_key", value: Constants.API_KEY),
			URLQueryItem(name: "photo_id", value: photoId),
			URLQueryItem(name: "format", value: "json"),
			URLQueryItem(name: "nojsoncallback", value: "1"),
		]
		urlComponents.queryItems = queryItems
		self.createGenericRequest(url: urlComponents.url!, requestMethod: .get) { (success, response) in
			completion(success, response)
		}
	}
	
	private func createGenericRequest(url: URL, requestMethod: RequestMethod, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> ()) {
		let session = URLSession.shared
		var request = URLRequest(url: url)
		request.httpMethod = requestMethod.rawValue
		
		let task = session.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let httpResponse = response as? HTTPURLResponse {
					if httpResponse.statusCode == 401 {
						completion(false, nil)
					}
					else if httpResponse.statusCode == 500 {
						//internal server error
						completion(false, nil)
					}
				}
				
				if let data = data {
					do {
						let json = try JSONSerialization.jsonObject(with: data, options: [])
						if let payload = json as? [String: Any] {
							completion(true, payload)
						}
						else if let payloads = json as? [[String:Any]] {
							//print(payloads)
							completion(true, ["payloads" : payloads])
						}
					}
					catch {
						print(String(describing: error))
						print(error.localizedDescription)
						print("something went wrong")
					}
				}
				else {
					completion(false, nil)
				}
			}
		}
		task.resume()
	}
}
