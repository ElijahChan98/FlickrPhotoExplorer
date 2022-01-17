//
//  ImageDownloader.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation

public enum Result<T> {
	case success(T)
	case failure(Error)
}

final class ImageDownloader: NSObject {
	
	// MARK: - Private functions
	private static func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
	
	// MARK: - Public function
	
	/// downloadImage function will download the thumbnail images
	/// returns Result<Data> as completion handler
	public static func downloadImage(url: URL, completion: @escaping (Result<Data>) -> Void) {
		ImageDownloader.getData(url: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data, error == nil else {
				return
			}
			
			DispatchQueue.main.async() {
				completion(.success(data))
			}
		}
	}
}
