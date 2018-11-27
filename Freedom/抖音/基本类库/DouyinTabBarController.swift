//
//  DouyinTabBarController.swift
//  Freedom
//
//  Created by Chao Xue 薛超 on 2018/11/26.
//  Copyright © 2018 薛超. All rights reserved.
//

import UIKit
import CoreTelephony
import Photos
class DouyinTabBarController: XBaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AVPlayerManager.setAudioMode()
        NetworkManager.startMonitoring()
        WebSocketManger.shared().connect()
        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
            //process photo library request status.
        }

        VisitorRequest.saveOrFindVisitor(success: { data in
            let response = data as! VisitorResponse
            let visitor = response.data
            Visitor.write(visitor:visitor!)
        }, failure: { error in
            print("注册访客用户失败")
        })

    }

}
