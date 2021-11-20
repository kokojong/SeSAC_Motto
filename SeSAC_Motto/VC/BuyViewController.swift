//
//  BuyViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/18.
//

import UIKit

class BuyViewController: UIViewController {
    @IBOutlet weak var collectionViewContainer: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: MottoPaperCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: MottoPaperCollectionViewCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 20
        let w = collectionView.frame.size.width - 3*space
        let h = collectionView.frame.size.height - 2*space
        let totalWidth = UIScreen.main.bounds.width - 3*space // 2개 배치 -> 공간은 3개 비우기(여백까지)
        flowLayout.itemSize = CGSize(width: w/2, height: h)
//        flowLayout.minimumLineSpacing = CGFloat(50)
//        flowLayout.minimumInteritemSpacing = CGFloat(50)
        
        flowLayout.scrollDirection = .horizontal // 가로 스크롤
        
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space) // padding
        
        
        collectionView.collectionViewLayout = flowLayout
        
        
        // Do any additional setup after loading the view.
    }
    
}

extension BuyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MottoPaperCollectionViewCell.identifier, for: indexPath) as? MottoPaperCollectionViewCell else { return UICollectionViewCell()}
        
//        cell.testLabel.text = "asdfasdf"
        cell.backgroundColor = .green
        
        
        return cell
    }
 
    
    
}
