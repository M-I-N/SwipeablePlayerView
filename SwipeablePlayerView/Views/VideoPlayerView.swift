//
//  VideoPlayerView.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/5/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    @IBOutlet private weak var playPauseButton: UIButton!
    
    private let videoPlayer = VideoPlayer()
    @objc private let avPlayer = AVPlayer()
    private var playbackModeObservationToken: NSKeyValueObservation?
    
    var video: Video? {
        didSet {
            if let video = video {
                let asset = AVURLAsset(url: video.url)
                let item = AVPlayerItem(asset: asset)
                avPlayer.replaceCurrentItem(with: item)
//                avPlayer.play()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let nibView = loadViewFromNib() else { return }
        
        nibView.frame = bounds
        addSubview(nibView)
        videoPlayer.player = avPlayer
        
        // add observer
        /*token = avPlayer.observe(\.timeControlStatus, changeHandler: { [weak self] (_, timeControlStatusObservedValue) in
            if let timeControlStatus = timeControlStatusObservedValue.newValue {
                switch timeControlStatus {
                case .paused:
                    print("Paused state")
                    self?.playPauseButton.isSelected = false
                case .playing, .waitingToPlayAtSpecifiedRate:
                    print("Playing state")
                    self?.playPauseButton.isSelected = true
                }
            }
        })*/
        
        playbackModeObservationToken = avPlayer.observe(\.timeControlStatus) { [unowned self] (player, _) in
            switch player.timeControlStatus {
            case .paused:
                self.playPauseButton.isSelected = false
            case .playing, .waitingToPlayAtSpecifiedRate:
                self.playPauseButton.isSelected = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer.frame = bounds
        videoPlayer.backgroundColor = .black
        addSubview(videoPlayer)
        sendSubviewToBack(videoPlayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
}

// MARK: - Protocol Conformances
extension VideoPlayerView: NibInitable { }


// MARK: - AVPlayer Specifics
extension VideoPlayerView {
    @objc func playerItemDidPlayToEndTime() {
        avPlayer.seek(to: .zero)
    }
}


// MARK: - Button Actions
extension VideoPlayerView {
    @IBAction private func playPauseButtonDidTap(_ sender: UIButton) {
        switch sender.isSelected {
        case true:
            // playing state, need to pause
            avPlayer.pause()
        case false:
            // paused state, need to play again
            avPlayer.play()
        }
    }
}

// MARK: - Internal Class
private class VideoPlayer: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer! {
        set {
            playerLayer.player = newValue
        }
        get {
            return playerLayer.player
        }
    }
    
}
