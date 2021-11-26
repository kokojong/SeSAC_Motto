//
//  LottoBuyViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/25.
//

import UIKit
import RealmSwift

class LottoBuyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "LottoBuyViewController"
    
    var lottoList: [[Int]] = []
    
    var numberList: [Int] = []
    
    var nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1
    
    let localRealm = try! Realm()
    
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onSaveGameButtonClicked(_ sender: UIButton) {
        if numberList.count != 6 {
            showAlert(title: "번호 오류", message: "6개의 번호를 선택해주세요")
        } else {
            if lottoList.count < 5 {
                lottoList.append(numberList.sorted())
            } else {
                showAlert(title: "게임수 오류", message: "한번에 5개의 게임까지 저장이 가능합니다.")
            }
        }
        
        tableView.reloadData()
        
        
    }
    
    @IBAction func onSavePaperButtonClicked(_ sender: UIBarButtonItem) {
    
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: LottoPaperViewController.identifier) as? LottoPaperViewController else { return }
        
        vc.lottoNumerList = lottoList
        let predicate = NSPredicate(format: "mottoPaperDrwNo == %@ AND isMottoPaper == false", NSNumber(integerLiteral: nextDrawNo))
        vc.mottoPaperCount = localRealm.objects(MottoPaper.self).filter(predicate).count
        vc.isMotto = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        lottoList = []
        
        tableView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        numberList.append(indexPath.row + 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if numberList.contains(indexPath.row + 1){
            if let index = numberList.firstIndex(of: indexPath.row + 1) {
                numberList.remove(at: index)
            }
        }
        
        
    }
    
    
}

extension LottoBuyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lottoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LottoTableViewCell.identifier, for: indexPath) as? LottoTableViewCell else { return UITableViewCell()}
        
        cell.testLabel.text = "\(lottoList[indexPath.row][0]) \(lottoList[indexPath.row][1]) \(lottoList[indexPath.row][2]) \(lottoList[indexPath.row][3]) \(lottoList[indexPath.row][4]) \(lottoList[indexPath.row][5]) "
        
        return cell
    }
    
    
}
