//
//  BooksViewController.swift
//  Freedom
import UIKit
//import XExtension
//import XCarryOn
class BooksViewCell:BaseCollectionViewCell<Any> {
    override func initUI() {
        viewModel.subscribe(onNext: { (mode) in

        }).disposed(by: disposeBag)
    }
}
final class BooksLibraryViewController: BooksBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView: BaseCollectionView!
    @objc func rightAction(){
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "书籍📚阅读";
        self.view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .yellow
        let left = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(rightAction))
        let right = UIBarButtonItem(image: Image.add.image, style: .done, target: self, action: #selector(rightAction))

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
        let cell = collectionView.dequeueCell(BooksViewCell.self, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let log = "你选择的是\(indexPath.section)，\(indexPath.row)"
        noticeInfo(log)
     
    }
}
