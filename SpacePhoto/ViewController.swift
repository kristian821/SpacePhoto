//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Kristian Mitchell on 12/17/21.
//

import UIKit
import Dispatch

class ViewController: UIViewController, UINavigationControllerDelegate {
    let photoInfoController = PhotoInfoController()

    @IBOutlet weak var spacePhotoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = ""
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        activityIndicator.isHidden = false
        photoInfoController.fetchPhotoInfo { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.updateUI(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }

    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchImage(from: photoInfo.url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.activityIndicator.isHidden = true
                    self.title = photoInfo.title
                    self.descriptionLabel.numberOfLines = 0
                    self.descriptionLabel.text = photoInfo.description
                    self.copyrightLabel.text = photoInfo.copyright
                    self.spacePhotoImageView.image = image
                    
                
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with error: Error) {
        self.activityIndicator.isHidden = true
        title = "Error fetching photo"
        spacePhotoImageView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }

}

