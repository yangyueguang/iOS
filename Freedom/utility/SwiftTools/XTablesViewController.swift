//
//  XTablesViewController.swift
//  Test
//
//  Created by Super on 7/3/18.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
//import XExtension
class UNTestTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var superScoll: UIScrollViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.identifier)
        }
        cell?.textLabel?.text = "===\(indexPath.row)"
        return cell!
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        superScoll?.scrollViewDidScroll!(scrollView)
    }
}
class XTablesViewController: UIViewController, UIScrollViewDelegate {
    var startPoint = CGPoint.zero
    var isRefreshOnTop = false
    var scrollV: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64))
    var headV: UIView = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 200))
    var tables = [UIScrollView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollV.delegate = self
        scrollV.isPagingEnabled = true
        headV.isUserInteractionEnabled = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.headViewDidPan(_:)))
        headV.addGestureRecognizer(pan)
        fillViewData()
    }
    func fillViewData() {
        isRefreshOnTop = true
        let table1 = UNTestTableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH))
        let table2 = UNTestTableView(frame: CGRect(x: APPW, y: 0, width: APPW, height: APPH))
        let table3 = UNTestTableView(frame: CGRect(x: APPW * 2, y: 0, width: APPW, height: APPH))
        let table4 = UNTestTableView(frame: CGRect(x: APPW * 3, y: 0, width: APPW, height: APPH))
        table4.superScoll = self
        table3.superScoll = self
        table2.superScoll = self
        table1.superScoll = self
        headV.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        headV.isUserInteractionEnabled = true
        tables.append(contentsOf: [table1, table2, table3, table4])
        for i in 0..<tables.count {
            let table: UIScrollView = tables[i]
            table.bounces = true
            let headBottom = headV.bounds.size.height
            table.frame = CGRect(x: scrollV.bounds.size.width * CGFloat(i), y: 0, width: scrollV.bounds.size.width, height: scrollV.bounds.size.height)
            if isRefreshOnTop && (table is UITableView) {
                let tableV = table as! UITableView
                tableV.tableHeaderView = UIView()
                tableV.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: APPW, height: headBottom)
            } else {
                table.contentInset = UIEdgeInsets(top: headBottom, left: 0, bottom: 0, right: 0)
            }
            if i == 0 {
                scrollV.addSubview(table)
                didSelectedTable(with: i)
            }
        }
        scrollV.contentSize = CGSize(width: scrollV.bounds.size.width * CGFloat(tables.count), height: scrollV.bounds.size.height)
        view.addSubview(scrollV)
        view.addSubview(headV)
    }
    ///FIXME:使用的时候尽量重写，完成数据调用刷新功能。
    func didSelectedTable(with index: Int) {
    }
    ///FIXME:下面的不再动
    deinit {
        scrollV.delegate = nil
        for scroll: UIScrollView? in tables {
            scroll?.removeFromSuperview()
        }
        tables.removeAll()
        scrollV.removeFromSuperview()
    }
    @objc func headViewDidPan(_ pan: UIPanGestureRecognizer) {
        let view: UIView = pan.view!
        if pan.state == .began || pan.state == .changed {
            if (view.frame.origin.y ) < -headV.frame.size.height {
                pan.setTranslation(CGPoint.zero, in: self.view)
                return
            } else if (view.frame.origin.y ) > 0 {
                pan.setTranslation(CGPoint.zero, in: self.view)
                return
            }
            let translation: CGPoint = pan.translation(in: self.view)
            view.frame = CGRect(x: view.frame.origin.x , y: max(min((view.frame.origin.y) + translation.y, 0), -headV.frame.size.height), width: view.frame.size.width , height: view.frame.size.height )
            let currentIndex = Int(scrollV.contentOffset.x / scrollV.bounds.size.width)
            let scroll: UIScrollView = tables[currentIndex]
            scroll.contentOffset = CGPoint(x: scroll.contentOffset.x, y: scroll.contentOffset.y + (translation.y))
            pan.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startPoint = scrollView.contentOffset
        let index = Int(startPoint.x / scrollView.frame.size.width)
        if scrollView == scrollV {
            for i in 0..<tables.count {
                let table: UIScrollView = tables[i]
                if table.contentOffset.y > headV.bounds.size.height {
                    continue
                }
                if (!isRefreshOnTop && (table is UITableView)){
                    table.contentOffset = CGPoint(x: 0, y: CGFloat(-headV.frame.origin.y - headV.bounds.size.height))
                }else{
                    table.contentOffset = CGPoint(x: 0, y: CGFloat(-headV.frame.origin.y))
                }
            }
            print("开始滚动了,从第\(index)页开始滚动")
        } else {
            print("=========")
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset: CGPoint = scrollView.contentOffset
        if scrollView == scrollV {
            var progress: CGFloat = 0
            var originalIndex: Int = 0
            var targetIndex: Int = 0
            if offset.x > startPoint.x {// 左滑
                progress = offset.x / scrollView.bounds.size.width - floor(offset.x / scrollView.bounds.size.width)
                originalIndex = Int(offset.x / scrollView.bounds.size.width)
                targetIndex = originalIndex + 1
                if targetIndex >= tables.count || offset.x - startPoint.x >= scrollView.bounds.size.width {
                    progress = 1
                    targetIndex = originalIndex
                }
            } else {// 右滑
                progress = 1 - offset.x / scrollView.bounds.size.width + floor(offset.x / scrollView.bounds.size.width)
                targetIndex = Int(offset.x / scrollView.bounds.size.width)
                originalIndex = min(targetIndex + 1, tables.count - 1)
            }
            print("\(progress)\(targetIndex)")
            //        [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
        } else if scrollView.isDragging || isRefreshOnTop {
            let headVSize: CGSize = headV.bounds.size
            if !isRefreshOnTop {
                offset.y += headVSize.height
            }
            //        NSLog(@"%lf",offset.y);
            if offset.y > 0 && offset.y < headVSize.height {
                headV.frame = CGRect(x: headV.frame.origin.x, y: -offset.y, width: headVSize.width, height: headVSize.height)
            } else if offset.y <= 0 {
                if !isRefreshOnTop && (scrollView is UITableView) {
                    headV.frame = CGRect(x: headV.frame.origin.x, y: 0, width: headVSize.width, height: headVSize.height)
                } else {
                    headV.frame = CGRect(x: headV.frame.origin.x, y: -offset.y, width: headVSize.width, height: headVSize.height)
                }
            } else {
                headV.frame = CGRect(x: headV.frame.origin.x, y: -headVSize.height, width: headVSize.width, height: headVSize.height)
            }
        } else {
            if scrollView.contentOffset.y > headV.bounds.size.height {
            } else if scrollView.contentOffset.y > 0 {
            } else {
                scrollView.contentOffset = CGPoint(x: 0, y: -headV.bounds.size.height - headV.frame.origin.y)
            }
        }
        if scrollView.isDragging && !(scrollView == scrollV) {
            let offsetY: CGFloat = scrollView.contentOffset.y + headV.bounds.size.height * (!isRefreshOnTop ? 1:0)
            let alpha: CGFloat = min(max(offsetY / self.headV.bounds.size.height, 0), 1)
            print(alpha)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        print("滚到了第\(index)页")
        if scrollView == scrollV {
            if index <= tables.count {
                let table: UIScrollView = tables[index]
                if table.superview == nil {
                    scrollV.addSubview(table)
                    if (table is UITableView) {
                        (table as? UITableView)?.reloadData()
                    }
                    didSelectedTable(with: index)
                }
            }
        } else {
            print("=========")
        }
    }
}
