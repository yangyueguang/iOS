//
//  WXMineInfoViewController.swift
//  Freedom
import SnapKit
import Foundation
//import XExtension
class WXMineInfoViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myQRCodeVC = WXMyQRCodeViewController()
        navigationController?.pushViewController(myQRCodeVC, animated: true)
    }
}
