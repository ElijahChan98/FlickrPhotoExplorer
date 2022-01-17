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
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}

	@IBAction func onSearchButtonClick(_ sender: Any) {
		let tags = searchTextField.text?.components(separatedBy: " ") ?? []
		self.delegate?.search(tags: tags)
	}
}

protocol PhotoSearchDelegate: AnyObject {
	func search(tags: [String])
}
