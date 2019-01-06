//
//  ImageViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/21/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = imageName {
            label.text = imageName
            imageView.image = UIImage(named: imageName)
        }
    }
    
}

extension ImageViewController: Instantiable {
    static var storyboardName: String {
        return StoryboardName.main.rawValue
    }
}
