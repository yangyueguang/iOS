//
//  WXShakeSettingViewController.swift
//  Freedom

import Foundation
class WXShakeHelper: NSObject {
    var shakeSettingData: [WXSettingGroup] = []
    override init() {
        super.init()
        let item1 = WXSettingItem("使用默认背景图片")
        item1.showDisclosureIndicator = false
        let item2 = WXSettingItem("换张背景图片")
        let item3 = WXSettingItem("音效")
        item3.type = .switchBtn
        let group1: WXSettingGroup = WXSettingGroup(nil, nil, ([item1, item2, item3]))
        let item5 = WXSettingItem("打招呼的人")
        let item6 = WXSettingItem("摇到的历史")
        let group2: WXSettingGroup = WXSettingGroup(nil, nil, ([item5, item6]))
        let item7 = WXSettingItem("摇一摇消息")
        let group3: WXSettingGroup = WXSettingGroup(nil, nil, ([item7]))
        shakeSettingData.append(contentsOf: [group1, group2, group3])
    }
}
class WXShakeSettingViewController: WXSettingViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private var helper = WXShakeHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "摇一摇设置"
        data = helper.shakeSettingData
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            let imageData = image.pngData() != nil ? image.pngData() : image.jpegData(compressionQuality: 1)
            let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
            let imagePath = FileManager.pathUserSettingImage(imageName) ?? ""
            FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
            UserDefaults.standard.set(imageName, forKey: "Shake_Image_Path")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imageData = image.pngData() != nil ? image.pngData() : image.jpegData(compressionQuality: 1)
            let imageName = String(format: "%lf.jpg", Date().timeIntervalSince1970)
            let imagePath = FileManager.pathUserSettingImage(imageName)
        FileManager.default.createFile(atPath: imagePath ?? "", contents: imageData, attributes: nil)
            UserDefaults.standard.set(imageName, forKey: "Shake_Image_Path")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section].items[indexPath.row] 
        if (item.title == "使用默认背景图片") {
            UserDefaults.standard.removeObject(forKey: "Shake_Image_Path")
            noticeInfo("已恢复默认背景图")
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
