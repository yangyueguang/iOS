//
//  WXMineViewController.swift
//  Freedom
import SnapKit
//import XExtension
import Foundation
final class WXMineViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetVC: UIViewController?
        switch indexPath.section {
        case 0:break
        case 1:break
        case 2:
            switch indexPath.row {
            case 0:break
            case 1:break
            case 2:break
            default:targetVC = WXExpressionViewController()
            }
        default:targetVC = WXMineSettingViewController()
        }
        guard let vc = targetVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
