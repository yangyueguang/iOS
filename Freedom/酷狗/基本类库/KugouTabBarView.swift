//
//  KugouTabBarView.swift
//  Freedom
//
import UIKit
import SnapKit
//import XExtension
import MediaPlayer
//@IBDesignable
class KugouTabBarView: UIView, AVAudioPlayerDelegate {
    @IBOutlet var contentView: UIView!
    weak var timer: Timer?
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var songNameLable: UILabel!
    @IBOutlet weak var singerLable: UILabel!
    var assetUrl: URL? {
        didSet {
            sliderView.value = 0
            stop()
            play()
        }
    }
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    func initFromXIB() {
        let nib = UINib(nibName: "KugouTabBarView", bundle: Bundle.main)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderView.setThumbImage(Image.slider.image, for: .normal)
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
                iconView.image = Image.logo.image
            }
            pause()
            starBtn.isSelected = false
        } else {
            songNameLable.text = "暂无播放歌曲"
        }
    }

    @IBAction func playAction(_ sender: UIButton) {
        starBtn.isSelected = !starBtn.isSelected
        if starBtn.isSelected {
            play()
        } else {
            pause()
        }
    }
    @IBAction func nextAction(_ sender: Any) {
    }
    @IBAction func menuAction(_ sender: Any) {
    }
    @IBAction func sliderAction(_ sender: Any) {
         avPlayer.currentTime = Double(sliderView.value) * Double(avPlayer.duration)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.music), userInfo: nil, repeats: true)
        timer?.fire()
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
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
    //打开播放详情页
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            let playBoxVC = KugouPlayAudioViewController.shared()
            playBoxVC.view.transform = .identity
        }) { finished in
        }
    }
}
