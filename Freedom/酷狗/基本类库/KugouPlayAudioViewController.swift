//
//  KugouPlayAudioViewController.swift
//  Freedom
import UIKit
import MediaPlayer
import AVFoundation
class KugouPlayAudioViewController: UIViewController {
    var isMoving = false
    var arraySongs: [String] = []
    var arraySingers: [String] = []
    var index: Int = 0
    var isPlay = false

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!//调节进度
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var lyricsView: LyricsView!//歌词视图，里面是两个lab  lazy
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var centerLyricsLable: UILabel!

    private var startTouch = CGPoint.zero
    private var lrc: KugouLyricsManage!
    private var backLeft = false
    private var audioPlayer: AVAudioPlayer?//创建对象
    private var arrayModels = ["列表循环", "顺序播放", "单曲循环", "单曲播放", "随机播放"]
    private var modelIndex: Int = 0
    private var isRandom = false
    private var isNext = true
    private var haveMusic = false
    private var haveLyrics = false
    private var timer: Timer?
    private var privateIndex: Int = 0
    private var isPlaying = false
    private var lyrics = ""//歌词
    private var size = CGSize.zero
    private var time: Int = 0
    private var maxNum: Int = 0//最大行的歌词的个数
    private var lineSize = CGSize.zero
    //每句的时间数组
    private var timeArray: [[String]] = []
    //换行时间数组
    private var startTimeArray: [String] = []
    //纯歌词
    private var lyricsStr = ""
    //纯歌词数组
    private var lyricsSArray: [String] = []
    //每行歌词单词个数的数组
    private var wordNumArray: [String] = []
    static var shared_sington: KugouPlayAudioViewController? = nil
    //FIXME: 程序开始
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    class func shared() -> KugouPlayAudioViewController {
        if shared_sington == nil {
            shared_sington = KugouPlayAudioViewController.storyVC(.kugou)
            if let view = shared_sington?.view {
                UIApplication.shared.keyWindow?.addSubview(view)
            }
            shared_sington?.view.frame = CGRect(x: 0, y: 0, width: APPW, height: APPH)
            shared_sington?.view.transform = CGAffineTransform(rotationAngle: .pi / 5.5)
        }
        return shared_sington!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置旋转中心锚点
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 2)
        //    [self readData];
        let path = Bundle.main.path(forResource: "lll.Krc", ofType: nil)
        lyrics = AudioStreamer.parseKRCWord(withPath: path)
        let url: URL? = Bundle.main.url(forResource: "vocal", withExtension: "mp3")
        if let url = url {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
        }
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        haveMusic = true
        isPlaying = true
        getLyricsInfo()
        lyricsView.text = lyricsStr
        if lyricsStr.isEmpty { return }
        lyricsView.textLable.numberOfLines = LyricsUtil.getLyricLineNum(withLyric: lyrics)
        lyricsView.maskLable.numberOfLines = LyricsUtil.getLyricLineNum(withLyric: lyrics)
        let attributes = [
            NSAttributedString.Key.font: lyricsView.textLable.font,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()
        ] as [NSAttributedString.Key : Any]
        size = lyricsStr.boundingRect(
            with: CGSize(width:lyricsView.textLable.frame.size.width,height: CGFloat(NSIntegerMax)),
            options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes , context: nil).size
        let attributes1 = [
            NSAttributedString.Key.font: lyricsView.textLable.font,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()
        ] as [NSAttributedString.Key : Any]
        lineSize = lyricsSArray[0].boundingRect(with: CGSize(width: lyricsView.textLable.frame.size.width, height: CGFloat(MAXFLOAT)), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attributes1, context: nil).size
        size.height = (lineSize.height - 9) * CGFloat(lyricsSArray.count)
        backScrollView.contentSize = CGSize(width: size.width, height: size.height + 300)
        lyricsView.frame = CGRect(x: 10, y: 10, width: APPW - 20, height: size.height)
        let subFrame = CGRect(x: APPW / 2 - size.width / 2, y: 0, width: size.width, height: size.height)
        lyricsView.maskLable.frame = subFrame
        lyricsView.textLable.frame = subFrame
    }
    /// 从本地读取全部歌曲//深度遍历(会去遍历当前目录下的子目录里的文件)
    func readData() {
        let fm = FileManager.default
        let array = try? fm.subpathsOfDirectory(atPath: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents").absoluteString)
        for str in array ?? [] {
            if str.hasSuffix("mp3"){
                var singer = ""
                var song = ""
                let string = (str as NSString).substring(to: Int((str as NSString).range(of: ".mp3").location))
                if string.oc.range(of: "-").length > 0 {
                    singer = (string as NSString).substring(to: (string.oc.range(of: "-").location) - 1)
                    song = string.oc.substring(from: (string.oc.range(of: "-").location) + 2)
                } else {
                    singer = "unknown"
                    song = string
                }
                arraySingers.append(singer)
                arraySongs.append(song)
            }
        }
        Dlog(String(format: "(%ld首)", arraySongs.count))
        if arraySongs.count > 0 {
            haveMusic = true
            index = 0
            readMusic()
        }
    }
    /// 读取指定歌曲
    func readMusic() {
        songLabel.text = arraySongs[index]
        singerLabel.text = arraySingers[index]
        loadLyrics()
        let str = "\(arraySingers[index]) - \(arraySongs[index])"
        let musicFolderURL = URL(fileURLWithPath: NSHomeDirectory())
        let strPath = "\(musicFolderURL.absoluteString)/Documents/\(str).mp3"
        let data = NSData(contentsOfFile: strPath) as Data?
        if let data = data {
            audioPlayer = try? AVAudioPlayer(data: data)
        }
        audioPlayer?.delegate = self
        let duration = audioPlayer?.duration ?? 0
        let min = Int(duration / 60)
        let sec = Int(duration - Double(min * 60))
        endTimeLabel.text = String(format: "%02d:%02d", min, sec)
        let isReady = audioPlayer?.prepareToPlay() ?? false
        Dlog(isReady)
        if !isReady {
            if isNext {
                fastForward()
            } else {
                rewind()
            }
        }
        showInfoInLockedScreen()
    }
    //FIXME: 界面交互
    //播放/暂停 按钮
    @IBAction func play(_ sender: UIButton) {
        play()
    }
    func play() {
        if !haveMusic { return }
        if !isPlay {
            if haveLyrics {
                lyricsPlay()
            }
            audioPlayer?.play()
            isPlay = true
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.changeTime), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update(_:)), userInfo: nil, repeats: true)
        } else {
            if haveLyrics {
                timer?.fireDate = Date.distantFuture
            }
            audioPlayer?.pause()
            lyricsView.stop()
            isPlay = false
        }
    }
    //上一曲
    @IBAction func rewind(_ sender: Any) {
        rewind()
    }
    func rewind() {
        if !haveMusic { return }
        isNext = false
        index -= 1
        if index < 0 {
            index = arraySongs.count - 1
        }
        let c = isPlay
        stop()
        readMusic()
        if c { play() }
    }
    //下一曲
    @IBAction func next(_ sender: Any) {
        fastForward()
    }
    func fastForward() {
        if !haveMusic { return }
        isNext = true
        if isRandom {
            index = Int(arc4random()) % arraySongs.count
            let c = isPlay
            stop()
            readMusic()
            if c { play() }
        } else {
            index += 1
            if index == arraySongs.count {
                index = 0
            }
            let c = isPlay
            stop()
            readMusic()
            if c { play() }
        }
    }
    //滑动进度条
    @IBAction func progressChange(_ sender: UISlider) {
        if !haveMusic { return }
        audioPlayer?.currentTime = TimeInterval(sender.value) * (audioPlayer?.duration ?? 0)
    }
    //结束
    @IBAction func endDrag(_ sender: UISlider) {
        if haveLyrics {
            for i in 0..<lrc.arr.count - 1 {
                let tempStr = lrc.arr[i].myTime.oc.substring(from: 3)
                let tempStr1 = lrc.arr[i + 1].myTime.oc.substring(from: 3)
                let x = lrc.arr[i].myTime.doubleValue * 60 + (Double(tempStr) ?? 0.0)
                let y = lrc.arr[i + 1].myTime.doubleValue * 60 + (Double(tempStr1) ?? 0.0)
                let currentTime = audioPlayer?.currentTime ?? 0
                if currentTime >= x
                    && currentTime < y {
                    privateIndex = i
                } else if currentTime >= y {
                    privateIndex = i + 1
                }
            }
        }
    }
    //滑动音量条
    @objc func volumeChange(_ slider: UISlider) {
        audioPlayer?.volume = slider.value
        var value: Double = 0
        if audioPlayer?.volume != 0 {
            if audioPlayer?.volume != 1 {
                value = Double((audioPlayer?.volume ?? 0) * 10 + 1)
            } else {
                value = 10
            }
        }
        print(value)
    }
    //切换播放模式
    @IBAction func modeChange(_ sender: UIButton) {
        modelIndex += 1
        if modelIndex == arrayModels.count {
            modelIndex = 0
        }
        isRandom = false
        if modelIndex == 4 {
            isRandom = true
        }
        sender.setTitle(arrayModels[modelIndex], for: .normal)
    }
    //直接收回页面
    @IBAction func backAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.backLeft {
                self.view.transform = CGAffineTransform(rotationAngle: -.pi / 5.5)
            } else {
                self.view.transform = CGAffineTransform(rotationAngle: .pi / 5.5)
            }
        }) { finished in
        }
    }
    //FIXME: 私有方法
    //停止按钮
    func stop() {
        if !haveMusic { return }
        if haveLyrics {
            timer?.invalidate()
            timer = nil
            centerLyricsLable.text = lrc.str
            centerLyricsLable.textColor = UIColor.greenx
        }
        isPlay = true
        audioPlayer?.stop()
        isPlay = false
        startTimeLabel.text = "00:00"
        audioPlayer?.currentTime = 0
        progressSlider.value = 0
    }
    /// 在锁屏界面显示歌曲信息
    private func showInfoInLockedScreen() {
        var info: [String : Any] = [:]
        info[MPMediaItemPropertyTitle] = songLabel.text
        info[MPMediaItemPropertyArtist] = singerLabel.text
        info[MPMediaItemPropertyAlbumTitle] = singerLabel.text
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { size in
            return (UIImage(named: "CollectDetailPage_NoBackground.jpg"))!
        })
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    //刷新进度条
    @objc private func update(_ timer: Timer?) {
        var timer = timer
        if !isPlay {
            timer?.invalidate()
            timer = nil
        }
        let progress = audioPlayer?.currentTime ?? 0
        let duration = audioPlayer?.duration ?? 1
        let value = progress / duration
        progressSlider.value = Float(value)
        let min = Int(progress / 60)
        let sec = Int(progress - Double(min * 60))
        startTimeLabel.text = String(format: "%02d:%02d", min, sec)
    }
    // 逐词播放
    private func getLyricsInfo() {
        timeArray = LyricsUtil.timeArray(withLineLyric: lyrics)
        startTimeArray = LyricsUtil.startTimeArray(withLineLyric: lyrics)
        lyricsStr = LyricsUtil.getLyricString(withLyric: lyrics)
        lyricsSArray = LyricsUtil.getLyricSArray(withLyric: lyrics)
        wordNumArray = LyricsUtil.getLineLyricWordNmu(withLyric: lyrics)
        maxNum = LyricsUtil.getMaxLineNum(withArray: wordNumArray)
    }
    /// 读取歌词
    private func loadLyrics() {
        let path = Bundle.main.path(forResource: songLabel.text, ofType: "lrc")
        if let path = path {
            lrc = KugouLyricsManage()
            lrc.path = path
            lrc.readFile()
            lrc.sort()
            centerLyricsLable.text = lrc.str
            centerLyricsLable.textColor = UIColor.greenx
            haveLyrics = true
        } else {
            centerLyricsLable.text = "暂未找到歌词"
            centerLyricsLable.textColor = UIColor.blackx
            haveLyrics = false
        }
    }
    // 播放歌词
    private func lyricsPlay() {
        if timer == nil {
            privateIndex = 0
            timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.updateLyrics(_:)), userInfo: nil, repeats: true)
            let runloop = RunLoop.current
            runloop.add(timer!, forMode: .common)
        } else {
            timer?.fireDate = Date.distantPast
        }
    }
    // 动态更新歌词的位置
    @objc private func updateLyrics(_ timer: Timer?) {
        if privateIndex < lrc.arr.count {
            let tempStr = lrc.arr[privateIndex].myTime.oc.substring(from: 3)
            let x = (lrc.arr[privateIndex].myTime.doubleValue * 60) + (Double(tempStr) ?? 0.0)
            if (audioPlayer?.currentTime ?? 0) >= x {
                centerLyricsLable.text = lrc.arr[privateIndex].lyric
                centerLyricsLable.textColor = UIColor.greenx
                privateIndex += 1
            }
        }
        if privateIndex == lrc.arr.count {
            centerLyricsLable.textColor = UIColor.redx
        }
    }
    //判断歌词播放换行
    @objc private func changeTime() {
        for i in 0..<startTimeArray.count {
            let startTime = startTimeArray[i].intValue
            let currentTime = Double(startTime) * 1.0 / 1000
            if currentTime - (audioPlayer?.currentTime ?? 0) >= 0 && currentTime - (audioPlayer?.currentTime ?? 0) <= 0.02 {
                changeLine(withNmu: i)
            }
        }
    }
    //改变变色mask位置和动画传值
    private func changeLine(withNmu num: Int) {
        lyricsView.maskLayer.position = CGPoint(x: 0, y: (lineSize.height - 9) * CGFloat(num))
        lyricsView.maskLayer.bounds = CGRect(x: 0, y: 0, width: 0, height: lineSize.height - 9)
        if num >= 8 {
            backScrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(num - 7) * (lineSize.height - 9) + 5), animated: true)
        }
        //timeArray每行歌词的每个单词的开始时间，必须以0开头，总时间结尾
        let timeArray = self.timeArray[num]
        var timeSumArray: [String] = []
        let wordNmu = wordNumArray[num].intValue
        let start = (maxNum - wordNmu) / 2
        let end = start + wordNmu
        for y in 0...maxNum {
            if y <= start {
                timeSumArray.append("0")
            } else if y > end {
                timeSumArray.append(timeArray[timeArray.count - 1])
            } else {
                timeSumArray.append(timeArray[y - start - 1])
            }
        }
        //locationArray每行歌词的每个单词在相应时间时对应的位置
        var localArray: [String] = []
        for i in 0...maxNum {
            let n = Float(i) / Float(maxNum)
            let wordSNum = String(format: "%lf", n)
            localArray.append(wordSNum)
        }
        lyricsView.startLyricsAnimation(withTimeArray: timeSumArray, andLocationArray: localArray)
    }
    @IBAction func panGestureRecognizer(_ recoginzer: UIPanGestureRecognizer) {
        let touchPoint = recoginzer.location(in: UIApplication.shared.keyWindow)
        if recoginzer.state == .began {
            isMoving = true
            startTouch = touchPoint
        } else if recoginzer.state == .ended {
            //横向滑动速度
            let xVelocity = recoginzer.velocity(in: recoginzer.view?.superview).x
            if touchPoint.x - startTouch.x > 180 || xVelocity > 1000 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(rotationAngle: .pi / 5.5)
                }) { finished in
                    self.isMoving = false
                    self.backLeft = false
                }
            } else if touchPoint.x - startTouch.x < -180 || xVelocity < -1000 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(rotationAngle: -.pi / 5.5)
                }) { finished in
                    self.isMoving = false
                    self.backLeft = true
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform.identity
                }) { finished in
                    self.isMoving = false
                }
            }
            return
        } else if recoginzer.state == .cancelled {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = CGAffineTransform.identity
            }) { finished in
                self.isMoving = false
            }
            return
        }
        if isMoving {
            let x = touchPoint.x - startTouch.x
            let r = CGFloat(.pi / 6 * (x / 320))
            view.transform = CGAffineTransform(rotationAngle: r)
        }
    }
}

extension KugouPlayAudioViewController: AVAudioPlayerDelegate {
    //一曲放完结束后
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Dlog("播放结束")
        switch modelIndex {
        case 0:fastForward()
        case 1:
            if index == arraySongs.count - 1 {
                stop()
            } else {
                fastForward()
            }
        case 2:
            stop()
            play()
        case 3:stop()
        case 4:fastForward()
        default:break
        }
    }
    //音乐播放器被打断(打\接电话)
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        audioPlayer?.stop() //暂停而不是停止
        Dlog("audioPlayerBeginInterruption---被打断")
    }
    //音乐播放器停止打断(打\接电话)
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        Dlog("audioPlayerEndInterruption---停止打断")
        if isPlaying {
            player.play() //继续播放
        }
    }
}
