//
//  WXShakeSettingViewController.swift
//  Freedom

import Foundation
class WXShakeHelper: NSObject {
    var shakeSettingData: [AnyHashable] = []

    override init() {
        super.init()

        shakeSettingData = [AnyHashable]()
        p_initTestData()

    }

    func p_initTestData() {
        let item1 = WXSettingItem.createItem(withTitle: ("使用默认背景图片"))
        item1.showDisclosureIndicator = false
        let item2 = WXSettingItem.createItem(withTitle: ("换张背景图片"))
        let item3 = WXSettingItem.createItem(withTitle: ("音效"))
        item3.type = TLSettingItemTypeSwitch
        let group1: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item1, item2, item3]))

        let item5 = WXSettingItem.createItem(withTitle: ("打招呼的人"))
        let item6 = WXSettingItem.createItem(withTitle: ("摇到的历史"))
        let group2: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item5, item6]))
        var item7 = WXSettingItem.createItem(withTitle: ("摇一摇消息"))
        var group3: WXSettingGroup = TLCreateSettingGroup(nil, nil, ([item7]))

        shakeSettingData.append(contentsOf: [group1, group2, group3])
    }
}
class WXShakeSettingViewController: WXSettingViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private var helper: WXShakeHelper

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "摇一摇设置"

        helper = WXShakeHelper()
        data = helper.shakeSettingData
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        var image = image
        picker.dismiss(animated: true) {
            var image = editingInfo[.editedImage] as UIImage
            if image == nil {
                image = editingInfo[.originalImage] as UIImage
            }
            var imageData: Data = nil
            if let anImage = image {
                imageData = UIImagePNGRepresentation(image)  UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 1)
            }
            let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
            let imagePath = FileManager.pathUserSettingImage(imageName)
            FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
            UserDefaults.standard.set(imageName, forKey: "Shake_Image_Path")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            var image = info[.editedImage] as UIImage
            if image == nil {
                image = info[.originalImage] as UIImage
            }
            var imageData: Data = nil
            if let anImage = image {
                imageData = UIImagePNGRepresentation(image)  UIImagePNGRepresentation(image) : anImage.jpegData(compressionQuality: 1)
            }
            let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
            let imagePath = FileManager.pathUserSettingImage(imageName)
            FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
            UserDefaults.standard.set(imageName, forKey: "Shake_Image_Path")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row] as WXSettingItem
        if (item.title == "使用默认背景图片") {
            UserDefaults.standard.removeObject(forKey: "Shake_Image_Path")
            SVProgressHUD.showInfo(withStatus: "已恢复默认背景图")
        } else if (item.title == "换张背景图片") {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true)
            imagePickerController.delegate = self
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }


}
