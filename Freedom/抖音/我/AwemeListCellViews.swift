//
//  AwemeListCellViews.swift
//  Douyin
//
//  Created by Chao Xue 薛超 on 2018/11/26.
//  Copyright © 2018 Qiao Shi. All rights reserved.
//
import MJRefresh
import XCarryOn
import Foundation
import AVFoundation
import MobileCoreServices

//自定义Delegate，用于进度、播放状态更新回调
protocol AVPlayerUpdateDelegate:NSObjectProtocol {
    //播放进度更新回调方法
    func onProgressUpdate(current:CGFloat, total:CGFloat)
    //播放状态更新回调方法
    func onPlayItemStatusUpdate(status:AVPlayerItem.Status)
}

class AVPlayerView: UIView {

    var delegate:AVPlayerUpdateDelegate?    //代理

    var sourceURL:URL?                      //视频路径
    var sourceScheme:String?                   //路径Scheme
    var urlAsset:AVURLAsset?                //视频资源
    var playerItem:AVPlayerItem?            //视频资源载体
    var player:AVPlayer?                    //视频播放器
    var playerLayer:AVPlayerLayer = AVPlayerLayer.init()          //视频播放器图形化载体
    var timeObserver:Any?                   //视频播放器周期性调用的观察者

    var data:Data?                          //视频缓冲数据

    var session:URLSession?                 //视频下载session
    var task:URLSessionDataTask?            //视频下载NSURLSessionDataTask

    var response:HTTPURLResponse?           //视频下载请求响应
    var pendingRequests = [AVAssetResourceLoadingRequest]()  //存储AVAssetResourceLoadingRequest的数组

    var cacheFileKey:String?                                 //缓存文件key值
    var queryCacheOperation:Operation?                       //查找本地视频缓存数据的NSOperation

    var cancelLoadingQueue:DispatchQueue?

    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }

    func initSubView() {
        session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.playerLayer)

        addProgressObserver()

        cancelLoadingQueue = DispatchQueue.init(label: "com.start.cancelloadingqueue")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
    func urlScheme(urlStr: String?, scheme:String) -> URL? {
        if let url = URL.init(string: urlStr ?? "") {
            var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = scheme
            return components?.url
        }
        return nil
    }
    func setPlayerSourceUrl(url:String) {
        sourceURL = URL.init(string: url)

        var components = URLComponents.init(url: sourceURL!, resolvingAgainstBaseURL: false)
        sourceScheme = components?.scheme
        cacheFileKey = sourceURL?.absoluteString

        queryCacheOperation = Operation.init()
        DispatchQueue.main.sync {
            if(queryCacheOperation?.isCancelled ?? false) {
                return
            }
        let data = XDataCache.shared.data(cacheFileKey ?? "", fromDisk: true)
        DispatchQueue.main.async{[weak self] in
            if data == nil {
                self?.sourceURL = self?.urlScheme(urlStr: self?.sourceURL?.absoluteString, scheme: "streaming")
            } else {
                self?.sourceURL = URL.init(fileURLWithPath: data as? String ?? "")
            }
            if let url = self?.sourceURL {
                self?.urlAsset = AVURLAsset.init(url: url, options: nil)
                self?.urlAsset?.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
                if let asset = self?.urlAsset {
                    self?.playerItem = AVPlayerItem.init(asset: asset)
                    self?.playerItem?.addObserver(self!, forKeyPath: "status", options: [.initial, .new], context: nil)
                    self?.player = AVPlayer.init(playerItem: self?.playerItem)
                    self?.playerLayer.player = self?.player
                    //                        self?.player.replaceCurrentItem(with: self?.playerItem)
                    self?.addProgressObserver()
                }
            }
        }
        }
    }

    func cancelLoading() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.isHidden = true
        CATransaction.commit()

        queryCacheOperation?.cancel()
        removeObserver()
        pause()

        player = nil
        playerItem = nil
        playerLayer.player = nil

        cancelLoadingQueue?.async {[weak self] in
            self?.urlAsset?.cancelLoading()

            self?.task?.cancel()
            self?.task = nil
            self?.data = nil
            self?.response = nil

            for loadingRequest in self?.pendingRequests ?? [] {
                if !loadingRequest.isFinished {
                    loadingRequest.finishLoading()
                }
            }
            self?.pendingRequests.removeAll()
        }

    }

    func updatePlayerState() {
        if player?.rate == 0 {
            play()
        } else {
            pause()
        }
    }

    func play() {
        AVPlayerManager.shared().play(player: player!)
    }

    func pause() {
        AVPlayerManager.shared().pause(player: player!)
    }

    func replay() {
        AVPlayerManager.shared().replay(player: player!)
    }

    func rate() -> CGFloat {
        return CGFloat(player?.rate ?? 0)
    }

    deinit {
        removeObserver()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AVPlayerView {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if playerItem?.status == .readyToPlay {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                playerLayer.isHidden = false
                CATransaction.commit()
            }
            delegate?.onPlayItemStatusUpdate(status: playerItem?.status ?? AVPlayerItem.Status.unknown)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func addProgressObserver() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: DispatchQueue.main, using: {[weak self] time in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self?.playerItem?.duration ?? CMTime.init())
            if total == current {
                self?.replay()
            }
            self?.delegate?.onProgressUpdate(current: CGFloat(current), total: CGFloat(total))
        })
    }

    func removeObserver() {
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }


}

extension AVPlayerView: URLSessionTaskDelegate, URLSessionDataDelegate {
    //网络资源下载请求获得响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = dataTask.response as! HTTPURLResponse
        let code = httpResponse.statusCode
        if(code == 200) {
            completionHandler(URLSession.ResponseDisposition.allow)
            self.data = Data.init()
            self.response = httpResponse
            self.processPendingRequests()
        }else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }

    //接收网络资源下载数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data?.append(data)
        self.processPendingRequests()
    }

    //网络资源下载请求完毕
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            XDataCache.shared.store(self.data!, forKey: self.cacheFileKey ?? "", toDisk: true)
        } else {
            print("AVPlayer resouce download error:" + error.debugDescription)
        }
    }

    //网络缓存数据复用
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let cachedResponse = proposedResponse
        if dataTask.currentRequest?.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData || dataTask.currentRequest?.url?.absoluteString == self.task?.currentRequest?.url?.absoluteString {
            completionHandler(nil)
        }else {
            completionHandler(cachedResponse)
        }
    }

    func processPendingRequests() {
        var requestsCompleted = [AVAssetResourceLoadingRequest]()
        for loadingRequest in self.pendingRequests {
            let didRespondCompletely = respondWithDataForRequest(loadingRequest: loadingRequest)
            if didRespondCompletely {
                requestsCompleted.append(loadingRequest)
                loadingRequest.finishLoading()
            }
        }
        for completedRequest in requestsCompleted {
            if let index = pendingRequests.index(of: completedRequest) {
                pendingRequests.remove(at: index)
            }
        }
    }

    func respondWithDataForRequest(loadingRequest:AVAssetResourceLoadingRequest) -> Bool {
        let mimeType = self.response?.mimeType ?? ""
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)
        loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        loadingRequest.contentInformationRequest?.contentType = contentType?.takeRetainedValue() as String?
        loadingRequest.contentInformationRequest?.contentLength = (self.response?.expectedContentLength)!

        var startOffset:Int64 = loadingRequest.dataRequest?.requestedOffset ?? 0
        if loadingRequest.dataRequest?.currentOffset != 0 {
            startOffset = loadingRequest.dataRequest?.currentOffset ?? 0
        }

        if Int64(data?.count ?? 0)  < startOffset {
            return false
        }

        let unreadBytes:Int64 = Int64(data?.count ?? 0) - (startOffset)
        let numberOfBytesToRespondWidth:Int64 = min(Int64(loadingRequest.dataRequest?.requestedLength ?? 0), unreadBytes)
        let range = Int(startOffset)..<Int(startOffset + numberOfBytesToRespondWidth)
        if let subdata = (data?.subdata(in: range.lowerBound..<range.upperBound + 1))  {
            loadingRequest.dataRequest?.respond(with: subdata)
            let endOffset:Int64 = startOffset + Int64(loadingRequest.dataRequest?.requestedLength ?? 0)
            return Int64(data?.count ?? 0) >= endOffset
        }
        return false
    }
}

extension AVPlayerView: AVAssetResourceLoaderDelegate {

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if task == nil {
            if let url = urlScheme(urlStr: loadingRequest.request.url?.absoluteString, scheme: sourceScheme ?? "http") {
                let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
                task = session?.dataTask(with: request)
                task?.resume()
            }
        }
        pendingRequests.append(loadingRequest)
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        if let index = pendingRequests.index(of: loadingRequest) {
            pendingRequests.remove(at: index)
        }
    }

}
class FavoriteView:UIView {

    var favoriteBefore = UIImageView.init(image: UIImage.init(named: "icon_home_like_before"))
    var favoriteAfter = UIImageView.init(image: UIImage.init(named: "icon_home_like_after"))

    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 45)))
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        favoriteBefore.frame = self.frame
        favoriteBefore.contentMode = .center
        favoriteBefore.isUserInteractionEnabled = true
        favoriteBefore.tag = LIKE_BEFORE_TAP_ACTION
        favoriteBefore.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteBefore)


        favoriteAfter.frame = self.frame
        favoriteAfter.contentMode = .center
        favoriteAfter.isUserInteractionEnabled = true
        favoriteAfter.tag = LIKE_AFTER_TAP_ACTION
        favoriteAfter.isHidden = true
        favoriteAfter.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteAfter)
    }

    func startLikeAnim(isLike:Bool) {
        favoriteBefore.isUserInteractionEnabled = false
        favoriteAfter.isUserInteractionEnabled = false
        if isLike {
            let length:CGFloat = 30
            let duration:CGFloat = 0.5
            for index in 0..<6 {
                let layer = CAShapeLayer.init()
                layer.position = favoriteBefore.center
                layer.fillColor = UIColor.redx.cgColor

                let startPath = UIBezierPath.init()
                startPath.move(to: CGPoint.init(x: -2, y: -length))
                startPath.addLine(to: CGPoint.init(x: 2, y: -length))
                startPath.addLine(to: .zero)

                let endPath = UIBezierPath.init()
                endPath.move(to: CGPoint.init(x: -2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 0, y: -length))

                layer.path = startPath.cgPath
                layer.transform = CATransform3DMakeRotation(.pi / 3.0 * CGFloat(index), 0.0, 0.0, 1.0)
                self.layer.addSublayer(layer)

                let group = CAAnimationGroup.init()
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                group.fillMode = CAMediaTimingFillMode.forwards
                group.duration = CFTimeInterval(duration)

                let scaleAnim = CABasicAnimation.init(keyPath: "transform.scale")
                scaleAnim.fromValue = 0.0
                scaleAnim.toValue = 1.0
                scaleAnim.duration = CFTimeInterval(duration * 0.2)

                let pathAnim = CABasicAnimation.init(keyPath: "path")
                pathAnim.fromValue = layer.path
                pathAnim.toValue = endPath.cgPath
                pathAnim.beginTime = CFTimeInterval(duration * 0.2)
                pathAnim.duration = CFTimeInterval(duration * 0.8)

                group.animations = [scaleAnim, pathAnim]
                layer.add(group, forKey: nil)
            }
            favoriteAfter.isHidden = false
            favoriteAfter.alpha = 0.0
            favoriteAfter.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: .pi / 3 * 2))
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.favoriteBefore.alpha = 0.0
                self.favoriteAfter.alpha = 1.0
                self.favoriteAfter.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            }) { finished in
                self.favoriteBefore.alpha = 1.0
                self.favoriteBefore.isUserInteractionEnabled = true
                self.favoriteAfter.isUserInteractionEnabled = true
            }
        } else {
            favoriteAfter.alpha = 1.0
            favoriteAfter.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                self.favoriteAfter.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform.init(rotationAngle: .pi/4))
            }) { finished in
                self.favoriteAfter.isHidden = true
                self.favoriteBefore.isUserInteractionEnabled = true
                self.favoriteAfter.isUserInteractionEnabled = true
            }
        }
    }

    func resetView() {
        favoriteBefore.isHidden = false
        favoriteAfter.isHidden = true
        self.layer.removeAllAnimations()
    }


    @objc func handleGesture(sender:UITapGestureRecognizer) {
        switch sender.view?.tag {
        case LIKE_BEFORE_TAP_ACTION:
            startLikeAnim(isLike: true)
            break
        case LIKE_AFTER_TAP_ACTION:
            startLikeAnim(isLike: false)
            break
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class FocusView:UIImageView {

    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 24, height: 24)))
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        self.layer.cornerRadius = frame.size.width/2
        self.layer.backgroundColor = UIColor.redx.cgColor
        self.image = UIImage.init(named: "icon_personal_add_little")
        self.contentMode = .center
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(beginAnimation)))
    }

    @objc func beginAnimation() {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.delegate = self
        animationGroup.duration = 1.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)

        let scaleAnim = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleAnim.values = [1.0, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 0.0]
        let rotationAnim = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnim.values = [-1.5 * .pi, 0.0, 0.0, 0.0]

        let opacityAnim = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnim.values = [0.8, 1.0, 1.0]

        animationGroup.animations = [scaleAnim, rotationAnim, opacityAnim]
        self.layer.add(animationGroup, forKey: nil)
    }

    func resetView() {
        self.layer.backgroundColor = UIColor.redx.cgColor
        self.image = UIImage.init(named: "icon_personal_add_little")
        self.layer.removeAllAnimations()
        self.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusView: CAAnimationDelegate {

    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
        self.contentMode = .scaleToFill
        self.layer.backgroundColor = UIColor.redx.cgColor
        self.image = UIImage.init(named: "iconSignDone")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.isHidden = true
    }
}
protocol SendTextDelegate {
    func onSendText(text:String)
}

protocol HoverTextViewDelegate {
    func hoverTextViewStateChange(isHover:Bool)
}

class HoverTextView:UIView {

    var LEFT_INSET:CGFloat = 40
    var RIGHT_INSET:CGFloat = 100
    var TOP_BOTTOM_INSET:CGFloat = 15

    var textView:UITextView = UITextView.init()
    var delegate:SendTextDelegate?
    var hoverDelegate:HoverTextViewDelegate?

    var textHeight:CGFloat = 0
    var keyboardHeight:CGFloat = 0
    var placeHolderLabel:UILabel = UILabel.init()
    var editImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "ic30Pen1"))
    var atImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "ic30WhiteAt"))
    var sendImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "ic30WhiteSend"))
    var splitLine:UIView = UIView.init()

    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        self.backgroundColor = UIColor.clear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))

        keyboardHeight = safeAreaBottomHeight;

        textView.backgroundColor = UIColor.clear
        textView.clipsToBounds = false
        textView.textColor = UIColor.whitex
        textView.font = .big
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.init(top: TOP_BOTTOM_INSET, left: LEFT_INSET, bottom: TOP_BOTTOM_INSET, right: RIGHT_INSET)
        textHeight = textView.font?.lineHeight ?? 0

        placeHolderLabel.frame = CGRect.init(x:LEFT_INSET, y:0, width:APPW - LEFT_INSET - RIGHT_INSET, height:50)
        placeHolderLabel.text = "有爱评论，说点儿好听的~"
        placeHolderLabel.textColor = UIColor.whiteAlpha(0.4)
        placeHolderLabel.font = .big
        textView.addSubview(placeHolderLabel)
        //        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")

        editImageView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 50)
        editImageView.contentMode = .center
        textView.addSubview(editImageView)

        atImageView.frame = CGRect.init(x: APPW - 50, y: 0, width: 50, height: 50)
        atImageView.contentMode = .center
        textView.addSubview(atImageView)

        sendImageView.frame = CGRect.init(x: APPW, y: 0, width: 50, height: 50)
        sendImageView.contentMode = .center
        sendImageView.isUserInteractionEnabled = true
        sendImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onSend)))
        textView.addSubview(sendImageView)

        splitLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: APPW, height: 0.5))
        splitLine.backgroundColor = UIColor.whiteAlpha(0.4)
        textView.addSubview(splitLine)

        textView.delegate = self
        self.addSubview(textView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = self.superview?.bounds ?? .zero
        updateViewFrameAndState()
    }

    func updateViewFrameAndState() {
        updateIconState()
        updateRightViewsFrame()
        updateTextViewFrame()
    }

    func updateTextViewFrame() {
        let textViewHeight = keyboardHeight > safeAreaBottomHeight ? textHeight + 2*TOP_BOTTOM_INSET : (textView.font?.lineHeight ?? 0) + 2*TOP_BOTTOM_INSET
        self.textView.frame = CGRect.init(x: 0, y: APPH - keyboardHeight - textViewHeight, width: APPW, height: textViewHeight)
    }

    func updateRightViewsFrame() {
        var originX = APPW
        originX -= keyboardHeight > safeAreaBottomHeight ? 50 : (textView.text.count > 0 ? 50 : 0)
        UIView.animate(withDuration: 0.25) {
            self.sendImageView.frame = CGRect.init(x: originX, y: 0, width: 50, height: 50)
            self.atImageView.frame = CGRect.init(x: self.sendImageView.frame.minX - 50, y: 0, width: 50, height: 50)
        }
    }

    func updateIconState() {
        editImageView.image = keyboardHeight > safeAreaBottomHeight ? UIImage.init(named: "ic90Pen1") : (textView.text.count > 0 ? UIImage.init(named: "ic90Pen1") : UIImage.init(named: "ic30Pen1"))
        atImageView.image = keyboardHeight > safeAreaBottomHeight ? UIImage.init(named: "ic90WhiteAt") : (textView.text.count > 0 ? UIImage.init(named: "ic90WhiteAt") : UIImage.init(named: "ic30WhiteAt"))
        sendImageView.image = textView.text.count > 0 ? UIImage.init(named: "ic30RedSend") : UIImage.init(named: "ic30WhiteSend")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HoverTextView {

    @objc func keyboardWillShow(notification:Notification) {
        self.backgroundColor = UIColor.blackAlpha(0.4)
        keyboardHeight = notification.keyBoardHeight()
        updateViewFrameAndState()
        hoverDelegate?.hoverTextViewStateChange(isHover: true)
    }

    @objc func keyboardWillHide(notification:Notification) {
        self.backgroundColor = UIColor.clear
        keyboardHeight = safeAreaBottomHeight
        updateViewFrameAndState()
        hoverDelegate?.hoverTextViewStateChange(isHover: false)
    }
}

extension HoverTextView:UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let attributedText = NSMutableAttributedString.init(attributedString: textView.attributedText)
        textView.attributedText = attributedText
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributedText.boundingRect(with: CGSize(width: APPW - LEFT_INSET - RIGHT_INSET, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        }
        updateViewFrameAndState()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            onSend()
            return false
        }
        return true
    }
}

extension HoverTextView {
    @objc func onSend() {
        delegate?.onSendText(text: textView.text)
        textView.text = ""
        textHeight = textView.font?.lineHeight ?? 0
        textView.resignFirstResponder()
    }

    @objc func handleGuesture(sender:UITapGestureRecognizer) {
        let point = sender.location(in: textView)
        if !(textView.layer.contains(point)) {
            textView.resignFirstResponder()
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if hitView?.backgroundColor == UIColor.clear {
                return nil
            }
        }
        return hitView
    }
}
class MusicAlbumView:UIView {

    var album:UIImageView = UIImageView.init()
    var albumContainer = UIView.init()
    var noteLayers = [CALayer]()

    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 50)))
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        albumContainer.frame = self.bounds
        self.addSubview(albumContainer)

        let backgroundLayer = CALayer.init()
        backgroundLayer.frame = self.bounds
        backgroundLayer.contents = UIImage.init(named: "music_cover")?.cgImage
        albumContainer.layer.addSublayer(backgroundLayer)

        album.frame = CGRect.init(x: 15, y: 15, width: 20, height: 20)
        album.contentMode = .scaleAspectFill
        albumContainer.addSubview(album)
    }

    func startAnimation(rate: CGFloat) {
        let r = rate <= 0 ? 15 : rate

        resetView()

        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 0.0, rate: r)
        initMusicNotoAnimation(imageName: "icon_home_musicnote2", delayTime: 1.0, rate: r)
        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 2.0, rate: r)

        let rotationAnim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnim.toValue = .pi * 2.0
        rotationAnim.duration = 3.0
        rotationAnim.isCumulative = true
        rotationAnim.repeatCount = MAXFLOAT
        albumContainer.layer.add(rotationAnim, forKey: "rotationAnimation")
    }

    func initMusicNotoAnimation(imageName:String, delayTime:TimeInterval, rate:CGFloat) {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = CFTimeInterval(rate/4.0)
        animationGroup.beginTime = CACurrentMediaTime() + delayTime
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)

        let pathAnim = CAKeyframeAnimation.init(keyPath: "position")

        let sideXLength:CGFloat = 40.0
        let sideYLength:CGFloat = 100.0

        let beginPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.maxY)
        let endPoint = CGPoint.init(x: beginPoint.x - sideXLength, y: beginPoint.y - sideYLength)
        let controlLength:CGFloat = 60

        let controlPoint = CGPoint.init(x: beginPoint.x - sideXLength/2 - controlLength, y: beginPoint.y - sideYLength/2 + controlLength)

        let customPath = UIBezierPath.init()
        customPath.move(to: beginPoint)
        customPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)

        pathAnim.path = customPath.cgPath


        //旋转帧动画
        let rotationAnim = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnim.values = [0.0, .pi * 0.1, .pi * -0.1]

        //透明度帧动画
        let opacityAnim = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnim.values = [0.0, 0.2, 0.7, 0.2, 0.0]

        //缩放帧动画
        let scaleAnim = CABasicAnimation.init()
        scaleAnim.keyPath = "transform.scale"
        scaleAnim.fromValue = 1.0
        scaleAnim.toValue = 2.0

        animationGroup.animations = [pathAnim, rotationAnim, opacityAnim, scaleAnim]

        let layer = CAShapeLayer.init()
        layer.opacity = 0.0
        layer.contents = UIImage.init(named: imageName)?.cgImage
        layer.frame = CGRect.init(origin: beginPoint, size: CGSize.init(width: 10, height: 10))
        self.layer.addSublayer(layer)
        noteLayers.append(layer)
        layer.add(animationGroup, forKey: nil)
    }

    func resetView() {
        for subLayer in noteLayers {
            subLayer.removeFromSuperlayer()
        }
        self.layer.removeAllAnimations()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
let SEPARATE_TEXT:String = "   "

class CircleTextView:UIView {

    var _text:String = ""
    var text:String {
        set {
            _text = newValue
            let size = singleLineSizeWithAttributeText(str: newValue, font: font)
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect.init(origin: .zero, size: CGSize.init(width: textWidth * 3 + textSeparateWidth * 2, height: textHeight))
            translationX = textWidth + textSeparateWidth
            drawTextLayer()
            startAnimation()
        }
        get {
            return _text
        }
    }

    var _textColor:UIColor = UIColor.whitex
    var textColor:UIColor {
        set {
            _textColor = newValue
            textLayer.foregroundColor = newValue.cgColor
        }
        get {
            return _textColor
        }
    }

    var _font:UIFont = .middle
    var font:UIFont {
        set {
            _font = newValue
            let size = singleLineSizeWithAttributeText(str: text, font: newValue)
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect.init(origin: .zero, size: CGSize.init(width: textWidth * 3 + textSeparateWidth * 2, height: textHeight))
            translationX = textWidth + textSeparateWidth
            drawTextLayer()
            startAnimation()
        }
        get {
            return _font
        }
    }

    var textLayer = CATextLayer.init()
    var maskLayer = CAShapeLayer.init()
    var textSeparateWidth:CGFloat = 0
    var textWidth:CGFloat = 0
    var textHeight:CGFloat = 0
    var textLayerFrame:CGRect = .zero
    var translationX:CGFloat = 0

    init() {
        super.init(frame: .zero)
        initSubLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubLayer()
    }
    func singleLineSizeWithAttributeText(str: String, font:UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font]
        let attString = NSAttributedString(string: str,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude), nil)
    }

    func initSubLayer() {
        textSeparateWidth = SEPARATE_TEXT.size(withAttributes: [NSAttributedString.Key.font : font]).width
        textLayer.alignmentMode = CATextLayerAlignmentMode.natural
        textLayer.truncationMode = CATextLayerTruncationMode.none
        textLayer.isWrapped = false
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
        self.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = CGRect.init(origin: CGPoint.init(x: 0, y: (self.bounds.height-textLayerFrame.height) / 2), size: textLayerFrame.size)
        maskLayer.frame = self.bounds
        maskLayer.path = UIBezierPath.init(rect: self.bounds).cgPath
        CATransaction.commit()
    }

    func drawTextLayer() {
        textLayer.foregroundColor = textColor.cgColor
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.string = text + SEPARATE_TEXT + text + SEPARATE_TEXT + text
    }

    func startAnimation() {

        let anim = CABasicAnimation.init()
        anim.keyPath = "transform.translation.x"
        anim.fromValue = self.bounds.origin.x
        anim.toValue = self.bounds.origin.x - translationX
        anim.duration = CFTimeInterval(textWidth * 0.035)
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false

        anim.fillMode = CAMediaTimingFillMode.forwards;
        anim.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)

        textLayer.add(anim, forKey: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//
//  CommentsPopView.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/7.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//
import RxSwift
import Foundation
let COMMENT_CELL:String = "CommentCell"
class CommentsPopView:UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, CommentTextViewDelegate {
    let disposeBag = DisposeBag()
let commentsViewModel = PublishSubject<[Comment]>()
let commentVM = PublishSubject<Comment>()
    let baseVM = PublishSubject<BaseResponse>()
    var label = UILabel.init()
    var close = UIImageView.init(image:UIImage.init(named: "icon_closetopic"))
    var awemeId:String?
    var visitor:Visitor = Visitor.read()

    var pageIndex:Int = 0
    var pageSize:Int = 20
    var container = UIView.init()
    var tableView = UITableView.init()
    var data = [Comment]()
    var textView = CommentTextView()

    init(awemeId:String) {
        super.init(frame: UIScreen.main.bounds)
        self.awemeId = awemeId
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)

        container.frame = CGRect.init(x: 0, y: APPH, width: APPW, height: APPH * 3 / 4)
        container.backgroundColor = UIColor.blackAlpha(0.6)
        self.addSubview(container)

        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: APPW, height: APPH * 3 / 4)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape

        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1.0
        container.addSubview(visualEffectView)

        label.frame = CGRect.init(origin: .zero, size: CGSize.init(width: APPW, height: 35))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "0条评论"
        label.textColor = UIColor.grayx
        label.font = .small
        container.addSubview(label)

        close.frame = CGRect.init(x: APPW - 40, y: 0, width: 30, height: 30)
        close.contentMode = .center
        close.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
        container.addSubview(close)

        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 35, width: APPW, height: APPH*3/4 - 35 - 50 - safeAreaBottomHeight), style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: self.tableView.bounds.width, height: 0.01)))
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CommentListCell.classForCoder(), forCellReuseIdentifier: COMMENT_CELL)
        container.addSubview(tableView)
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        })
        textView.delegate = self
        loadData(page: pageIndex)
    }

    func onSendText(text: String) {
        XNetKit.douyinCommentText(aweme_id: awemeId ?? "", text: text, next: commentVM)
        commentVM.subscribe(onNext: {[weak self] (comment) in
            UIView.setAnimationsEnabled(false)
            self?.tableView.beginUpdates()
            self?.data.insert(comment, at: 0)
            var indexPaths = [IndexPath]()
            indexPaths.append(IndexPath.init(row: 0, section: 0))
            self?.tableView.insertRows(at: indexPaths, with: .none)
            self?.tableView.endUpdates()
            self?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            UIView.setAnimationsEnabled(true)
            self?.noticeSuccess("评论成功")
        }).disposed(by: disposeBag)

    }

    func deleteComment(comment:Comment){
        XNetKit.douyinDeleteComment(cid: comment.cid ?? "", next: baseVM)
        baseVM.subscribe(onNext: {[weak self] (response) in
            if let index = self?.data.index(of:comment) {
                self?.tableView.beginUpdates()
                self?.data.remove(at: index)
                var indexPaths = [IndexPath]()
                indexPaths.append(IndexPath.init(row: index, section: 0))
                self?.tableView.deleteRows(at: indexPaths, with: .right)
                self?.tableView.endUpdates()
                self?.noticeSuccess("评论删除成功")
            }
        }).disposed(by: disposeBag)
    }

    func loadData(page:Int, _ size:Int = 20) {
        XNetKit.douyinfindCommentsPaged(aweme_id: awemeId ?? "", page: pageIndex, next: commentsViewModel)
        commentsViewModel.subscribe(onNext: {[weak self] (array) in
            self?.pageIndex += 1
            UIView.setAnimationsEnabled(false)
            self?.tableView.beginUpdates()
            self?.data += array
            var indexPaths = [IndexPath]()
            for row in ((self?.data.count ?? 0) - array.count)..<(self?.data.count ?? 0) {
                let indexPath = IndexPath.init(row: row, section: 0)
                indexPaths.append(indexPath)
            }
            self?.tableView.insertRows(at: indexPaths, with: .none)
            self?.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            self?.tableView.mj_footer.endRefreshing()
            self?.label.text = String.init(array.count) + "条评论"

        }).disposed(by: disposeBag)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentListCell.cellHeight(comment: data[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CommentListCell.self)
        cell.initData(comment: data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = data[indexPath.row]
        if !comment.isTemp && comment.user_type == "visitor" && String.uuid.md5() == comment.visitor?.udid {
            let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "删除", style: .default) {[weak self] (ac) in

                self?.deleteComment(comment: comment)
            }
            sheet.addAction(action)
            self.viewContainingController()?.present(sheet, animated: true, completion: nil)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("CommentListCell")  {
            return false
        } else {
            return true
        }
    }

    @objc func handleGuesture(sender:UITapGestureRecognizer) {
        var point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
        }
        point = sender.location(in: close)
        if close.layer.contains(point) {
            dismiss()
        }
    }

    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y - frame.size.height
            self.container.frame = frame
        }) { finished in
        }
        textView.show()
    }

    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y + frame.size.height
            self.container.frame = frame
        }) { finished in
            self.removeFromSuperview()
            self.textView.dismiss()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            self.frame = CGRect.init(x: 0, y: -offsetY, width: self.frame.width, height: self.frame.height)
        }
        if scrollView.isDragging && offsetY < -50 {
            dismiss()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CommentListCell:BaseTableViewCell<Comment> {

    static let MaxContentWidth:CGFloat = APPW - 55 - 35

    var avatar = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var likeIcon = UIImageView.init(image: UIImage.init(named: "icCommentLikeBefore_black"))
    var nickName = UILabel.init()
    var extraTag = UILabel.init()
    var content = UILabel.init()
    var likeNum = UILabel.init()
    var date = UILabel.init()
    var splitLine = UIView.init()
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        initSubViews()
    }

    func initSubViews() {
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 14
        self.addSubview(avatar)

        likeIcon.contentMode = .center
        self.addSubview(likeIcon)

        nickName.numberOfLines = 1
        nickName.textColor = UIColor.whiteAlpha(0.6)
        nickName.font = .small
        self.addSubview(nickName)

        content.numberOfLines = 0
        content.textColor = UIColor.whiteAlpha(0.8)
        content.font = .middle
        self.addSubview(content)

        date.numberOfLines = 1
        date.textColor = UIColor.grayx
        date.font = .small
        self.addSubview(date)

        likeNum.numberOfLines = 1
        likeNum.textColor = UIColor.grayx
        likeNum.font = .small
        self.addSubview(likeNum)

        splitLine.backgroundColor = UIColor.whiteAlpha(0.1)
        self.addSubview(splitLine)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = UIImage.init(named: "img_find_default")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.snp.makeConstraints { make in
            make.top.left.equalTo(self).inset(15)
            make.width.height.equalTo(28)
        }
        likeIcon.snp.makeConstraints { make in
            make.top.right.equalTo(self).inset(15)
            make.width.height.equalTo(20)
        }
        nickName.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self.avatar.snp.right).offset(10)
            make.right.equalTo(self.likeIcon.snp.left).inset(25)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(self.nickName.snp.bottom).offset(5)
            make.left.equalTo(self.nickName)
            make.width.lessThanOrEqualTo(CommentListCell.MaxContentWidth)
        }
        date.snp.makeConstraints { make in
            make.top.equalTo(self.content.snp.bottom).offset(5)
            make.left.right.equalTo(self.nickName)
        }
        likeNum.snp.makeConstraints { make in
            make.centerX.equalTo(self.likeIcon)
            make.top.equalTo(self.likeIcon.snp.bottom).offset(5)
        }
        splitLine.snp.makeConstraints { make in
            make.left.equalTo(self.date)
            make.right.equalTo(self.likeIcon)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

    func initData(comment:Comment) {
        var avatarUrl:URL?
        if comment.user_type == "user" {
            avatarUrl = URL.init(string: comment.user?.avatar_thumb?.url_list.first ?? "")
            nickName.text = comment.user?.nickname
        } else {
            avatarUrl = URL.init(string: comment.visitor?.avatar_thumbnail?.url ?? "")
            nickName.text = Visitor.formatUDID(udid: comment.visitor?.udid ?? "")
        }
        avatar.kf.setImage(with: avatarUrl)
        content.text = comment.text
        date.text = Date(timeIntervalSince1970: TimeInterval(comment.create_time ?? 0)).timeToNow()
        likeNum.text = String(comment.digg_count ?? 0)
    }

    static func cellHeight(comment:Comment) -> CGFloat {
        let attributedString = NSMutableAttributedString.init(string: comment.text ?? "")
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.middle], range: NSRange.init(location: 0, length: attributedString.length))
        let size:CGSize = attributedString.boundingRect(with: CGSize(width: MaxContentWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return size.height + 30 + 30
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CommentTextViewDelegate:NSObjectProtocol {
    func onSendText(text:String)
}

class CommentTextView:UIView, UITextViewDelegate {


    var leftInset:CGFloat = 15
    var rightInset:CGFloat = 60
    var topBottomInset:CGFloat = 15

    var container = UIView.init()
    var textView = UITextView.init()
    var delegate:CommentTextViewDelegate?

    var textHeight:CGFloat = 0
    var keyboardHeight:CGFloat = 0
    var placeHolderLabel = UILabel.init()
    var atImageView = UIImageView.init(image: UIImage.init(named: "iconWhiteaBefore"))
    var visualEffectView = UIVisualEffectView.init()

    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuestrue(sender:))))

        self.addSubview(container)
        container.backgroundColor = UIColor.blackAlpha(0.4)

        keyboardHeight = safeAreaBottomHeight

        textView = UITextView.init()
        textView.backgroundColor = UIColor.clear
        textView.clipsToBounds = false
        textView.textColor = UIColor.whitex
        textView.font = .big
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: topBottomInset, left: leftInset, bottom: topBottomInset, right: rightInset)
        textHeight = textView.font?.lineHeight ?? 0

        placeHolderLabel.frame = CGRect.init(x:LEFT_INSET, y:0, width:APPW - LEFT_INSET - RIGHT_INSET, height:50)
        placeHolderLabel.text = "有爱评论，说点儿好听的~"
        placeHolderLabel.textColor = UIColor.grayx
        placeHolderLabel.font = .big
        textView.addSubview(placeHolderLabel)
        //        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")

        atImageView.contentMode = .center
        textView.addSubview(atImageView)

        textView.delegate = self
        container.addSubview(textView)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        atImageView.frame = CGRect.init(x: APPW - 50, y: 0, width: 50, height: 50)
        let rounded = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape

        updateTextViewFrame()
    }

    func updateTextViewFrame() {
        let textViewHeight = keyboardHeight > safeAreaBottomHeight ? textHeight + 2 * topBottomInset : (textView.font?.lineHeight ?? 0) + 2*topBottomInset
        textView.frame = CGRect.init(x: 0, y: 0, width: APPW, height: textViewHeight)
        container.frame = CGRect.init(x: 0, y: APPH - keyboardHeight - textViewHeight, width: APPW, height: textViewHeight + keyboardHeight)
    }

    @objc func keyboardWillShow(notification:Notification) {
        keyboardHeight = notification.keyBoardHeight()
        updateTextViewFrame()
        atImageView.image = UIImage.init(named: "iconBlackaBefore")
        container.backgroundColor = UIColor.whitex
        textView.textColor = UIColor.blackx
        self.backgroundColor = UIColor.blackAlpha(0.6)
    }

    @objc func keyboardWillHide(notification:Notification) {
        keyboardHeight = safeAreaBottomHeight
        updateTextViewFrame()
        atImageView.image = UIImage.init(named: "iconWhiteaBefore")
        container.backgroundColor = UIColor.blackAlpha(0.4)
        textView.textColor = UIColor.whitex
        self.backgroundColor = UIColor.clear
    }

    func textViewDidChange(_ textView: UITextView) {
        let attributeText = NSMutableAttributedString.init(attributedString: textView.attributedText)
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributeText.boundingRect(with: CGSize(width: APPW - leftInset - rightInset, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        }
        updateTextViewFrame()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.onSendText(text: textView.text)
            textView.text = ""
            textHeight = textView.font?.lineHeight ?? 0
            textView.resignFirstResponder()
        }
        return true
    }

    @objc func handleGuestrue(sender:UITapGestureRecognizer) {
        let point = sender.location(in: textView)
        if !(textView.layer.contains(point)) {
            textView.resignFirstResponder()
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if hitView?.backgroundColor == UIColor.clear {
                return nil
            }
        }
        return hitView
    }

    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
    }

    func dismiss() {
        self.removeFromSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SharePopView:UIView {

    let topIconsName = [
        "icon_profile_share_wxTimeline",
        "icon_profile_share_wechat",
        "icon_profile_share_qqZone",
        "icon_profile_share_qq",
        "icon_profile_share_weibo",
        "iconHomeAllshareXitong"]
    let topTexts = [
        "朋友圈",
        "微信好友",
        "QQ空间",
        "QQ好友",
        "微博",
        "更多分享"]
    let bottomIconsName = [
        "icon_home_allshare_report",
        "icon_home_allshare_download",
        "icon_home_allshare_copylink",
        "icon_home_all_share_dislike"]
    let bottomTexts = [
        "举报",
        "保存至相册",
        "复制链接",
        "不感兴趣"]

    var container = UIView.init()
    var cancel = UIButton.init()

    init() {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }


    func initSubView() {
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
        container.frame = CGRect.init(x: 0, y: APPH, width: APPW, height: 280 + safeAreaBottomHeight)
        container.backgroundColor = UIColor.blackAlpha(0.6)
        self.addSubview(container)

        let rounded = UIBezierPath.init(roundedRect: container.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        container.layer.mask = shape

        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1.0
        container.addSubview(visualEffectView)

        let label = UILabel.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: APPW, height: 35)))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "分享到"
        label.textColor = UIColor.grayx
        label.font = .middle
        container.addSubview(label)

        let itemWidth = 68
        let topScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 35, width: APPW, height: 90))
        topScrollView.contentSize = CGSize.init(width: itemWidth * topIconsName.count, height: 80)
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30)
        container.addSubview(topScrollView)

        for index in 0..<topIconsName.count {
            let item = ShareItem.init(frame: CGRect.init(x: 20 + itemWidth * index, y: 0, width: 48, height: 90))
            item.icon.image = UIImage.init(named: topIconsName[index])
            item.label.text = topTexts[index]
            item.tag = index
            item.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onShareItemTap(sender:))))
            item.startAnimation(delayTime: TimeInterval(Double(index) * 0.03))
            topScrollView.addSubview(item)
        }

        let bottomScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 135, width: APPW, height: 90))
        bottomScrollView.contentSize = CGSize.init(width: itemWidth * bottomIconsName.count, height: 80)
        bottomScrollView.showsHorizontalScrollIndicator = false
        bottomScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30)
        container.addSubview(bottomScrollView)

        for index in 0..<bottomIconsName.count {
            let item = ShareItem.init(frame: CGRect.init(x: 20 + itemWidth * index, y: 0, width: 48, height: 90))
            item.icon.image = UIImage.init(named: bottomIconsName[index])
            item.label.text = bottomTexts[index]
            item.tag = index
            item.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onActionItemTap(sender:))))
            item.startAnimation(delayTime: TimeInterval(Double(index) * 0.03))
            bottomScrollView.addSubview(item)
        }

        cancel.frame = CGRect.init(x: 0, y: 230, width: APPW, height: 50 + safeAreaBottomHeight)
        cancel.titleEdgeInsets = UIEdgeInsets(top: -safeAreaBottomHeight, left: 0, bottom: 0, right: 0)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.whitex, for: .normal)
        cancel.titleLabel?.font = .big
        cancel.backgroundColor = UIColor.grayx
        container.addSubview(cancel)

        let rounded2 = UIBezierPath.init(roundedRect: cancel.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let shape2 = CAShapeLayer.init()
        shape2.path = rounded2.cgPath
        cancel.layer.mask = shape2
        cancel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGuesture(sender:))))
    }

    @objc func onShareItemTap(sender:UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            break
        default:
            break
        }
        UIApplication.shared.openURL(URL.init(string: "https://github.com/sshiqiao/douyin-ios-swift")!)
        dismiss()
    }

    @objc func onActionItemTap(sender:UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            break
        default:
            break
        }
        dismiss()
    }

    @objc func handleGuesture(sender:UITapGestureRecognizer) {
        var point = sender.location(in: container)
        if !(container.layer.contains(point)) {
            dismiss()
            return
        }
        point = sender.location(in: cancel)
        if cancel.layer.contains(point) {
            dismiss()
        }
    }

    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y - frame.size.height
            self.container.frame = frame
        }) { finshed in
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y + frame.size.height
            self.container.frame = frame
        }) { finshed in
            self.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShareItem:UIView {

    var icon = UIImageView.init()
    var label = UILabel.init()
    init() {
        super.init(frame: .zero)
        initSubView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubView() {
        icon.contentMode = .scaleToFill
        icon.isUserInteractionEnabled = true
        self.addSubview(icon)

        label.text = "TEXT"
        label.textColor = UIColor.whiteAlpha(0.6)
        label.font = .middle
        label.textAlignment = .center
        self.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.icon.snp.bottom).offset(10)
        }
    }

    func startAnimation(delayTime:TimeInterval) {
        let originalFrame = self.frame
        self.frame = CGRect.init(origin: CGPoint.init(x: originalFrame.minX, y: 35), size: originalFrame.size)
        UIView.animate(withDuration: 0.9, delay: delayTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.frame = originalFrame
        }) { finished in
        }
    }
}
