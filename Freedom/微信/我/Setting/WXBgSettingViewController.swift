//
//  WXBgSettingViewController.swift
//  Freedom

import Foundation

class WXChatBackgroundSelectViewController: WXBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func registerCell(for collectionView: UICollectionView) {
    }

    var data: [AnyHashable] = []
    var collectionView: UICollectionView

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "选择背景图"
        collectionView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        if let aView = collectionView {
            view.addSubview(aView)
        }

        p_addMasonry()
    }
    var collectionView: UICollectionView! {
        if collectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.sectionHeadersPinToVisibleBounds = true
            layout.itemSize = CGSize(width: (APPW - 10 * 2) / 3 * 0.98, height: (APPW - 10 * 2) / 3 * 0.98)
            layout.minimumInteritemSpacing = (APPW - 10 * 2 - (APPW - 10 * 2) / 3 * 0.98 * 3) / 2
            layout.minimumLineSpacing = (APPW - 10 * 2 - (APPW - 10 * 2) / 3 * 0.98 * 3) / 2
            layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false

            collectionView.alwaysBounceVertical = true
        }
        return collectionView
    }
    func p_addMasonry() {
        collectionView.mas_makeConstraints({ make in
            make.edges.mas_equalTo(self.view)
        })
    }

    // MARK: -
    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TLChatBackgroundSelectCell")
    }

    // MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TLChatBackgroundSelectCell", for: indexPath)
        return cell
    }




}
class WXBgSettingViewController: WXSettingViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //若为nil则全局设置，否则只给对应好友设置
    var partnerID = ""

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天背景"

        data = WXCommonSettingHelper.chatBackgroundSettingData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if data.count > 0 {
            return partnerID.length > 0  data.count - 1 : data.count
        }
        return 0
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            let image = editingInfo[.originalImage] as UIImage
            self.p_setChatBackgroundImage(image)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as UIImage
            self.p_setChatBackgroundImage(image)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXSettingItem
        if (item.title == "选择背景图") {
            let bgSelectVC = WXChatBackgroundSelectViewController()
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(bgSelectVC, animated: true)
        } else if (item.title == "从手机相册中选择") {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        } else if (item.title == "拍一张") {
            let imagePickerController = UIImagePickerController()
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                SVProgressHUD.showError(withStatus: "相机初始化失败")
            } else {
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                present(imagePickerController, animated: true)
            }
        } else if (item.title == "将背景应用到所有聊天场景") {
            showAlerWithtitle(nil, message: nil, style: UIAlertController.Style.actionSheet, ac1: {
                return UIAlertAction(title: "将背景应用到所有聊天场景", style: .default, handler: { action in
                    for key: String in UserDefaults.standard.dictionaryRepresentation().keys {
                        if key.hasPrefix("CHAT_BG_")  false && !(key == "CHAT_BG_ALL") {
                            UserDefaults.standard.removeObject(forKey: key)
                        }
                    }
                    WXChatViewController.sharedChatVC().resetChatVC()
                })
            }, ac2: {
                return UIAlertAction(title: "取消", style: .cancel, handler: { action in

                })
            }, ac3: nil, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }


    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func p_setChatBackgroundImage(_ image: UIImage) {

        var imageData: Data = nil
        if let anImage = image {
            imageData = UIImagePNGRepresentation(image)  UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 1)
        }
        let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
        let imagePath = FileManager.pathUserChatBackgroundImage(imageName)
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        if partnerID.length > 0 {
            UserDefaults.standard.set(imageName, forKey: "CHAT_BG_" + (partnerID))
        } else {
            UserDefaults.standard.set(imageName, forKey: "CHAT_BG_ALL")
        }

        WXChatViewController.sharedChatVC().resetChatVC()
    }




    
}
