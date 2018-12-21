//
//  WXChatViewController.swift
//  Freedom
import XExtension
import SnapKit
import Foundation
extension UIImagePickerController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.5)]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
class WXMoreKBHelper: NSObject {
    var chatMoreKeyboardData: [TLMoreKeyboardItem] = []
    override init() {
        super.init()
        let imageItem = TLMoreKeyboardItem.create(byType: .image, title: "照片", imagePath: "moreKB_image")
        let cameraItem = TLMoreKeyboardItem.create(byType: .camera, title: "拍摄", imagePath: "moreKB_video")
        let videoItem = TLMoreKeyboardItem.create(byType: .video, title: "小视频", imagePath: "moreKB_sight")
        let videoCallItem = TLMoreKeyboardItem.create(byType: .videoCell, title: "视频聊天", imagePath: "moreKB_video_call")
        let walletItem = TLMoreKeyboardItem.create(byType: .wallet, title: "红包", imagePath: "moreKB_wallet")
        let transferItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypeTransfer, title: "转账", imagePath: "moreKB_pay")
        let positionItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypePosition, title: "位置", imagePath: "moreKB_location")
        let favoriteItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypeFavorite, title: "收藏", imagePath: "moreKB_favorite")
        let businessCardItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypeBusinessCard, title: "个人名片", imagePath: "moreKB_friendcard")
        let voiceItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypeVoice, title: "语音输入", imagePath: "moreKB_voice")
        let cardsItem = TLMoreKeyboardItem.create(byType: TLMoreKeyboardItemTypeCards, title: "卡券", imagePath: "moreKB_wallet")
        chatMoreKeyboardData.append(contentsOf: [imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem])
    }
}
class WXChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = WXChatViewController()
    private var moreKBhelper: WXMoreKBHelper
    private var emojiKBHelper: WXUserHelper
    private var rightBarButton: UIBarButtonItem
    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightBarButton
        user = WXUserHelper.shared().user as WXChatUserProtocol
        moreKBhelper = WXMoreKBHelper()
        setChatMoreKeyboardData(moreKBhelper.chatMoreKeyboardData)
        emojiKBHelper = WXUserHelper.shared()
        emojiKBHelper.emojiGroupDataComplete({ emojiGroups in
            moreKBhelper = WXMoreKBHelper()
            self.chatMoreKeyboardData = moreKBhelper.chatMoreKeyboardData
            emojiKBHelper = WXUserHelper.shared()
            emojiKBHelper.emojiGroupDataComplete({ emojiGroups in
                self.chatEmojiKeyboardData = emojiGroups
            })
        }
    }
    func setPartner(_ partner: WXChatUserProtocol) {
        super.setPartner(partner)
        if partner.chat_userType() == TLChatUserTypeUser {
            rightBarButton.image = UIImage(named: "nav_chat_single")
        } else if partner.chat_userType() == TLChatUserTypeGroup {
            rightBarButton.image = UIImage(named: "nav_chat_multi")
        }
    }
    @objc func rightBarButtonDown(_ sender: UINavigationBar) {
        if partner.chat_user() == TLChatUserTypeUser {
            let chatDetailVC = WXChatDetailViewController()
            chatDetailVC.user = partner as WXUser
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(chatDetailVC, animated: true)
        } else if partner.chat_user() == TLChatUserTypeGroup {
            let chatGroupDetailVC = WXCGroupDetailViewController()
            chatGroupDetailVC.group = partner as WXGroup
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(chatGroupDetailVC, animated: true)
        }
    }
    func rightBarButton() -> UIBarButtonItem {
        if rightBarButton == nil {
            rightBarButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
        }
        return rightBarButton
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            let image = editingInfo[.originalImage] as UIImage
            self.sendImageMessage(image)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as UIImage
            self.sendImageMessage(image)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func moreKeyboard(_ keyboard: Any, didSelectedFunctionItem funcItem: TLMoreKeyboardItem) {
        if funcItem.type == .camera || funcItem.type == .image {
            let imagePickerController = UIImagePickerController()
            if funcItem.type == .camera {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePickerController.sourceType = .camera
                } else {
//                    self.noticeError("相机初始化失败")
                    return
                }
            } else {
                imagePickerController.sourceType = .photoLibrary
            }
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        } else {
//            self.noticeInfo("选中”\(funcItem.title)“ 按钮")
        }
    }
    func emojiKeyboardEmojiEditButtonDown() {
        let expressionVC = WXExpressionViewController()
        let navC = WXNavigationController(rootViewController: expressionVC)
        present(navC, animated: true)
    }

    func emojiKeyboardMyEmojiEditButtonDown() {
        let myExpressionVC = WXMyExpressionViewController()
        let navC = WXNavigationController(rootViewController: myExpressionVC)
        present(navC, animated: true)
    }
    func didClickedUserAvatar(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController()
        detailVC.user = user
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
    func didClickedImageMessages(_ imageMessages: [WXMessage], at index: Int) {
        var data: [MWPhoto] = []
        for message: WXMessage in imageMessages {
            var url: URL
            let imagePath = message.content["path"]
            if imagePath != nil {
                let imagePatha = FileManager.pathUserChatImage(imagePath)
                url = URL(fileURLWithPath: imagePatha)
            } else {
                url = URL(string: message.content["url"])
            }
            let photo = MWPhoto(url: url)
            data.append(photo)
        }
        let browser = MWPhotoBrowser(photos: data)
        browser.displayNavArrows = true
        browser.currentPhotoIndex = index
        let broserNavC = WXNavigationController(rootViewController: browser)
        present(broserNavC, animated: false)
    }
}
