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
		self.hideBackButtonText()
		
		self.title = viewModel.title
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.prefetchDataSource = self
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		self.viewModel.delegate = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.viewModel.fetchData()
	}
	
	func reloadData(_ reloadResult: ReloadResult<Any>) {
		LoadingAlertIndicator.hideLoadingAlertIndicator()
		switch reloadResult {
		case .success(let indexPathsToReload):
			guard let indexPathsToReload = indexPathsToReload else {
				self.tableView.reloadData()
				return
			}
			
			let newIndexPathsToReload = self.visibleIndexPathsToReload(intersecting: indexPathsToReload)
			self.tableView.reloadRows(at: newIndexPathsToReload, with: .automatic)
		case .failure(let error):
			self.delegate?.showErrorMessage(error: error)
		}
	}
	
	func showLoadingAlert() {
		LoadingAlertIndicator.showLoadingAlertIndicator()
	}
	
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.total
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		if !isLoadingCell(for: indexPath) {
			let photo = viewModel.flickrPhotoInfos[indexPath.row]
			
			let thumbnailPhotoUrl = photo.getUrlForPhoto(size: .thumbnail)
			cell.imageView?.loadImage(url: thumbnailPhotoUrl!)
			cell.textLabel?.text = photo.title
		}
		else {
			cell.imageView?.image = UIImage(named: "default")
			cell.textLabel?.text = "loading..."
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let photo = viewModel.flickrPhotoInfos[indexPath.row]
		let id = photo.id
		self.delegate?.cellSelected(photoId: id)
	}
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if indexPaths.contains(where: isLoadingCell) {
			viewModel.fetchData()
		}
	}
}

extension PhotoListViewController {
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		return indexPath.row >= viewModel.currentCount
	}
	
	func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
		let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
		let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
		return Array(indexPathsIntersection)
	}
}

protocol PhotoListDelegate: AnyObject {
	func cellSelected(photoId: String)
	func showErrorMessage(error: FlickrError?)
}
