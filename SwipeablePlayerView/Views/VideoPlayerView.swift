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
    private var playerItemStatusObservationToken: NSKeyValueObservation?
    
    weak var delegate: VideoPlayerViewPlaybackModeDelegate?
    let allowAutoPlay: Bool = false
    
    var resource: Resource? {
        didSet {
            if let resource = resource {
                let asset = AVURLAsset(url: resource.videoURL)
                let item = AVPlayerItem(asset: asset)
                
                // add AVPlayerItem observer
                playerItemStatusObservationToken = item.observe(\.status) { [weak self] (playerItem, _) in
                    if let self = self {
                        switch playerItem.status {
                        case .unknown:
                            self.delegate?.videoPlayerView(self, didChangeTo: .notReadyToPlay)
                        case .readyToPlay:
                            self.delegate?.videoPlayerView(self, didChangeTo: .readyToPlay)
                        case .failed:
                            self.delegate?.videoPlayerView(self, didChangeTo: .notReadyToPlay)
                        }
                    }
                }
                avPlayer.replaceCurrentItem(with: item)
                if allowAutoPlay {
                    avPlayer.play()
                } else {
                    avPlayer.pause()
                }
            } else {
                avPlayer.replaceCurrentItem(with: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let nibView = loadViewFromNib() else { return }
        
        nibView.frame = bounds
        addSubview(nibView)
        videoPlayer.player = avPlayer
        
        // add AVPlayer observer
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

// MARK: - PlaybackMode Enum
/// Enum
///
/// - readyToPlay: Video Player is ready for playback
/// - notReadyToPlay: Video Player isn't ready for playback
enum VideoPlayerViewPlaybackMode {
    case readyToPlay
    case notReadyToPlay
}

// MARK: - VideoPlayerView playback mode delegate
protocol VideoPlayerViewPlaybackModeDelegate: class {
    func videoPlayerView(_ videoPlayerView: VideoPlayerView, didChangeTo mode: VideoPlayerViewPlaybackMode)
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
