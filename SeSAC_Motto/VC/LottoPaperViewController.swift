//
//  LottoPaperViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/26.
//

import UIKit
import RealmSwift

class LottoPaperViewController: UIViewController {
    
    @IBOutlet weak var drawNoLabel: UILabel!
    @IBOutlet weak var gameALabel: UILabel!
    @IBOutlet weak var gameBLabel: UILabel!
    @IBOutlet weak var gameCLabel: UILabel!
    @IBOutlet weak var gameDLabel: UILabel!
    @IBOutlet weak var gameELabel: UILabel!
    
    
    static let identifier = "LottoPaperViewController"

    var lottoNumerList: [[Int]] = []
    
    let localRealm = try! Realm()
    
    var lottoPapers: Results<MottoPaper>!
    
    var mottoPaperCount = 0
    
    var isMotto: Bool = false
    
    var nextDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") + 1 {
        didSet {
            print("nextDrawNo",nextDrawNo)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lottoPapers = localRealm.objects(MottoPaper.self)
        
        var lottoList: [Motto] = []
        for i in 0...lottoNumerList.count - 1 {
            let resultNumberList = lottoNumerList[i].sorted()
            let lotto =  Motto(mottoDrwNo: nextDrawNo, mottoBuyDate: Date(), mottoDrwtNo1: resultNumberList[0], mottoDrwtNo2: resultNumberList[1], mottoDrwtNo3: resultNumberList[2], mottoDrwtNo4: resultNumberList[3], mottoDrwtNo5: resultNumberList[4], mottoDrwtNo6: resultNumberList[5], mottoNum: i, isMotto: isMotto)
            lottoList.append(lotto)
        }
        
        let lottoPaper = MottoPaper(mottoPaperDrwNo: nextDrawNo, mottoPaperBuyDate: Date(), mottoPaper: lottoList, mottoPaperNum: mottoPaperCount, isMottoPaper: isMotto)
       
        
        try! localRealm.write{
            localRealm.add(lottoPaper)
        }
        
        drawNoLabel.text = "\(nextDrawNo)"
        
        for i in 0...lottoNumerList.count - 1 {
            switch i {
            case 0: updateTextOnLabel(label: gameALabel, lottoPaper: lottoPaper, game: i)
            case 1: updateTextOnLabel(label: gameBLabel, lottoPaper: lottoPaper, game: i)
            case 2: updateTextOnLabel(label: gameCLabel, lottoPaper: lottoPaper, game: i)
            case 3: updateTextOnLabel(label: gameDLabel, lottoPaper: lottoPaper, game: i)
            case 4: updateTextOnLabel(label: gameELabel, lottoPaper: lottoPaper, game: i)
            default :
                print("error")
            }
            
        }
        
    }
    
    func updateTextOnLabel(label: UILabel, lottoPaper: MottoPaper ,game: Int){
        label.text = "\(lottoPaper.mottoPaper[game].mottoDrwtNo1) \(lottoPaper.mottoPaper[game].mottoDrwtNo2) \(lottoPaper.mottoPaper[game].mottoDrwtNo3) \(lottoPaper.mottoPaper[game].mottoDrwtNo4) \(lottoPaper.mottoPaper[game].mottoDrwtNo5) \(lottoPaper.mottoPaper[game].mottoDrwtNo6)"
    }

  

}
