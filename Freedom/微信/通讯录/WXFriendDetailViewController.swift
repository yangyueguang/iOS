//
//  WXFriendDetailViewController.swift
//  Freedom
import MWPhotoBrowser
import Foundation

class WXFriendDetailViewController: BaseTableViewController {
    var data:[[WXInfo]] = []
    var user: WXUser = WXUser() {
        didSet {
            let array = WXFriendHelper.shared.friendDetailArray(byUserInfo: self.user)
            data = array
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:Image.more.image, style: .plain, action: {[weak self] in
            let detailSetiingVC = WechatFriendDetailSettingViewController()
                detailSetiingVC.user = self!.user
            self?.navigationController?.pushViewController(detailSetiingVC, animated: true)
        })

    }
    @IBAction func sendMessage(_ sender: Any) {

            let chatVC = WXChatViewController.shared
            var wxChatVC: WXChatViewController?
            navigationController?.children.forEach(where: { (vc) -> Bool in
                return NSStringFromClass(object_getClass(vc) ?? NSObject.self) == "WXChatViewController"
            }, body: { (vc) in
                wxChatVC = vc as? WXChatViewController
            })
            if let cvc = wxChatVC {
                if (chatVC.partner?.userID == user.userID) {
                    navigationController?.popToViewController(cvc, animated: true)
                } else {
                    chatVC.partner = user
                    let navController = navigationController
                    navigationController?.popToRootViewController(animated: true)
                    navController?.pushViewController(chatVC, animated: true)
                }
            } else {
                chatVC.partner = user
                let vc: UIViewController = WXTabBarController.shared.children[0]
                WXTabBarController.shared.selectedIndex = 0
                vc.navigationController?.pushViewController(chatVC, animated: true)
                navigationController?.popViewController(animated: false)
            }
        
    }
    
    @IBAction func sendAudioVideoAction(_ sender: Any) {
    }
    

    @IBAction func touchLogoAction(_ sender: Any) {
        var url: URL?
        if !user.avatarPath.isEmpty {
            let imagePath = FileManager.pathUserAvatar(user.avatarPath)
            url = URL(fileURLWithPath: imagePath)
        } else {
            url = URL(string: user.avatarURL)
        }
        let photo = MWPhoto(url: url)
        let browser = MWPhotoBrowser(photos: [photo!])
        let broserNavC = WXNavigationController(rootViewController: browser!)
        present(broserNavC, animated: false)
    }
}
