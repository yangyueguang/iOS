//
//  PlayLRCSView.swift
//  Freedom
// LRC 歌词文件逐行展示
import UIKit
@objcMembers
class LyricsUtil: NSObject {
    //拿到krc歌词，返回每句歌词的当个字time组成的数据，只针对krc
    class func timeArray(withLineLyric lineLyric: String) -> [[String]] {
        let LyricTillte: NSRange = lineLyric.oc.range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return [] }
        let LyricBody = lineLyric.oc.substring(from: LyricTillte.location + 10)
        let lineLyricd = LyricBody.replacingOccurrences(of: ",0>", with: ">")
        Dlog(lineLyricd)
        var timeArray: [[String]] = []
        let lineArray = lineLyricd.components(separatedBy: "\n")
        for i in 1..<lineArray.count - 1 {
            var oneLineArray: [String] = []
            let start: NSRange = (lineArray[i] as NSString).range(of: "]")
            let sub = (lineArray[i] as NSString).substring(from: Int(start.location) + 1)
            Dlog(sub)
            let array = sub.components(separatedBy: ">")
            for y in 0..<array.count - 1 {
                let start: NSRange = (array[y] as NSString).range(of: "<")
                let end: NSRange = (array[y] as NSString).range(of: ",")
                let sub1 = (array[y] as NSString).substring(with: NSRange(location: Int(start.location) + 1, length: Int(end.location - start.location) - 1))
                oneLineArray.append(sub1)
            }
            let start1: NSRange = (array[array.count - 2] as NSString).range(of: ",")
            let sub2 = (array[array.count - 2] as NSString).substring(from: Int(start1.location) + 1)
            let lastTime = oneLineArray[oneLineArray.count - 1]
            let sub2N = NSNumber(value: Int(sub2) ?? 0)
            let lastTimeN = Int(lastTime) ?? 0
            let lastN: Int = Int(sub2N) + lastTimeN
            let lastStr = "\(lastN)"
            oneLineArray.append(lastStr)
            timeArray.append(oneLineArray)
        }
        Dlog(timeArray)
        return timeArray
    }
    //得到每一行开始时间的数组,可根据时间判断换行
    class func startTimeArray(withLineLyric lineLyric: String) -> [String] {
        let LyricTillte: NSRange = lineLyric.oc.range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return [] }
        let LyricBody = lineLyric.oc.substring(from: LyricTillte.location + 10)
        var stratTimeArray: [String] = []
        let array = LyricBody.components(separatedBy: "\n")
        for i in 1..<array.count - 1 {
            //截取每行的开始时间
            let start: NSRange = (array[i] as NSString).range(of: "[")
            let end: NSRange = (array[i] as NSString).range(of: ",")
            let sub = (array[i] as NSString).substring(with: NSRange(location: Int(start.location) + 1, length: Int(end.location - start.location) - 1))
            Dlog(sub)
            stratTimeArray.append(sub)
        }
        Dlog(stratTimeArray)
        return stratTimeArray
    }
    //得到不带时间的歌词
    class func getLyricString(withLyric lineLyric: String) -> String {
        let LyricTillte: NSRange = lineLyric.oc.range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return "" }
        let LyricBody = lineLyric.substring(from: LyricTillte.location + 10)
        var LyricStr = ""
        let lineArray = LyricBody.components(separatedBy: "\n")
        for i in 1..<lineArray.count - 1 {
            let array = lineArray[i].components(separatedBy: "<")
            Dlog(array)
            var lineStr = ""
            for y in 1..<array.count {
                let start: NSRange = (array[y] as NSString).range(of: ">")
                let sub1 = (array[y] as NSString).substring(from: Int(start.location) + 1)
                lineStr = lineStr + sub1
                Dlog(sub1)
            }
            LyricStr += lineStr
            LyricStr += "\n"
        }
        return LyricStr
    }
    //得到不带时间的歌词的数组
    class func getLyricSArray(withLyric lineLyric: String) -> [String] {
        let LyricTillte: NSRange = (lineLyric as NSString).range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return [] }
        let LyricBody = (lineLyric as NSString).substring(from: LyricTillte.location + 10)
        var lyricSArray: [String] = []
        let lineArray = LyricBody.components(separatedBy: "\n")
        for i in 1..<lineArray.count - 1 {
            let array = lineArray[i].components(separatedBy: "<")
            Dlog(array)
            var lineStr = ""
            for y in 1..<array.count {
                let start: NSRange = (array[y] as NSString).range(of: ">")
                let sub1 = (array[y] as NSString).substring(from: Int(start.location) + 1)
                lineStr = lineStr + sub1
                Dlog(sub1)
            }
            lyricSArray.append(lineStr)
        }
        return lyricSArray
    }
    //得到歌词的总行
    class func getLyricLineNum(withLyric lineLyric: String) -> Int {
        let LyricTillte: NSRange = (lineLyric as NSString).range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return 0 }
        let LyricBody = (lineLyric as NSString).substring(from: LyricTillte.location + 10)
        var lineNum: Int
        let lineArray = LyricBody.components(separatedBy: "\n")
        lineNum = lineArray.count - 2
        return lineNum
    }
    //得到每行歌词有多少个字的数组
    class func getLineLyricWordNmu(withLyric lineLyric: String) -> [String] {
        var wordNumArray: [String] = []
        let LyricTillte: NSRange = (lineLyric as NSString).range(of: "[offset:0]")
        guard LyricTillte.length > 0 else { return [] }
        let LyricBody = (lineLyric as NSString).substring(from: LyricTillte.location + 10)
        let lineArray = LyricBody.components(separatedBy: "\n")
        for i in 1..<lineArray.count - 1 {
            let array = lineArray[i].components(separatedBy: "<")
            let num: Int = array.count - 1
            let sNum = "\(num)"
            wordNumArray.append(sNum)
        }
        return wordNumArray
    }
    //得到最大行的字体个数
    class func getMaxLineNum(withArray lineNumArray: [String]) -> Int {
        var max: Int = 0
        lineNumArray.forEach { (str) in
            if max < Int(str) ?? 0 {
                max = Int(str) ?? 0
            }
        }
        return max
    }
}
@objcMembers
class LyricsAndTime: NSObject {
    var lyric = ""
    var myTime = ""
    init(lyrics lyric: String, andTime time: String) {
        super.init()
        self.lyric = lyric
        myTime = time
    }
    func islater(_ obj: LyricsAndTime) -> Bool {
        return myTime.compare(obj.myTime).rawValue > 0
    }
}

@objcMembers
class KugouLyricsManage: NSObject {
    var arr: [LyricsAndTime] = []
    var str = ""
    var path = ""
    func readFile() {
        let str = try? String(contentsOfFile: path, encoding: .utf8)
        var arr = [String]()
        if let components = str?.components(separatedBy: CharacterSet(charactersIn: "[]")) {
            arr = components
        }
        let song = arr[1].oc.substring(from: Int(arr[1].oc.range(of: ":").location) + 1)
        let singer = arr[3].oc.substring(from: Int(arr[3].oc.range(of: ":").location) + 1)
        self.str = "\(song)\(singer)"

        var i = 9
        while i < arr.count {
            var x: Int = 1
            while (arr[i + x] == "") {
                x += 2
            }
            let obj = LyricsAndTime(lyrics: arr[i + x], andTime: arr[i])
            self.arr.append(obj)
            i += 2
        }
    }
    func sort() {
        arr = arr.sorted(by: { (a, b) -> Bool in
            return a.islater(b)
        })
    }

    func play() {
        Dlog(str)
        var temp: Float = 0
        for obj: LyricsAndTime in arr {
            Dlog(obj)
            let x = (Float(obj.myTime) ?? 0) * 60 + (Float((obj.myTime as NSString).substring(from: 3)) ?? 0.0)
            sleep(UInt32(x - temp))
            temp = x
        }
    }

}
@objcMembers
class LyricsView: UIView {
    var textLable = UILabel()
    var maskLable = UILabel()
    var maskLayer: CALayer = CALayer()//用来控制maskLabel渲染的layer
    override init(frame: CGRect) {
        super.init(frame: frame)
        firstInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        firstInit()
    }
    private func firstInit() {
        textLable.frame = bounds
        textLable.textAlignment = .center
        textLable.textColor = UIColor.whitex
        maskLable.frame = bounds
        maskLable.textAlignment = .center
        maskLable.textColor = UIColor.greenx
        maskLable.backgroundColor = UIColor.clear
        maskLayer.anchorPoint = CGPoint.zero
        maskLayer.position = CGPoint(x: 0, y: 0)
        maskLayer.bounds = CGRect(x: 0, y: 0, width: 0, height: 25)
        maskLayer.backgroundColor = UIColor.whitex.cgColor
        maskLable.layer.mask = maskLayer
        addSubview(textLable)
        addSubview(maskLable)
    }

    var text: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            let attributedString = NSMutableAttributedString(string: text ?? "")
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,range: NSRange(location: 0, length: text?.count ?? 0))
            textLable.attributedText = attributedString
            maskLable.attributedText = attributedString
        }
    }
    func startLyricsAnimation(withTimeArray timeArray: [String], andLocationArray locationArray: [String]) {
        //每行歌词的时间总长
        let totalDuration = CGFloat((Float(timeArray.last ?? "") ?? 0) * 1.0 / 1000)
        let animation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        var keyTimeArray: [NSNumber] = []
        var widthArray: [NSNumber] = []
        for i in 0..<timeArray.count {
            let tempTime = CGFloat((Float(timeArray[i]) ?? 0) * 1.0 / 1000) / totalDuration
            keyTimeArray.append(NSNumber(value: Float(tempTime)))
            let tempWidth = (Float(locationArray[i]) ?? 0) * Float(maskLable.frame.width)
            widthArray.append(NSNumber(value: tempWidth))
        }
        animation.values = widthArray
        animation.keyTimes = keyTimeArray
        animation.duration = CFTimeInterval(totalDuration)
        animation.calculationMode = .linear
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        maskLayer.add(animation, forKey: "MaskAnimation")
    }
    func stop() {
        pause(maskLayer)
        maskLayer.removeAllAnimations()
        maskLayer = CALayer()
    }
    //暂停
    func pause(_ layer: CALayer?) {
        let pausedTime: CFTimeInterval? = layer?.convertTime(CACurrentMediaTime(), from: nil)
        layer?.speed = 0.0
        layer?.timeOffset = pausedTime ?? 0
    }
    func reAnimation() {
        resumeLayer(maskLayer)
    }
    //恢复
    func resumeLayer(_ layer: CALayer?) {
        let pausedTime: CFTimeInterval? = layer?.timeOffset
        layer?.speed = 1.0
        layer?.timeOffset = 0.0
        layer?.beginTime = 0.0
        let timeSincePause: CFTimeInterval = (layer?.convertTime(CACurrentMediaTime(), from: nil) ?? 0) - (pausedTime ?? 0)
        layer?.beginTime = timeSincePause
    }
}



private class SHLrcLine: NSObject {
    var time = ""
    var words = ""//歌词内容
}
private class SHMusicLrcCell: BaseTableViewCell<SHLrcLine> {
    var message: SHLrcLine! {
        didSet {
            contentView.addSubview(lrcLabel)
        }
    }
    lazy var lrcLabel: UILabel = {
        let lrcLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        lrcLabel.font = UIFont.large
        lrcLabel.text = message.words
        lrcLabel.textColor = UIColor.grayx
        lrcLabel.textAlignment = .center
        lrcLabel.textColor = UIColor.light
        return lrcLabel
    }()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func settingCurrentTextColor() {
        lrcLabel.textColor = UIColor.redx
        lrcLabel.font = UIFont.systemFont(ofSize: 25)
    }
    func settingLastTextColor() {
        lrcLabel.textColor = UIColor.light
        lrcLabel.font = UIFont.large
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
        let cell = SHMusicLrcCell(style: .default, reuseIdentifier: SHMusicLrcCell.identifier)
        cell.backgroundColor = UIColor.clear
        cell.message = lrclines[indexPath.row]
        return cell
    }
}
