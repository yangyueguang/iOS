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
import RxSwift
final class DouyinTabBarController: BaseTabBarViewController {
    let viewModel = PublishSubject<Visitor>()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        AVPlayerManager.setAudioMode()
        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in
            
        }
        viewModel.subscribe(onNext: { (visitor) in
            Visitor.write(visitor:visitor)
        }).disposed(by: disposeBag)
        XNetKit.douyinVisitor("", next: viewModel)

    }

}
