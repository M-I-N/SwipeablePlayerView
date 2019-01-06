//
//  Video.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/5/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct Video {
    let url: URL
    
    static func allVideos() -> [Video] {
        // https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
        // https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.m3u8
        let videos = [Video]()
        return videos
    }
    
    static func singleVideo() -> Video? {
        guard let url = URL(string: "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.m3u8") else {
            return nil
        }
        return Video(url: url)
    }
}
