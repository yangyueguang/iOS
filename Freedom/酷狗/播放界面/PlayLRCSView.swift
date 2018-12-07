//
//  PlayLRCSView.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/12/7.
//  Copyright © 2018 薛超. All rights reserved.
// LRC 歌词文件逐行展示

import UIKit
private class SHLrcLine: NSObject {
    var time = ""
    var words = ""//歌词内容
}
private class SHMusicLrcCell: UITableViewCell {
    var message: SHLrcLine! {
        didSet {
            contentView.addSubview(lrcLabel)
        }
    }
    lazy var lrcLabel: UILabel = {
        let lrcLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        lrcLabel.font = UIFont.systemFont(ofSize: 17)
        lrcLabel.text = message.words
        lrcLabel.textColor = UIColor.purple
        lrcLabel.textAlignment = .center
        lrcLabel.textColor = UIColor.lightText
        return lrcLabel
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func settingCurrentTextColor() {
        lrcLabel.textColor = UIColor.red
        lrcLabel.font = UIFont.systemFont(ofSize: 25)
    }
    func settingLastTextColor() {
        lrcLabel.textColor = UIColor.lightText
        lrcLabel.font = UIFont.systemFont(ofSize: 17)
    }
}
class PlayLRCSView: UIView {
    //歌词文件名 //对lrc格式解析歌词
    var lrcname = "" {
        didSet {
            //读取歌词文件
            guard let url = Bundle.main.url(forResource: lrcname, withExtension: nil) else { return }
            guard let lrcString = try? String(contentsOf: url, encoding: String.Encoding.utf8) else { return }
            let lrcs = lrcString.components(separatedBy: "\n")
            //把每一行歌词放入数组中
            for lrcComp in lrcs {
                let line = SHLrcLine()
                lrclines.append(line)
                if !(lrcComp.hasPrefix("[")) {
                    continue
                }
                if lrcComp.hasPrefix("[ti:") || lrcComp.hasPrefix("[ar:") || lrcComp.hasPrefix("[al:") || lrcComp.hasPrefix("[t_time:") {
                    let words = lrcComp.components(separatedBy: ":").last ?? ""
                    line.words = (words as NSString).substring(from: 1)
                } else {
                    let array = lrcComp.components(separatedBy: "]")
                    line.time = (array.first! as NSString).substring(from: 1)
                    line.words = array.last ?? ""
                }
            }
            tableView.reloadData()
        }
    }
    // 滚动歌词，设置播放当前行属性//歌曲当前播放时间点
    var currentTime: TimeInterval = 0.0 {
        didSet {
            let min = Int(currentTime / 60)
            let sec = Int(currentTime) % 60
            let msec = Int(currentTime) - sec * 100
            //歌曲正在播放的时间
            let currentTimeStr = String(format: "%02d:%02d:%02d", min, sec, msec)
            for idx in 0..<lrclines.count {
                let line = lrclines[idx]
                let lineTime = line.time
                var nextLineTime = ""
                let nextIdx: Int = idx + 1
                if nextIdx < lrclines.count {
                    let nextLine = lrclines[nextIdx]
                    nextLineTime = nextLine.time
                }
                var lastLineTime = ""
                let lastIdx: Int = idx - 1
                if lastIdx > 0 {
                    let lastLine = lrclines[lastIdx]
                    lastLineTime = lastLine.time
                    print(lastLineTime)
                }
                let p1 = IndexPath(row: idx, section: 0)
                let p2 = IndexPath(row: nextIdx, section: 0)
                //判断这一行是否是正在播放的那一行
                if currentTimeStr.compare(lineTime) != .orderedAscending && currentTimeStr.compare(nextLineTime) == .orderedAscending && currentIdx != idx {
                    tableView.reloadRows(at: [p1, p2], with: .fade)
                    tableView.scrollToRow(at: p1, at: .bottom, animated: true)
                    let cell = tableView.cellForRow(at: p1) as? SHMusicLrcCell
                    cell?.settingCurrentTextColor()
                    currentIdx = idx
                } else if currentTimeStr.compare(nextLineTime) == .orderedDescending && currentIdx != nextIdx {
                    let cell = tableView.cellForRow(at: p2) as? SHMusicLrcCell
                    cell?.settingLastTextColor()
                }
            }
        }
    }
    //显示歌词的tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private var lrclines: [SHLrcLine] = []//保存歌词的数组，每个元素就是一行歌词
    private var currentIdx: Int = 0//当前正在播放的那一行歌词
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(tableView)
    }
    override func layoutSubviews() {
        tableView.frame = bounds
        //设置歌词显示居中位置
        tableView.contentInset = UIEdgeInsets(top: tableView.frame.size.height * 0.5, left: 0, bottom: tableView.frame.size.height * 0.5, right: 0)
    }
}
extension PlayLRCSView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SHMusicLrcCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        cell.message = lrclines[indexPath.row]
        return cell
    }
}
