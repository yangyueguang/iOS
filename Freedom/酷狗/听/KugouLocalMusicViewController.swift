//
//  LocalMusicViewController.swift
//  Freedom
import UIKit
import XExtension
import AVFoundation
import MediaToolbox
import MediaPlayer
class KugouLocalMusicCell: BaseTableViewCell<Any> {
    override func initUI() {
    }
}
class KugouLocalMusicViewController: KugouBaseViewController {
    var musicController: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    var iconArr = [UIImage]()// 头像
    var songArr = [String]()// 歌曲名
    var singerArr = [String]()// 歌手
    var musicArr = [MPMediaItem]()// 歌曲
    var assetURLArr = [URL]()// 对应的url地址
    var timerArr = [AnyHashable]()// 时长
    override func viewDidLoad() {
        super.viewDidLoad()
        musicController.beginGeneratingPlaybackNotifications()
        // 允许其添加通知，用来监听到MPMusicPlayerController
        //        [self addNoticefication];
        title = "我的音乐"
        setupLocalMusic()
        setupTableView()
    }
    func setupLocalMusic() {
        let everyMusic = MPMediaQuery()
        musicArr = everyMusic.items!
        for mediaItem: MPMediaItem? in musicArr {
            songArr.append(mediaItem?.title ?? "")
            singerArr.append(mediaItem?.albumArtist ?? "")
            if let anURL = mediaItem?.assetURL {
                assetURLArr.append(anURL)
            }
            timerArr.append(mediaItem?.playbackDuration ?? 0.0)
            if mediaItem?.artwork != nil {
                let image: UIImage? = mediaItem?.artwork?.image(at: CGSize(width: 50, height: 50))
                if let anImage = image {
                    iconArr.append(anImage)
                }
            } else {
                iconArr.append(Image.holder.image)
            }
        }
    }
    func setupTableView() {
        tableView = BaseTableView(frame: CGRect(x: 0, y: 64, width: APPW, height: APPH), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singerArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :KugouLocalMusicCell = KugouLocalMusicCell.getInstance() as! KugouLocalMusicCell
//        cell.iconView.image = iconArr[indexPath.row]
//        cell.iconView.layer.cornerRadius = cell.iconView.frame.size.width * 0.5
//        cell.iconView.layer.masksToBounds = true
//        cell.mainLable.text = songArr[indexPath.row]
//        cell.subLable.text = singerArr[indexPath.row]
        let second: Int = timerArr[indexPath.row] as! Int
        if second < 60 {
//            cell.timerLable.text = "\(second)'"
        } else {
            let minus: Int = second / 60
//            cell.timerLable.text = "\(minus):\(second % 60)'"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let def = UserDefaults.standard
        let myencode = def.value(forKey: "currentMusicInfo") as? Data
        let encoder : NSCoder = NSKeyedUnarchiver.unarchiveObject(with: myencode!) as! NSCoder
        encoder.encode(musicArr[indexPath.row], forKey: "mediaItem")
        let encodeData = NSKeyedArchiver.archivedData(withRootObject:encoder)
        def.set(encodeData, forKey: "currentMusicInfo")
        def.synchronize()
        // 把相关信息传递到tabbar
        let tabbar = tabBarController as? KugouTabBarController

//        tabbar?.coustomTabBar?.assetUrl = assetURLArr[indexPath.row]
//        tabbar?.coustomTabBar?.iconView.image = iconArr[indexPath.row]
//        tabbar?.coustomTabBar?.songNameLable.text = songArr[indexPath.row]
//        tabbar?.coustomTabBar?.singerLable.text = singerArr[indexPath.row]
    }
}
