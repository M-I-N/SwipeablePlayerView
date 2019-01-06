//
//  ImagesPageViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/20/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ImagesPageViewController: UIPageViewController {
    
    var imageNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        let imageViewController = ImageViewController.instantiateFromStoryboard()
        imageViewController.imageName = imageNames.first
        setViewControllers([imageViewController], direction: .forward, animated: true, completion: nil)
    }
    
}

extension ImagesPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentImageViewController = viewController as? ImageViewController,
            let currentImage = currentImageViewController.imageName {
            let previousImageViewController = ImageViewController.instantiateFromStoryboard()
            if let previousImage = imageNames.item(before: currentImage) {
                previousImageViewController.imageName = previousImage
            } else {
                previousImageViewController.imageName = imageNames.last
            }
            return previousImageViewController
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentImageViewController = viewController as? ImageViewController,
            let currentImage = currentImageViewController.imageName {
            let nextImageViewController = ImageViewController.instantiateFromStoryboard()
            if let nextImage = imageNames.item(after: currentImage) {
                nextImageViewController.imageName = nextImage
            } else {
                nextImageViewController.imageName = imageNames.first
            }
            return nextImageViewController
        } else {
            return nil
        }
        
    }
    
    
}

