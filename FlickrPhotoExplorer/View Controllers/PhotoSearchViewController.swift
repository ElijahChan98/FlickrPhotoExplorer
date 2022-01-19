//
//  PhotoSearchViewController.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import UIKit

class PhotoSearchViewController: UIViewController {
	@IBOutlet weak var searchTextField: UITextField!
	weak var delegate: PhotoSearchDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.hideBackButtonText()
		self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}

	@IBAction func onSearchButtonClick(_ sender: Any) {
		if let searchText = searchTextField.text {
			let tags = searchText.components(separatedBy: " ")
			self.delegate?.search(tags: tags)
		}
		else {
			self.delegate?.search(tags: [])
		}
	}
	
	@IBAction func onViewFavoritesButtonClick(_ sender: Any) {
		self.delegate?.openFavorites()
	}
}

protocol PhotoSearchDelegate: AnyObject {
	func search(tags: [String])
	func openFavorites()
}
