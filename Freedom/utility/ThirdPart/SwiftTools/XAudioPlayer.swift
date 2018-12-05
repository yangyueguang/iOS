//
//  XAudioPlayer.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/5.
//  Copyright © 2018 薛超. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
class MyPlayTool: NSObject {
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    var urlAsset: AVURLAsset?
    var isPlaying = false
    var playID = ""
    var playImageUrlStr = ""
    var musicUrlStr = ""
    var isVideo = ""
    var songName = ""
    var singerName = ""
    var songImage: UIImage?

    private var playbackTimeObserver: Any!
    private var currentPlayTime: CGFloat = 0.0
    private var cacheTime: CGFloat = 0.0
    private var infoCenter: MPNowPlayingInfoCenter?
    private var dict: [String : Any] = [:]
    private var timer: Timer?
    static let sharePlayTool = MyPlayTool()

    func play() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default,
                options: AVAudioSession.CategoryOptions.allowAirPlay)
            try session.setActive(true)
        }catch{}
//        session.setActive(true, options: AVAudioSession.SetActiveOptions.init(rawValue: 0))
        player?.play()
        isPlaying = true
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.updateBackgoundMusicPlay), userInfo: nil, repeats: true)
    }

    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    func stop() {
        player = nil
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }

    func playAndRecord() {
        player?.play()
        isPlaying = true
    }

    //播放本地音乐
    func loadLocalMusicUsePath(_ path: String?) {
        let musicUrl = URL(fileURLWithPath: path ?? "")
        playerItem = AVPlayerItem(url: musicUrl)
        player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    //播放网络音乐
    func loadNetworkMusicUseUrlStr(_ urlStr: String?) {
        let url = URL(string: urlStr ?? "")
        if let anUrl = url {
            playerItem = AVPlayerItem(url: anUrl)
        }
        if player?.currentItem != nil {
            player?.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    //播放网络视频
    func loadNetworkVideoUseUrlStr(_ urlStr: String?) {
        if let aStr = URL(string: urlStr ?? "") {
            playerItem = AVPlayerItem(url: aStr)
        }
        if player?.currentItem != nil {
            player?.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        playerLayer?.videoGravity = .resizeAspect
        //监听播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    //添加监听
    func addPlayObserver() {
        playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil) // 监听status属性
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil) // 监听loadedTimeRanges属性
    }
    //移除监听
    func removePlayObserver() {
        if playerItem != nil {
            playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
            playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            player?.removeTimeObserver(playbackTimeObserver)
        }
    }
    
    //改变视频进度
    func movePlayer(toSliderValue currentSliderValue: CGFloat) {
        player?.pause()
        guard let playerItem = player?.currentItem else { return }
        let totalTime = CMTimeGetSeconds(playerItem.duration)
        let currentSecond: CGFloat = CGFloat(totalTime) * currentSliderValue
        let newCMTime: CMTime = CMTimeMake(value: Int64(currentSecond), timescale: 1)
        player?.seek(to: newCMTime, completionHandler: { finished in
            self.player?.play()
        })
    }
    // MARK: - 播放结束时继续播放
    @objc func playerItemDidReachEnd(_ notification: Notification?) {
        NotificationCenter.default.removeObserver(self)
        let playerItem = player?.currentItem
        playerItem?.seek(to: .zero)
        player?.actionAtItemEnd = .none
        player?.play()
        //监听播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: self.playerItem)
    }

    // MARK: - 监听播放状态,卡顿继续播放
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let playerItem = object as? AVPlayerItem
        if (keyPath == "status") {
            if playerItem?.status == AVPlayerItem.Status.readyToPlay {
                print("AVPlayerStatusReadyToPlay")
                let duration: CMTime = self.playerItem?.duration ?? CMTime() // 获取视频总长度
                //            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
                //            NSLog(@"总进度:%lf", totalSecond);
                print("movie 总进度:\(CMTimeGetSeconds(duration))")
                monitoringPlayback(self.playerItem) // 监听播放状态
            } else if playerItem?.status == AVPlayerItem.Status.failed {
                print("AVPlayerStatusFailed")
            } else if playerItem?.status == AVPlayerItem.Status.unknown {
                print("AVPlayerStatusUnkown")
            }
        } else if (keyPath == "loadedTimeRanges") {
            let timeInterval = availableDuration() // 计算缓冲进度
            cacheTime = CGFloat(timeInterval)
            //如果卡住,等缓存大于播放进度0.5秒就继续播放
            if cacheTime - currentPlayTime > 0.5 {
                player?.play()
            } else {
                print("播放卡主了")
            }
        }
    }
    func monitoringPlayback(_ playerItem: AVPlayerItem?) {
        weak var weakSelf = self
        playbackTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: nil, using: { time in
            guard let playerItem = playerItem else { return }
            let currentSecond = (CGFloat(playerItem.currentTime().value) / CGFloat(playerItem.currentTime().timescale))
            weakSelf?.currentPlayTime = currentSecond
        })
    }

    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
        guard let timeRange: CMTimeRange = loadedTimeRanges?.first?.timeRangeValue else {
            return 0
        }
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        let result = TimeInterval(startSeconds + durationSeconds) // 计算缓冲总进度
        return result
    }
    // MARK: - 刷新后台播放方法
    @objc func updateBackgoundMusicPlay() {
        guard let playerItem = player?.currentItem else { return }
        let currentTime = CMTimeGetSeconds(playerItem.currentTime())
        let totalTime = CMTimeGetSeconds(playerItem.duration)
        updateScreenMusicCurrentTime(CGFloat(currentTime), andTotalTime: CGFloat(totalTime))
    }
    //锁屏界面 显示歌曲基本信息
    func updateScreenMusicCurrentTime(_ currentTime: CGFloat, andTotalTime totalTime: CGFloat) {
        infoCenter = MPNowPlayingInfoCenter.default()
        dict = [String : Any]()
        dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        dict[MPMediaItemPropertyPlaybackDuration] = totalTime
        //    DLog(@"歌手名:%@ 歌曲名:%@", self.singerName, self.songName);
        //歌手名称
        //    dict[MPMediaItemPropertyAlbumTitle]= @"歌曲名";
        dict[MPMediaItemPropertyArtist] = singerName
        dict[MPMediaItemPropertyTitle] = songName
        if let songImage = songImage {
            dict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { (size) -> UIImage in
                return songImage
            })
        }
        infoCenter?.nowPlayingInfo = dict
    }
}
