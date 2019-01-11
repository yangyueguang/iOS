//
//  WXBgSettingViewController.swift
//  Freedom
import SnapKit
import Foundation
import XExtension
class WXChatBackgroundSelectViewController: WXBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var data: [AnyHashable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "选择背景图"
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: (APPW - 10 * 2) / 3 * 0.98, height: (APPW - 10 * 2) / 3 * 0.98)
        layout.minimumInteritemSpacing = (APPW - 10 * 2 - (APPW - 10 * 2) / 3 * 0.98 * 3) / 2
        layout.minimumLineSpacing = (APPW - 10 * 2 - (APPW - 10 * 2) / 3 * 0.98 * 3) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(46.0, 49.0, 50.0, 1.0)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TLChatBackgroundSelectCell")
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "聊天背景"
        data = WXCommonSettingHelper.chatBackgroundSettingData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if data.count > 0 {
            return partnerID.count > 0 ? data.count - 1 : data.count
        }
        return 0
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            self.p_setChatBackgroundImage(image)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as! UIImage
            self.p_setChatBackgroundImage(image)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[UInt(indexPath.row)]
        if (item.title == "选择背景图") {
            let bgSelectVC = WXChatBackgroundSelectViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(bgSelectVC, animated: true)
        } else if (item.title == "从手机相册中选择") {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        } else if (item.title == "拍一张") {
            let imagePickerController = UIImagePickerController()
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                noticeError("相机初始化失败")
            } else {
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                present(imagePickerController, animated: true)
            }
        } else if (item.title == "将背景应用到所有聊天场景") {
            let alert = UIAlertController("", "", T1: "将背景应用到所有聊天场景", T2: "取消", confirm1: {
                for key: String in UserDefaults.standard.dictionaryRepresentation().keys {
                    if key.hasPrefix("CHAT_BG_") && !(key == "CHAT_BG_ALL") {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                }
                WXChatViewController.shared.resetChatVC()
            }, confirm2: {

            })
            self.present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func p_setChatBackgroundImage(_ image: UIImage) {
        var imageData: Data?
        imageData = image.pngData() != nil ? image.pngData() : image.jpegData(compressionQuality: 1)
        let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
        let imagePath = FileManager.pathUserChatBackgroundImage(imageName)
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
        if partnerID.count > 0 {
            UserDefaults.standard.set(imageName, forKey: "CHAT_BG_" + (partnerID))
        } else {
            UserDefaults.standard.set(imageName, forKey: "CHAT_BG_ALL")
        }
        WXChatViewController.shared.resetChatVC()
    }
}
