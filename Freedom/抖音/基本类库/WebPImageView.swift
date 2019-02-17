//
//  WebPImageView.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/3.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit
class WebPImageView: UIImageView {
    
    var displayLink: CADisplayLink?       //CADisplayLink用于更新画面
    var requestQueue = OperationQueue.init()     //用于解码剩余图片的NSOperationQueue
    var firstFrameQueue = OperationQueue.init()  //用于专门解码WebP第一帧画面的NSOperationQueue
    var time: TimeInterval  = 0           //用于记录每帧时间间隔
    var operationCount: Int = 0           //当前添加进队列的NSOperation数量
    
    //重写image的setter、getter方法
    private var _image: WebPImage?
    override var image: UIImage? {
        set {
            super.image = newValue
            _image = newValue as? WebPImage
            
            displayLink?.isPaused = true
            WebPQueueManager.shared().cancelQueue(queue: requestQueue)
            firstFrameQueue.cancelAllOperations()
            
            time = 0
            operationCount = 0
            displayLink?.isPaused = false

            decodeFrames()
        }
        get {
            return _image
        }
    }
    
    init() {
        super.init(frame:.zero)
        self.backgroundColor = UIColor.clear
        displayLink = CADisplayLink.init(target: self, selector: #selector(startAnimation(link:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayLink?.isPaused = true
        
        requestQueue.maxConcurrentOperationCount = 1
        requestQueue.qualityOfService = .utility
        
        firstFrameQueue.maxConcurrentOperationCount = 1
        firstFrameQueue.qualityOfService = .userInteractive
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        displayLink = CADisplayLink.init(target: self, selector: #selector(startAnimation(link:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayLink?.isPaused = true
        
        requestQueue.maxConcurrentOperationCount = 1
        requestQueue.qualityOfService = .utility
        
        firstFrameQueue.maxConcurrentOperationCount = 1
        firstFrameQueue.qualityOfService = .userInteractive
    }
    
    //重写initWithImage方法
    override init(image: UIImage?) {
        super.init(image: image)
        self.image = image
        self.backgroundColor = UIColor.clear
        displayLink = CADisplayLink.init(target: self, selector: #selector(startAnimation(link:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayLink?.isPaused = true
        
        requestQueue.maxConcurrentOperationCount = 1
        requestQueue.qualityOfService = .utility
        
        firstFrameQueue.maxConcurrentOperationCount = 1
        firstFrameQueue.qualityOfService = .userInteractive
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //解码WebP格式动图
    func decodeFrames() {
        //在_firstFrameQueue中添加解码第一帧的任务
        let operation = WebPImageOperation.init(image: (image as? WebPImage) ?? WebPImage.init()) {[weak self] frame in
            DispatchQueue.main.async {
                self?.layer.contents = frame?.image.cgImage ?? nil
            }
        }
        operationCount += 1
        firstFrameQueue.addOperation(operation)
        
        while (operationCount < (image as? WebPImage)?.frameCount ?? 0) {
            let operation = WebPImageOperation.init(image: (image as? WebPImage) ?? WebPImage.init()) {[weak self] frame in
                DispatchQueue.main.async {
                    self?.layer.setNeedsDisplay()
                }
            }
            operationCount += 1
            requestQueue.addOperation(operation)
        }
        WebPQueueManager.shared().addQueue(queue: requestQueue)
    }
    
    //CADisplayLink指定回调的方法
    @objc func startAnimation(link:CADisplayLink) {
        if (image as? WebPImage)?.isAllFrameDecoded() ?? false {
            self.layer.setNeedsDisplay()
        }
    }
    
    override func display(_ layer: CALayer) {
        if(time == 0) {
            self.layer.contents = (image as? WebPImage)?.curDisplayFrame?.image.cgImage ?? nil
            (image as? WebPImage)?.incrementCurDisplayIndex()
        }
        
        time += displayLink?.duration ?? 0
        if time >= Double((image as? WebPImage)?.curDisplayFrameDuration() ?? 0) {
            time = 0
        }
    }
}

//
//  WebPImageOperation.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/3.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
//
//  WebPQueueManager.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/3.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation

class WebPQueueManager: NSObject {

    let maxQueueCount:Int = 3
    var requestQueueArray = [OperationQueue]()

    private static let instance = { () -> WebPQueueManager in
        return WebPQueueManager.init()
    }()

    private override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func shared() -> WebPQueueManager {
        return instance
    }


    //添加NSOperationQueue队列
    func addQueue(queue: OperationQueue) {
        objc_sync_enter(requestQueueArray)
        if(requestQueueArray.contains(queue)) {
            let index = requestQueueArray.index(of: queue) ?? 0
            requestQueueArray[index] = queue
        }else {
            requestQueueArray.append(queue)
            queue.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions.new, context: nil)
        }
        processQueues()
        objc_sync_exit(requestQueueArray)
    }

    //取消指定NSOperationQueue队列
    func cancelQueue(queue: OperationQueue) {
        objc_sync_enter(requestQueueArray)
        if(requestQueueArray.contains(queue)) {
            queue.cancelAllOperations()
        }
        objc_sync_exit(requestQueueArray)
    }

    //刮起NSOperationQueue队列
    func suspendQueue(queue: OperationQueue, suspended:Bool) {
        objc_sync_enter(requestQueueArray)
        if(requestQueueArray.contains(queue)) {
            queue.isSuspended = suspended
        }
        objc_sync_exit(requestQueueArray)
    }

    //对当前并发的所有队列进行处理，保证正在执行的队列数量不超过最大执行的队列数
    func processQueues() {
        for (index, queue) in requestQueueArray.enumerated() {
            if(index < maxQueueCount) {
                suspendQueue(queue: queue, suspended: false)
            }else {
                suspendQueue(queue: queue, suspended: true)
            }
        }
    }

    //移除任务已经完成的队列，并更新当前正在执行的队列
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "operations") {
            let queue = object as! OperationQueue
            if(queue.operations.count == 0) {
                if let index = requestQueueArray.index(of: queue) {
                    requestQueueArray.remove(at: index)
                    processQueues()
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    deinit {
        for queue in requestQueueArray {
            queue.removeObserver(self, forKeyPath: "operations")
        }
    }

}

//解码完后的回调用的block
typealias WebPCompletedBlock = (_ frame:WebPFrame?) -> Void

//专门用于解码WebP画面的NSOperation子类
class WebPImageOperation: Operation {
    var completedBlock:WebPCompletedBlock?
    var image:WebPImage?

    var _executing:Bool = false  //指定_executing用于记录任务是否执行
    var _finished:Bool = false   //指定_finished用于记录任务是否完成

    //初始化数据
    init(image:WebPImage, completed:@escaping WebPCompletedBlock) {
        super.init()
        self.image = image
        self.completedBlock = completed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start() {

        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")

        //判断任务执行前是否取消了任务
        if(self.isCancelled) {
            done()
            return
        }

        //解码WebP当前索引对应的帧画面
        let frame = image?.decodeCurFrame()

        //由于上一步是耗时步骤，在真机上测试的时间为0.05-0.1s之间，所以在结束任务前再判断一次任务执行前是否取消了任务
        if(self.isCancelled) {
            done()
            return
        }
        completedBlock?(frame)
        done()
    }

    //重写isExecuting方法
    override var isExecuting: Bool {
        return _executing
    }

    //重写isFinished方法
    override var isFinished: Bool {
        return _finished
    }

    //重写isAsynchronous方法
    override var isAsynchronous: Bool {
        return true
    }

    //取消任务
    override func cancel() {
        objc_sync_enter(self)
        done()
        objc_sync_exit(self)
    }

    //更新任务状态
    func done() {
        super.cancel()
        if(_executing) {
            willChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
            _finished = true
            _executing = false
            didChangeValue(forKey: "isFinished")
            didChangeValue(forKey: "isExecuting")
        }
    }

}
