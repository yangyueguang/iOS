//
//  KugouTabBarController.swift
//  Freedom
import UIKit
import XExtension
import AVFoundation
import MediaPlayer
class TabBarView: UIView, AVAudioPlayerDelegate {
    var iconView: UIImageView!
    var sliderView: UISlider!
    var starBtn: UIButton!
    var nextBtn: UIButton!
    var menuBtn: UIButton!
    var songNameLable: UILabel!
    var singerLable: UILabel!
    var assetUrl: URL?
    lazy var avPlayer: AVAudioPlayer = {//标签
        let av = try? AVAudioPlayer(contentsOf: assetUrl!)
        av?.volume = 1// 音量 0-1
        av?.pan = 0// 音域  -1一边能听到两个耳机都能听到
        av?.enableRate = true// 允许设置速率
        av?.rate = 1// 设置速率
        let a = av!.duration
        let b = av!.currentTime
        let c = av!.numberOfLoops
        let d = av!.numberOfChannels
        print(String(format: "%ld %lf %d %d",a,b,c,d))
        av?.delegate = self
        return av!
    }();
    weak var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView = UIImageView(frame: CGRect(x: 8, y: 0, width: 55, height: 55))
        iconView.image = UIImage(named: "placeHoder-128")
        sliderView = UISlider(frame: CGRect(x: 70, y: 0, width: frame.size.width - 80, height: 30))
        songNameLable = UILabel(frame: CGRect(x: 75, y: 23, width: frame.size.width / 2, height: 15))
        songNameLable.textColor = UIColor.red
        songNameLable.font = Font(15)
        singerLable = UILabel(frame: CGRect(x: 75, y: 40, width: songNameLable.frame.size.width, height: 15))
        singerLable.textColor = UIColor.green
        singerLable.font = Font(13)
        menuBtn = UIButton(frame: CGRect(x: frame.size.width - 25, y: 30, width: 20, height: 20))
        starBtn = UIButton(frame: CGRect(x: frame.size.width - 125, y: 30, width: 20, height: 20))
        nextBtn = UIButton(frame: CGRect(x: frame.size.width - 85, y: 30, width: 20, height: 20))
        menuBtn.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        starBtn.setBackgroundImage(UIImage(named: "stop"), for: .normal)
        nextBtn.setBackgroundImage(UIImage(named: "next"), for: .normal)
        sliderView.addTarget(self, action: #selector(self.clickSliderView(_:)), for: .valueChanged)
        starBtn.addTarget(self, action: #selector(self.clickStartBtn(_:)), for: .touchUpInside)
        addSubviews([iconView, sliderView, songNameLable, singerLable, menuBtn, starBtn, nextBtn, menuBtn])
        backgroundColor = UIColor.white
        iconView.layer.cornerRadius = 22.5
        iconView.clipsToBounds = true
        sliderView.setThumbImage(UIImage(named: "slider"), for: .normal)
        let def = UserDefaults.standard
        let myencode = def.value(forKey: "currentMusicInfo") as? Data
        var coder: NSCoder? = nil
        if let aMyencode = myencode {
            coder = NSKeyedUnarchiver.unarchiveObject(with: aMyencode) as? NSCoder
        }
        let mediaItem = coder?.decodeObject(forKey: "mediaItem") as? MPMediaItem
        if myencode != nil {
            assetUrl = mediaItem?.assetURL
            songNameLable.text = mediaItem?.title
            singerLable.text = mediaItem?.albumArtist
            if mediaItem?.artwork != nil {
                let image: UIImage? = mediaItem?.artwork?.image(at: CGSize(width: 50, height: 50))
                iconView.image = image
            } else {
                iconView.image = UIImage(named: "placeHoder-128")
            }
            pause()
            starBtn.isSelected = false
        } else {
            songNameLable.text = "暂无播放歌曲"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func clickStartBtn(_ sender: Any?) {
        starBtn.isSelected = !starBtn.isSelected
        if starBtn.isSelected {
            // 播放
            play()
        } else {
            // 暂停
            pause()
        }
    }
    func setAssetUrl(_ assetUrl: URL?) {
        // 每次传进数据之前，停止现在的一切操作
        sliderView.value = 0
        stop()
        self.assetUrl = assetUrl
        play()
    }
    /**启动定时器*/
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.music), userInfo: nil, repeats: true)
        timer?.fire()
    }
    /**关闭定时器*/
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    /**启动定时器后每隔一段时间来到这个方法*/
    @objc func music() {
        sliderView.value = Float(avPlayer.currentTime / avPlayer.duration)
    }
    // MARK: - 播放音乐
    func play() {
        avPlayer.play()
        startTimer()
        starBtn.isSelected = true
        // 转动头像
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if !self.starBtn.isSelected {
                self.stopIconRotion()
            } else {
                self.iconRotation()
            }
        })
    }
    // MARK: - 停止音乐
    func stop() {
        avPlayer.stop()
        stopIconRotion()
    }
    // MARK: - 暂停音乐
    func pause() {
        avPlayer.pause()
        stopTimer()
        stopIconRotion()
    }
    // MARK: - 转动头像
    func iconRotation() {
        let rotation = CABasicAnimation()
        rotation.duration = 3
        rotation.repeatCount = MAXFLOAT
        rotation.keyPath = "transform.rotation.z"
        rotation.toValue = Double.pi * 2
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        //设置动画节奏
        iconView.layer.add(rotation, forKey: nil)
    }
    // MARK: - 停止转动头像
    func stopIconRotion() {
        iconView.layer.removeAllAnimations()
    }
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopIconRotion()
        avPlayer = player
        starBtn.isSelected = false
    }
    @objc func clickSliderView(_ sender: Any?) {
        avPlayer.currentTime = Double(sliderView.value) * Double(avPlayer.duration)
    }
    //打开播放详情页
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            let playBoxVC: PlayAudioViewController = PlayAudioViewController.shared() as! PlayAudioViewController
            playBoxVC.view.transform = .identity
        }) { finished in
        }
    }
}
class KugouTabBarController: BaseTabBarViewController {
    let coustomTabBar = TabBarView(frame: CGRect(x: 0, y: 49 - TabBarH, width: APPW, height: TabBarH))
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建RESideMenu对象(指定内容/左边/右边)
        let navi = KugouNavigationViewController(rootViewController: KugouMainViewController())
        let sideViewController = RESideMenu(contentViewController: navi, leftMenuViewController: KugouSettingViewController(), rightMenuViewController: KugouRightSettingViewController())
        sideViewController?.backgroundImage = UIImage(named:"bj");
        //设置内容控制器的阴影颜色/半径/enable
        sideViewController?.contentViewShadowColor = .black
        sideViewController?.contentViewShadowRadius = 10;
        sideViewController?.contentViewShadowEnabled = true
        addChild(sideViewController!)
    }
}
