//
//  PhotoDetailsViewController.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/17/22.
//

import UIKit

class PhotoDetailsViewController: UIViewController, PhotoDetailsViewModelDelegate {
	@IBOutlet weak var containingStackView: UIStackView!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	var viewModel: PhotoDetailsViewModel!
	
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
		
		LoadingAlertIndicator.showLoadingAlertIndicator()
    }
	
	func reloadData() {
		let photoDetails = viewModel.photoDetails
		
		self.titleLabel.text = photoDetails?.title.content
		self.authorLabel.text = "By: \(photoDetails?.owner.username ?? "unknown")"
		self.descLabel.text = photoDetails?.description.content
		self.locationLabel.text = photoDetails?.owner.location
		
		let readableDate = Dates.readableValue(photoDetails?.dates.posted ?? "")
		self.dateLabel.text = "Date Posted: \(readableDate)"
		
		let url = photoDetails?.getUrlForPhoto(size: .normal)
		self.imageView.loadImage(url: url!)
		
		removeEmptyViews()
		
		LoadingAlertIndicator.hideLoadingAlertIndicator()
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
}
