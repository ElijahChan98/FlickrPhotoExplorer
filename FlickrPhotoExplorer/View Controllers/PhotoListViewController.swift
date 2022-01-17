//
//  PhotoListViewController.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import UIKit

class PhotoListViewController: UIViewController, PhotoListViewModelDelegate {
	@IBOutlet weak var tableView: UITableView!
	
	private var viewModel: PhotoListViewModel!
	var delegate: PhotoListDelegate?
	
	init(viewModel: PhotoListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = viewModel.title
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		self.viewModel.delegate = self
		
		LoadingAlertIndicator.showLoadingAlertIndicator()
    }
	
	func reloadData() {
		LoadingAlertIndicator.hideLoadingAlertIndicator()
		self.tableView.reloadData()
	}
	
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.flickrResponse?.infos?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		guard let photo = viewModel.flickrResponse?.infos?[indexPath.row] else {
			return UITableViewCell()
		}
		
		let thumbnailPhotoUrl = photo.getUrlForPhoto(size: .thumbnail)
		cell.imageView?.loadImage(url: thumbnailPhotoUrl!)
		cell.textLabel?.text = photo.title
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let photo = viewModel.flickrResponse?.infos?[indexPath.row] else {
			return
		}
		let id = photo.id
		self.delegate?.cellSelected(photoId: id)
	}
}

protocol PhotoListDelegate: AnyObject {
	func cellSelected(photoId: String)
}
