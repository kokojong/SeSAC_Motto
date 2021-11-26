//
//  BuyViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/18.
//

import UIKit
import RealmSwift

class BuyViewController: UIViewController {
    @IBOutlet weak var collectionViewContainer: UIView!
    
    @IBOutlet weak var mottoCollectionView: UICollectionView!
    @IBOutlet weak var lottoCollectionView: UICollectionView!
    @IBOutlet weak var nextDrawNoLabel: UILabel!
    
    let localRealm = try! Realm()
    
    var mottoPapers: Results<MottoPaper>! // 해당 회차의 paper(realm 데이터)
    
    var nextDrawNo = 0 {
        didSet {
            nextDrawNoLabel.text = "\(nextDrawNo)"
            print("nextDrawNo",nextDrawNo)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mottoCollectionView.reloadData()
        nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1
        
        let predicate = NSPredicate(format: "mottoPaperDrwNo == %@", NSNumber(integerLiteral: nextDrawNo))
        mottoPapers = localRealm.objects(MottoPaper.self).filter(predicate)
      
        
        mottoCollectionView.delegate = self
        mottoCollectionView.dataSource = self
        
        let nibName = UINib(nibName: MottoPaperCollectionViewCell.identifier, bundle: nil)
        mottoCollectionView.register(nibName, forCellWithReuseIdentifier: MottoPaperCollectionViewCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 20
        let w = mottoCollectionView.frame.size.width - 3*space
        let h = mottoCollectionView.frame.size.height - 2*space
        let totalWidth = UIScreen.main.bounds.width - 3*space // 2개 배치 -> 공간은 3개 비우기(여백까지)
        flowLayout.itemSize = CGSize(width: w/2, height: h)
//        flowLayout.minimumLineSpacing = CGFloat(50)
//        flowLayout.minimumInteritemSpacing = CGFloat(50)
        
        flowLayout.scrollDirection = .horizontal // 가로 스크롤
        
        flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space) // padding
        
        
        mottoCollectionView.collectionViewLayout = flowLayout
        
       
        
    }
    @IBAction func onMottoBuyButtonClicked(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: MottoBuyViewController.identifier) as? MottoBuyViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func onLottoBuyButtonClicked(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: LottoBuyViewController.identifier) as? LottoBuyViewController else { return }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BuyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mottoPapers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MottoPaperCollectionViewCell.identifier, for: indexPath) as? MottoPaperCollectionViewCell else { return UICollectionViewCell()}
        
        let row = indexPath.row
        
        let predicate = NSPredicate(format: "mottoPaperNum == %@", NSNumber(integerLiteral: indexPath.row))
        // 5개의 게임 정보를 담고있는 List<Motto>
        let mottoPaper = mottoPapers.filter(predicate).first!.mottoPaper
       
        let gameCount = mottoPaper.count
        
        for i in 0...gameCount-1 {
            let predicate = NSPredicate(format: "mottoNum == %@", NSNumber(integerLiteral: i))
            let game = mottoPaper.filter(predicate).first! // 0~4번 게임
            
            switch i {
            case 0 : cell.gameALabel.text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2)"
            case 1 : cell.gameBLabel.text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2)"
            case 2 : cell.gameCLabel.text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2)"
            case 3 : cell.gameDLabel.text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2)"
            case 4 : cell.gameELabel.text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2)"
            default : print("default")
            }
            
        
        }
        
        cell.backgroundColor = .yellow
        
        
        return cell
    }
 
    
    
}
