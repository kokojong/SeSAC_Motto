//
//  AutoBuyViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/22.
//

import UIKit

class AutoBuyViewController: UIViewController {

    @IBOutlet weak var includeCollectionView: UICollectionView!
    @IBOutlet weak var exceptCollectionView: UICollectionView!
    
    var includedNumberList: [Int] = []
    var exceptedNumberList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        includeCollectionView.delegate = self
        includeCollectionView.dataSource = self
        exceptCollectionView.delegate = self
        exceptCollectionView.dataSource = self

        let nibName = UINib(nibName: ManualBuyCollectionViewCell.identifier, bundle: nil)
        includeCollectionView.register(nibName, forCellWithReuseIdentifier: ManualBuyCollectionViewCell.identifier)
        exceptCollectionView.register(nibName, forCellWithReuseIdentifier: ManualBuyCollectionViewCell.identifier)
        

        let spacing:CGFloat = 10
        let includeLayout = UICollectionViewFlowLayout()
        let itemSize = (UIScreen.main.bounds.width - 9 * spacing) / 8
        includeLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        includeLayout.minimumLineSpacing = spacing
        includeLayout.minimumInteritemSpacing = spacing
        includeLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        includeLayout.scrollDirection = .vertical

        includeCollectionView.isScrollEnabled = false
        includeCollectionView.collectionViewLayout = includeLayout
        
        let exceptLayout = UICollectionViewFlowLayout()
        exceptLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        exceptLayout.minimumLineSpacing = spacing
        exceptLayout.minimumInteritemSpacing = spacing
        exceptLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        exceptLayout.scrollDirection = .vertical

        exceptCollectionView.isScrollEnabled = false
        exceptCollectionView.collectionViewLayout = exceptLayout
        
        includeCollectionView.allowsMultipleSelection = true
        
    }
    
    func countIncludedNumber() -> Int {
        
        return includedNumberList.count
    }


}

extension AutoBuyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 45
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == includeCollectionView {
            guard let cell = includeCollectionView.dequeueReusableCell(withReuseIdentifier: ManualBuyCollectionViewCell.identifier, for: indexPath) as? ManualBuyCollectionViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .green
            cell.numberLabel.text = String(indexPath.row + 1)
            
            return cell
            
        }
        else {
            guard let cell = exceptCollectionView.dequeueReusableCell(withReuseIdentifier: ManualBuyCollectionViewCell.identifier, for: indexPath) as? ManualBuyCollectionViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .green
            cell.numberLabel.text = String(indexPath.row + 1)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == includeCollectionView {
//            guard let cell = includeCollectionView.dequeueReusableCell(withReuseIdentifier: ManualBuyCollectionViewCell.identifier, for: indexPath) as? ManualBuyCollectionViewCell else { return }
            guard let cell = includeCollectionView.cellForItem(at: indexPath) as? ManualBuyCollectionViewCell else { return }
            
            cell.isSelected = !cell.isSelected
            let num = indexPath.row
            
            if includedNumberList.contains(indexPath.row + 1){ // 해당하는 넘버가 있는 경우(다시 누르는 경우)
                if let index = includedNumberList.firstIndex(of: indexPath.row + 1) {
                    includedNumberList.remove(at: index) // array is now ["world"]
                print(includedNumberList)
                }
            } else {
                includedNumberList.append(indexPath.row + 1)
                print(includedNumberList)
            }
            
        
        } else { // exceptCollectionView
           
        }
        
    }
    
    
    
}
