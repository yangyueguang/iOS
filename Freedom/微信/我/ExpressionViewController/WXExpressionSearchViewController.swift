//
//  WXExpressionSearchViewController.swift
//  Freedom
import SnapKit
import XCarryOn
import XExtension
import Foundation
class WXExpressionSearchViewController: WXTableViewController, UISearchResultsUpdating, UISearchBarDelegate, WXExpressionCellDelegate {
    var proxy = WXExpressionHelper.shared
    var data: [TLEmojiGroup] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.register(WXExpressionCell.self, forCellReuseIdentifier: "TLExpressionCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = CGRect(x: 0, y: TopHeight + 20, width: APPW, height: APPH - 20 - TopHeight)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLExpressionCell") as! WXExpressionCell
        let group: TLEmojiGroup = data[indexPath.row]
        cell.group = group
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = data[indexPath.row]
        let detailVC = WXExpressionDetailViewController()
        detailVC.group = group
        let navC = WXNavigationController(rootViewController: detailVC)
        let closeButton = UIBarButtonItem(title: "关闭") {
            navC.dismiss(animated: true) {
            }
        }
        detailVC.navigationItem.leftBarButtonItem = closeButton
        present(navC, animated: true) {
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup) {
        group.status = .downloading
        proxy.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            group.data = data
            WXExpressionHelper.shared.downloadExpressions(withGroupInfo: group, progress: { progress in
            }, success: { group in
                group.status = .downloaded
                var index = self.data.index(of: group) ?? -1
                if index < self.data.count {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                WXExpressionHelper.shared.addExpressionGroup(group)
            }, failure: { group, error in

            })
        }, failure: { error in
            self.noticeError("\"\(group.groupName)\" 下载失败: \(error)")
        })
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text ?? ""
        if keyword.count > 0 {
            XHud.show()
            proxy.requestExpressionSearch(byKeyword: keyword, success: { data in
                self.data = data
                self.tableView.reloadData()
                XHud.hide()
            }, failure: { error in
                self.data = []
                self.tableView.reloadData()
                self.noticeError(error)
            })
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
    }
}
