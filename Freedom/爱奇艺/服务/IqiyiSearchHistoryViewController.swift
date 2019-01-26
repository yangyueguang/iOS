//
//  JFSearchHistoryViewController.swift
//  Freedom
import UIKit
import XExtension
class IqiyiSearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = "大家都在搜琅琊榜"
        font = UIFont.systemFont(ofSize: 16)
        let image = UIImage(named: "GroupCell")
        background = image?.stretchableImage(withLeftCapWidth: Int((image?.size.width ?? 0.0) * 0.5), topCapHeight: Int((image?.size.height ?? 0.0) * 0.5))
        clearButtonMode = .always
        layer.masksToBounds = true
        layer.cornerRadius = 5
        //设置文边框左边专属View
        let leftView = UIImageView()
        leftView.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
        //        leftView.contentMode = UIViewContentModeCenter;
        leftView.image = UIImage(named: "search_small")
        self.leftView = leftView
        leftViewMode = .always
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class IqiyiSearchHotCell:BaseTableViewCell{
    func setArray(_ array: [Any]?) {
        let buttons: Int? = array?.count
        let margin: CGFloat = 10
        let buttonW = (APPW - CGFloat(((buttons ?? 0) + 1)) * margin) / CGFloat(buttons ?? Int(0.0))
        for i in 0..<(array?.count ?? 0) {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: margin + CGFloat(i) * (buttonW + margin), y: 5, width: buttonW, height: 40)
            let buttontitle = array![i] as? String
            button.setTitle(buttontitle, for: .normal)
            addSubview(button)
        }
    }
}
class IqiyiSearchHistoryCell: UITableViewCell {
    var searchHistoryLabel: UILabel!
    /** 底部的线 */
    var bottomLineView: UIView!
    /** 记录自己是哪个数据 */
    var indexPath: IndexPath?
    /** 记录模型数据 */
    var hisDatas: [AnyHashable]?
    /** 记录tableView */
    weak var tableView: UITableView?
    func cancelSearchBtnClick(_ sender: Any) {
//        hisDatas.remove(at: indexPath.row)
//        hisDatas.write(toFile: "JFSearchHistoryPath", atomically: true)
//        tableView.deleteRows(at: [indexPath], with: .left)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {() -> Void in
            self.tableView?.reloadData()
        })
    }
}
class IqiyisearchHeaderView: UITableViewHeaderFooterView {
    var titleLabel: UILabel!
    class func headView(with tableView: UITableView?) -> IqiyisearchHeaderView {
        let ID = "JFsearchHeaderView"
        var headView = tableView?.dequeueReusableHeaderFooterView(withIdentifier: ID) as? IqiyisearchHeaderView
        if headView == nil {
            // 从xib中加载cell
            headView = IqiyisearchHeaderView(frame: CGRect(x: 0, y: 0, width: APPW, height: 40))
            headView?.titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 20))
            headView?.titleLabel.text = "label"
            if let aLabel = headView?.titleLabel {
                headView?.addSubview(aLabel)
            }
            //        headView = [[[NSBundle mainBundle] loadNibNamed:@"JFsearchHeaderView" owner:nil options:nil] lastObject];
        }
        headView?.backgroundColor = UIColor(200, 199, 204,1)
        return headView!
    }
}
class IqiyiSearchHistoryViewController: IqiyiBaseViewController,UITextFieldDelegate {
    var searchTableView: UITableView?
    /** 搜索文本框 */
    weak var searchTF: IqiyiSearchTextField?
    /** 搜索的tableView */
    /** 搜索的数据 */
    var datas = [AnyHashable]()
    /** 历史搜索数据 */
    var hisDatas = [AnyHashable]()
    /** 热门数据模型 */
    var hotDatas = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        hisDatas = ["优衣库"]
        hotDatas = ["琅琊榜", "奔跑吧兄弟"]
        datas = [AnyHashable]()
        datas.append(hisDatas as AnyHashable)
        //用push方法推出时，Tabbar隐藏
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        searchTableView = tableView
        searchTableView?.separatorStyle = .none
        view.addSubview(searchTableView!)
        let search = IqiyiSearchTextField(frame: CGRect.zero)
        let w: CGFloat = APPW * 0.7
        search.frame = CGRect(x: 0, y: 0, width: w, height: 30)
        search.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: search)
        searchTF = search
        //取消按钮
        let rightItem = UIBarButtonItem(title: "取消", style: .plain) {
            self.backClick()
        }
        navigationItem.rightBarButtonItem = rightItem
    }
    override func viewDidAppear(_ animated: Bool) {
        //文本框获取焦点
        super.viewDidAppear(animated)
        searchTF?.becomeFirstResponder()
    }
    
    func backClick() {
        //    [self.navigationController popToRootViewControllerAnimated:YES];
        navigationController?.popViewController(animated: true)
    }
    
    //监听手机键盘点击搜索的事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //判断是否有输入,有值的话将新的字符串添加到datas[0]中并且重新写入文件，发送网络请求
        /* 发送请求 */
        if (textField.text?.count ?? 0) != 0 {
            hisDatas.insert(textField.text ?? "", at: 0)
//            hisDatas.write(toFile: JFSearchHistoryCell, atomically: true)
            tableView?.reloadData()
            textField.text = ""
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datas.count == 2 {
            if section == 0 {
                return 1//datas[0].count()
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datas.count == 2 && indexPath.section == 0 {
            let identifier = "historyCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? IqiyiSearchHistoryCell
            if cell == nil {
                cell = IqiyiSearchHistoryCell(style: .default, reuseIdentifier: identifier)
                cell?.searchHistoryLabel = cell?.textLabel
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                button.setTitle("取消", for: .normal)
                cell?.accessoryView?.addSubview(button)
                //            button.addTarget(self, action: Selector("cancelSearchBtnClick:"), for: .touchUpInside)
            }
            cell?.tableView = tableView
            cell?.hisDatas = datas
            cell?.indexPath = indexPath
            cell?.searchHistoryLabel.text = "aaa"//datas[0][indexPath.row]
            return cell!
        } else {
            //这里就一个cell 不用注册了
            let ID = "JFSearchHotCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? IqiyiSearchHotCell
            if cell == nil {
                cell = IqiyiSearchHotCell(style: .default, reuseIdentifier: ID)
            }
            cell?.selectionStyle = .none
            return cell!
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = IqiyisearchHeaderView.headView(with: tableView)
            if section == 0 {
                headerView.titleLabel.text = "历史"
            } else {
                headerView.titleLabel.text = "热门"
            }
       
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
