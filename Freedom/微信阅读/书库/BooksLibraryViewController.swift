//
//  BooksViewController.swift
//  Freedom
import UIKit
import XExtension
import XCarryOn
class BooksViewCell:BaseCollectionViewCell{
    override func initUI() {
        self.icon = UIImageView(frame: CGRect(x: 10, y: 0, width: APPW/5-20, height:40))
        self.title = UILabel(frame: CGRect(x: 0, y:  self.icon.bottom, width: APPW/5-12, height:20))
        self.title.font = UIFont.systemFont(ofSize: 14)
        self.title.textAlignment = .center
        addSubviews([self.title,self.icon])
    }
}
class BooksLibraryViewController: BooksBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView: BaseCollectionView!
    @objc func rightAction(){
        let wxVc = BookFriendsViewController()
        self.present(wxVc, animated: true) {}
    }
    @objc func leftAction(){
        let loginvctrl = BookReaderViewController()
        self.present(loginvctrl, animated: true) {}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "书籍📚阅读";
        self.view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .yellow
        let left = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(leftAction))
        let right = UIBarButtonItem(image: UIImage(named:"add"), style: .done, target: self, action: #selector(rightAction))

        self.navigationItem.leftBarButtonItem  = left;
        self.navigationItem.rightBarButtonItem = right;
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (APPW-50)/4, height:60);
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:10);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSize(width: APPW, height:30)
        layout.footerReferenceSize = CGSize.zero
        self.collectionView = BaseCollectionView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH-10), collectionViewLayout: layout)
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = .white
        self.collectionView.frame = self.view.bounds
        self.collectionView.register(BooksViewCell.self, forCellWithReuseIdentifier: BooksViewCell.identifier)
        view.addSubview(self.collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksViewCell.identifier, for: indexPath) as? BooksViewCell
        cell?.icon.image = UIImage(named:"userLogo")
        cell?.title.text = "书籍阅读"
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        noticeInfo(log)
        let loginvctrl = BookReaderViewController()
        self.present(loginvctrl, animated: true) {
        }
    }
}
