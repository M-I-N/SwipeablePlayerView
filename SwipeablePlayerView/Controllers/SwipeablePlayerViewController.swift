//
//  ViewController.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 12/20/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class SwipeablePlayerViewController: UIViewController {
    
    @IBOutlet private weak var videoPlayerView: VideoPlayerView!
    @IBOutlet private weak var imagesPageViewControllerContainerView: UIView!
    
    private var imagesPageViewController: ImagesPageViewController!
    
    private let resources = Resource.allResources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayerView.delegate = self
        // Initial video content providing
        videoPlayerView.resource = resources.first
        addSwipeGestureToVideoPlayerView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagesPVC = segue.destination as? ImagesPageViewController {
            imagesPageViewController = imagesPVC
            imagesPVC.pageTransitionDelegate = self
            imagesPVC.resources = resources
        }
    }
    
    private func addSwipeGestureToVideoPlayerView() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeOnVideoPlayerView(gesture:)))
        swipeLeft.direction = .left
        videoPlayerView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeOnVideoPlayerView(gesture:)))
        swipeRight.direction = .right
        videoPlayerView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipeOnVideoPlayerView(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            videoPlayerView.resource = nil
            imagesPageViewControllerContainerView.isHidden = false
            imagesPageViewController.goToNextPage()
        case .right:
            videoPlayerView.resource = nil
            imagesPageViewControllerContainerView.isHidden = false
            imagesPageViewController.goToPreviousPage()
        default:
            break
        }
    }
    
}

extension SwipeablePlayerViewController: VideoPlayerViewPlaybackModeDelegate {
    
    func videoPlayerView(_ videoPlayerView: VideoPlayerView, didChangeTo mode: VideoPlayerViewPlaybackMode) {
        if mode == .readyToPlay {
            imagesPageViewControllerContainerView.isHidden = true
        }
    }
    
}

extension SwipeablePlayerViewController: ImagesPageViewControllerTransitionDelegate {
    
    func imagesPageViewController(_ imagesPageViewController: ImagesPageViewController, didMakeVisible resource: Resource?) {
        videoPlayerView.resource = resource
    }
    
    
}
