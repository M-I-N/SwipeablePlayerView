//
//  ImageViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/21/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    var resource: Resource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let resource = resource {
            imageView.downloaded(from: resource.thumbnailImageName, contentMode: .scaleAspectFill)
        }
    }
    
}

extension ImageViewController: Instantiable {
    static var storyboardName: String {
        return StoryboardName.main.rawValue
    }
}
