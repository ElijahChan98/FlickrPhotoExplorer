//
//  PhotoDetailsViewController.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import UIKit

private enum ButtonState {
	case favorite
	case unfavorite
}

class PhotoDetailsViewController: UIViewController, PhotoDetailsViewModelDelegate {
	@IBOutlet weak var containingStackView: UIStackView!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
	
	private var favoriteButton: UIBarButtonItem!
	private var state: ButtonState!
	private var buttonImage: UIImage {
		var image: UIImage!
		switch state {
		case .favorite:
			image = UIImage(named: "filledheart")
		case .unfavorite, .none:
			image = UIImage(named: "unfilledheart")
		}
		return image
	}
	
	var viewModel: PhotoDetailsViewModel!
	var coordinatorDelegate: PhotoDetailsDelegate?
	
	init(viewModel: PhotoDetailsViewModel){
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.hideBackButtonText()
		setupFavoriteButton()
		self.loadingSpinner.startAnimating()
		
    }
	
	override func viewWillLayoutSubviews() {
		self.imageHeightConstraint.constant = UIScreen.main.bounds.width
	}
	
	func reloadData() {
		self.loadingSpinner.stopAnimating()
		let photoDetails = viewModel.photoDetails
		
		if let photoTitle = photoDetails?.title.content {
			var title = photoTitle
			if title == "" {
				title = "Untitled"
			}
			self.titleLabel.text = title
		}
		self.authorLabel.text = "By: \(photoDetails?.owner.username ?? "unknown")"
		self.descLabel.text = photoDetails?.description.content
		if let location = photoDetails?.owner.location, location != "" {
			self.locationLabel.text = "Location: \(location)"
		}
		
		let readableDate = Dates.readableValue(photoDetails?.dates.posted ?? "")
		self.title = readableDate
		
		let url = photoDetails?.getUrlForPhoto(size: .normal)
		self.imageView.loadImage(url: url!)
		
		removeEmptyViews()
	}
	
	func setupFavoriteButton() {
		if viewModel.imageInfoExists() {
			self.state = .favorite
		}
		else {
			self.state = .unfavorite
		}
		self.favoriteButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(toggleFavorites))
		navigationItem.rightBarButtonItem = self.favoriteButton
	}
	
	@objc func toggleFavorites() {
		switch state {
		case .favorite:
			self.state = .unfavorite
			viewModel.deleteImageInfo()
		case .unfavorite, .none:
			self.state = .favorite
			viewModel.saveImageInfo()
		}
		navigationItem.rightBarButtonItem?.image = buttonImage
	}
	
	func removeEmptyViews() {
		for view in containingStackView.arrangedSubviews {
			if let label = view as? UILabel {
				if label.text == "" || label.text == nil {
					view.removeFromSuperview()
				}
			}
		}
	}
	
	func showErrorAlert(error: FlickrError) {
		self.coordinatorDelegate?.showErrorMessage(error: error)
	}
}

protocol PhotoDetailsDelegate {
	func showErrorMessage(error: FlickrError?)
}
