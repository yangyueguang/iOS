//
//  WXDiscoverViewController.swift
//  Freedom
import SnapKit
//import XExtension
import Foundation
final class WXDiscoverViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetVC: UIViewController?
        switch indexPath.section {
        case 0:break
        case 1:
            switch indexPath.row {
            case 0:targetVC = WXScanningViewController()
            default:targetVC = WXShakeViewController()
            }
        case 2:break
        case 3:
            switch indexPath.row {
            case 0:break
            default:targetVC = WXBottleViewController()
            }
        case 4:
            switch indexPath.row {
            case 0:targetVC = WXShoppingViewController()
            default:targetVC = WXGameViewController()
            }
        default:break;
        }
        guard let target = targetVC else { return }
        navigationController?.pushViewController(target, animated: true)
    }
}
