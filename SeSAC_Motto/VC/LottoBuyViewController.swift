//
//  LottoBuyViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/25.
//

import UIKit

class LottoBuyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tableViewNib = UINib(nibName: LottoTableViewCell.identifier, bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: LottoTableViewCell.identifier)
        
        let collectionViewNib = UINib(nibName: ManualBuyCollectionViewCell.identifier, bundle: nil)
        collectionView.register(collectionViewNib, forCellWithReuseIdentifier: ManualBuyCollectionViewCell.identifier)
        
        let spacing:CGFloat = 10
        let layout = UICollectionViewFlowLayout()
        let itemSize = (UIScreen.main.bounds.width - 9 * spacing - 40) / 8 // 좌우 제약조건만큼 빼주고 나누기

        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.scrollDirection = .vertical

        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true
        
    }
    
    @IBAction func onSaveButtonClicked(_ sender: UIButton) {
    }
    
}

extension LottoBuyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 45
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualBuyCollectionViewCell.identifier, for: indexPath) as? ManualBuyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .green
        cell.numberLabel.text = String(indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension LottoBuyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LottoTableViewCell.identifier, for: indexPath) as? LottoTableViewCell else { return UITableViewCell()}
        
        cell.testLabel.text = "test"
        
        return cell
    }
    
    
}
