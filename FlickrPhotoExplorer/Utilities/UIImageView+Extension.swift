//
//  UIImageView+Extension.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIImageView extension
extension UIImageView {
	
	/// This loadThumbnail function is used to download thumbnail image using urlString
	/// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
	func loadImage(url: URL) {
		let activityIndicator = UIActivityIndicatorView(style: .gray)
		activityIndicator.startAnimating()
		activityIndicator.hidesWhenStopped = true
		
		self.addSubview(activityIndicator)
		activityIndicator.center = self.convert(self.center, from: self.superview)
		
		image = UIImage(named: "default")
		
		if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
			image = imageFromCache as? UIImage
			return
		}
		ImageDownloader.downloadImage(url: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let data):
				guard let imageToCache = UIImage(data: data) else { return }
				imageCache.setObject(imageToCache, forKey: url as AnyObject)
				activityIndicator.stopAnimating()
				self.image = UIImage(data: data)
				
			case .failure(_):
				activityIndicator.stopAnimating()
				self.image = UIImage(named: "default")
			}
		}
	}
}
