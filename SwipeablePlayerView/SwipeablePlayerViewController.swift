//
//  ViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/20/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class SwipeablePlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagesPVC = segue.destination as? ImagesPageViewController {
            imagesPVC.imageNames = ["Image1", "Image2", "Image3"]
        }
    }


}

