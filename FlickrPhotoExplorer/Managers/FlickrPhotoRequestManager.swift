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

public enum FlickrResult<T> {
	case success(T?)
	case failure(FlickrError?)
}

class FlickrPhotoRequestManager {
	static let shared = FlickrPhotoRequestManager()
	
	func fetchPhotosWithKeyword(keyword: String, page: Int, completion: @escaping (FlickrResult<Any>) -> ()) {
		var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.SERVICES_REST)!
		var queryItems = [
			URLQueryItem(name: "api_key", value: Constants.API_KEY),
			URLQueryItem(name: "page", value: String(page)),
			URLQueryItem(name: "format", value: "json"),
			URLQueryItem(name: "nojsoncallback", value: "1"),
		]
		
		if keyword != "" {
			queryItems.append(URLQueryItem(name: "method", value: Constants.SEARCH))
			queryItems.append(URLQueryItem(name: "text", value: keyword))
		}
		else {
			queryItems.append(URLQueryItem(name: "method", value: Constants.GET_RECENT))
		}
		
		urlComponents.queryItems = queryItems
		self.createGenericRequest(url: urlComponents.url!, requestMethod: .get) { result in
			completion(result)
		}
	}
	
	func fetchPhotoDetails(photoId: String, completion: @escaping (FlickrResult<Any>) -> ()) {
		var urlComponents = URLComponents(string: Constants.BASE_URL + Constants.SERVICES_REST)!
		let queryItems = [
			URLQueryItem(name: "method", value: Constants.GET_INFO),
			URLQueryItem(name: "api_key", value: Constants.API_KEY),
			URLQueryItem(name: "photo_id", value: photoId),
			URLQueryItem(name: "format", value: "json"),
			URLQueryItem(name: "nojsoncallback", value: "1"),
		]
		urlComponents.queryItems = queryItems
		self.createGenericRequest(url: urlComponents.url!, requestMethod: .get) { result in
			completion(result)
		}
	}
	
	private func createGenericRequest(url: URL, requestMethod: RequestMethod, completion: @escaping (FlickrResult<Any>) -> ()) {
		let session = URLSession.shared
		var request = URLRequest(url: url)
		request.httpMethod = requestMethod.rawValue
		
		let task = session.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let httpResponse = response as? HTTPURLResponse {
					if httpResponse.statusCode == 401 {
						completion(.failure(nil))
					}
					else if httpResponse.statusCode == 500 {
						//internal server error
						completion(.failure(nil))
					}
				}
				
				if let data = data {
					do {
						let json = try JSONSerialization.jsonObject(with: data, options: [])
						if let payload = json as? [String: Any] {
							if let error: FlickrError = CodableObjectFactory.objectFromPayload(payload) {
								completion(.failure(error))
							}
							else {
								completion(.success(payload))
							}
						}
					}
					catch {
						print(String(describing: error))
						print(error.localizedDescription)
					}
				}
				else {
					completion(.failure(nil))
				}
			}
		}
		task.resume()
	}
}
