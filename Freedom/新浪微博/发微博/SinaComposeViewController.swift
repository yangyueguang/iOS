//
//  SinaComposeViewController.swift
//  Freedom
//
//  Created by Super on 6/28/18.
//  Copyright © 2018 薛超. All rights reserved.
import UIKit
import SVProgressHUD
import AFNetworking
class SinaComposeViewController: SinaBaseViewController,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var textView: SinaEmotionTextView = SinaEmotionTextView()/** 输入控件 */
    var toolbar: SinaComposeToolbar = SinaComposeToolbar(frame: CGRect.zero)/** 键盘顶部的工具条 */
    var photoView: SinaComposePhotosView = SinaComposePhotosView()/** 相册（存放拍照或者相册中选择的图片） */
    var emotionKeyboard: SinaEmotionKeyboard = SinaEmotionKeyboard(frame: CGRect.zero)/** 表情键盘 */
    var switchingKeybaord = false/** 是否正在切换键盘 */
    override func viewDidLoad() {
        super.viewDidLoad()
        emotionKeyboard.frame = CGRect(x: emotionKeyboard.frame.origin.x, y: emotionKeyboard.frame.origin.y, width: view.frame.size.width, height: 256)
        view.backgroundColor = UIColor.white
        //设置导航栏内容
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(self.send))
        let acount = SinaAccount.account()
        let prefix = "发微博"
        if  let ac = acount {
            let titleView = UILabel()
            titleView.numberOfLines = 0
            titleView.textAlignment = .center
            titleView.frame = CGRect(x: titleView.frame.origin.x, y: 50, width: 200, height: 100)
            let str = "\(prefix)\n\(ac.name)"
            // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
            let attStr = NSMutableAttributedString(string: str)
            attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: (str as NSString).range(of: prefix))
            attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: (str as NSString).range(of: ac.name))
            titleView.attributedText = attStr
            navigationItem.titleView = titleView
        } else {
            title = prefix
        }
        //设置输入框
        textView.placeholder = "分享新鲜事..."
        // 垂直方向上永远可以拖拽（有弹簧效果）
        textView.alwaysBounceVertical = true
        textView.frame = view.bounds
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.setNeedsDisplay()
        view.addSubview(textView)
        textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.emotionDidSelect(_:)), name: NSNotification.Name("EmotionDidSelectNotification"), object: nil)
        toolbar.frame = CGRect(x: 0, y: view.frameHeight - toolbar.frameHeight, width: view.frame.size.width, height: 44)
        toolbar.didClickBlock = { buttonType in
            switch buttonType {
            case 0:self.openImagePickerController(.camera)
            case 1:self.openImagePickerController(.photoLibrary)
            case 2:break
            case 3:break
            case 4:self.switchkeyBoard()
            default:break
            }
        }
        view.addSubview(toolbar)
        //添加图片
        photoView.frame = CGRect(x: photoView.frame.origin.x, y: 130, width: view.frame.size.width, height: 400)
        textView.addSubview(photoView)
        textView.becomeFirstResponder()
    }
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func emotionDidSelect(_ notification: Notification?) {
        let emotion = notification?.userInfo!["SelectEmotionKey"] as? SinaEmotion
        textView.insert(emotion!)
    }
    func keyboardWillChangeFrame(_ notification: Notification) {
        if switchingKeybaord {
            return
        }
        let keyboardF : CGRect = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue)!
        let duration  = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: TimeInterval(duration!), animations: {
            if keyboardF.origin.y > self.view.frameHeight {
                // 键盘的Y值已经远远超过了控制器view的高度
                self.toolbar.frameY = self.view.frameHeight - self.toolbar.frameHeight
            } else {
                self.toolbar.frameY = keyboardF.origin.y - self.toolbar.frameHeight
            }
        })
    }
    //切换键盘
    func switchkeyBoard() {
        var image = "compose_emoticonbutton_background"
        var highImage = "emoticonkeyboardbutton"
        if textView.inputView == nil {
            textView.inputView = emotionKeyboard
            // 显示键盘按钮
            toolbar.showKeyboardButton = true
            image = "compose_keyboardbutton_background"
            highImage = "emoticonkeyboardbutton_sd"
        } else {
            textView.inputView = nil
            // 显示表情按钮
            toolbar.showKeyboardButton = false
        }
        // 设置图片
        toolbar.emotionButton?.setImage(UIImage(named: image), for: .normal)
        toolbar.emotionButton?.setImage(UIImage(named: highImage), for: .highlighted)
        // 开始切换键盘
        switchingKeybaord = true
        // 退出键盘
        textView.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            //弹出键盘
            self.textView.becomeFirstResponder()
            // 结束切换键盘
            self.switchingKeybaord = false
        })
    }
    func openImagePickerController(_ type: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        present(picker, animated: true)
    }
    /**从选择完图片后就调用（拍照完毕或者选择相册图片完毕）*/
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        let photoView = UIImageView()
        photoView.image = image
        self.photoView.addSubview(photoView)
        if let anImage = image {
            self.photoView.photos.append(anImage)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func cancel() {
        dismiss(animated: true)
    }
    // MARK: - UITextViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    /** 发布带有图片的微博*/
    func sendWithImage() {
        var params = [AnyHashable: Any]()
        params["access_token"] = SinaAccount().access_token
        params["status"] = textView.fullText
        // 3.发送请求
        AFHTTPSessionManager().post("https://upload.api.weibo.com/2/statuses/upload.json", parameters: params, constructingBodyWith: { formData in// 拼接文件数据
            let image = self.photoView.photos.first
            let imageData = image!.pngData()
            formData.appendPart(withFileData: imageData!, name: "pic", fileName: "test.jpg", mimeType: "image/jpeg")
        }, progress: { uploadProgress in
        }, success: { task, responseObject in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        }, failure: { task, error in
            SVProgressHUD.showError(withStatus: "发送失败")
        })
    }
    /*发布没有图片的微博*/
    func sendWithNoImage() {
        var params = [AnyHashable: Any]()
        params["access_token"] = SinaAccount().access_token
        params["status"] = textView.fullText
        AFHTTPSessionManager().post("https://api.weibo.com/2/statuses/update.json", parameters: params, progress: nil, success: { task, responseObject in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        }, failure: { task, error in
            SVProgressHUD.showError(withStatus: "发送失败")
        })
    }
    //发微博
    func send() {
        if photoView.photos.count > 0 {
            sendWithImage()
        } else {
            sendWithNoImage()
        }
        dismiss(animated: true)
    }
}
