//
//  ImagesPageViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/20/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class ImagesPageViewController: UIPageViewController {
    
    var resources = [Resource]()
    weak var pageTransitionDelegate: ImagesPageViewControllerTransitionDelegate?
    
    private var toBeVisibleResource: Resource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        let imageViewController = ImageViewController.instantiateFromStoryboard()
        imageViewController.resource = resources.first
        setViewControllers([imageViewController], direction: .forward, animated: true, completion: nil)
    }
    
}

extension ImagesPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentImageViewController = viewController as? ImageViewController,
            let currentResource = currentImageViewController.resource {
            let previousImageViewController = ImageViewController.instantiateFromStoryboard()
            if let previousResource = resources.item(before: currentResource) {
                previousImageViewController.resource = previousResource
            } else {
                previousImageViewController.resource = resources.last
            }
            toBeVisibleResource = previousImageViewController.resource
            return previousImageViewController
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentImageViewController = viewController as? ImageViewController,
            let currentResource = currentImageViewController.resource {
            let nextImageViewController = ImageViewController.instantiateFromStoryboard()
            if let nextResource = resources.item(after: currentResource) {
                nextImageViewController.resource = nextResource
            } else {
                nextImageViewController.resource = resources.first
            }
            toBeVisibleResource = nextImageViewController.resource
            return nextImageViewController
        } else {
            return nil
        }
        
    }
    
}

extension ImagesPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // delegate the toBeVisibleResource
            pageTransitionDelegate?.imagesPageViewController(self, didMakeVisible: toBeVisibleResource)
        }
    }
    
}

protocol ImagesPageViewControllerTransitionDelegate: class {
    func imagesPageViewController(_ imagesPageViewController: ImagesPageViewController, didMakeVisible resource: Resource?)
}
