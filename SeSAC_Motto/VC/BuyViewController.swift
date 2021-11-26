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
    var lottoPapers: Results<MottoPaper>!
    
    var nextDrawNo = 0 {
        didSet {
            nextDrawNoLabel.text = "\(nextDrawNo)"
            print("nextDrawNo",nextDrawNo)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mottoCollectionView.reloadData()
        lottoCollectionView.reloadData()
        nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1
        
        let predicate1 = NSPredicate(format: "mottoPaperDrwNo == %@ AND isMottoPaper == true", NSNumber(integerLiteral: nextDrawNo))
        mottoPapers = localRealm.objects(MottoPaper.self).filter(predicate1)
      
        let predicate2 = NSPredicate(format: "mottoPaperDrwNo == %@ AND isMottoPaper == false",NSNumber(integerLiteral: nextDrawNo))
        lottoPapers = localRealm.objects(MottoPaper.self).filter(predicate2)
        
        mottoCollectionView.delegate = self
        mottoCollectionView.dataSource = self
       
        lottoCollectionView.delegate = self
        lottoCollectionView.dataSource = self
        
        let nibName = UINib(nibName: MottoPaperCollectionViewCell.identifier, bundle: nil)
        mottoCollectionView.register(nibName, forCellWithReuseIdentifier: MottoPaperCollectionViewCell.identifier)
        lottoCollectionView.register(nibName, forCellWithReuseIdentifier: MottoPaperCollectionViewCell.identifier)
        
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
        lottoCollectionView.collectionViewLayout = flowLayout
        
        print(mottoPapers.count)
        print(lottoPapers.count)
        
       
        
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
        if collectionView == mottoCollectionView {
            return mottoPapers.count
        } else {
            return lottoPapers.count
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == mottoCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MottoPaperCollectionViewCell.identifier, for: indexPath) as? MottoPaperCollectionViewCell else { return UICollectionViewCell()}
            
            let row = indexPath.row
            
            let predicate = NSPredicate(format: "mottoPaperNum == %@ AND isMottoPaper == true", NSNumber(integerLiteral: row))
            let mottoPaper = mottoPapers.filter(predicate).first!.mottoPaper

            
            for i in 0...mottoPaper.count-1 {
                let predicate = NSPredicate(format: "mottoNum == %@", NSNumber(integerLiteral: i))
                let game = mottoPaper.filter(predicate).first! // 0~4번 게임
                
                let text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2) \(game.mottoDrwtNo3) \(game.mottoDrwtNo4) \(game.mottoDrwtNo5) \(game.mottoDrwtNo6)"
                switch i {
                case 0 : cell.gameALabel.text = text
                case 1 : cell.gameBLabel.text = text
                case 2 : cell.gameCLabel.text = text
                case 3 : cell.gameDLabel.text = text
                case 4 : cell.gameELabel.text = text
                default : print("default")
                }
                
            
            }
            cell.backgroundColor = .orange
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MottoPaperCollectionViewCell.identifier, for: indexPath) as? MottoPaperCollectionViewCell else { return UICollectionViewCell()}
            
            let row = indexPath.row
            
            let predicate = NSPredicate(format: "mottoPaperNum == %@ AND isMottoPaper == false", NSNumber(integerLiteral: row))
            let lottoPaper = lottoPapers.filter(predicate).first!.mottoPaper
            
            for i in 0...lottoPaper.count-1 {
                let predicate = NSPredicate(format: "mottoNum == %@", NSNumber(integerLiteral: i))
                let game = lottoPaper.filter(predicate).first! // 0~4번 게임
                
                let text = "\(game.mottoDrwtNo1) \(game.mottoDrwtNo2) \(game.mottoDrwtNo3) \(game.mottoDrwtNo4) \(game.mottoDrwtNo5) \(game.mottoDrwtNo6)"
                switch i {
                case 0 : cell.gameALabel.text = text
                case 1 : cell.gameBLabel.text = text
                case 2 : cell.gameCLabel.text = text
                case 3 : cell.gameDLabel.text = text
                case 4 : cell.gameELabel.text = text
                default : print("default")
                }
                
            
            }
            cell.backgroundColor = .yellow
            return cell
        }
     
    }
 
    
    
}
