//
//  LottoPaperViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/23.
//

import UIKit
import RealmSwift

class LottoPaperViewController: UIViewController {
    
    static let identifier = "LottoPaperViewController"
    
    @IBOutlet weak var drawNoLabel: UILabel!
    
    @IBOutlet weak var gameALabel: UILabel!
    @IBOutlet weak var gameBLabel: UILabel!
    @IBOutlet weak var gameCLabel: UILabel!
    @IBOutlet weak var gameDLabel: UILabel!
    @IBOutlet weak var gameELabel: UILabel!
    
    var includedNumberList: [Int] = []
    var exceptedNumberList: [Int] = []
    
    var posibleNumberList: [Int] = [] //
    
    let localRealm = try! Realm()
    
    var mottoPapers: Results<MottoPaper>!
    
    var isMotto: Bool = false
    
    var mottoDrwNo = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mottoPapers = localRealm.objects(MottoPaper.self)
        
        for i in 1...45 {
            if exceptedNumberList.contains(i) {
                
            } else if includedNumberList.contains(i) {
                
            } else { // 나머지 수
                posibleNumberList.append(i)
            }
        }
        
        var mottoList: [Motto] = []
        for i in 0...4 {
            let resultNumberList = createNumberList()[0...5].sorted()
            let motto =  Motto(mottoDrwNo: mottoDrwNo, mottoBuyDate: Date(), mottoDrwtNo1: resultNumberList[0], mottoDrwtNo2: resultNumberList[1], mottoDrwtNo3: resultNumberList[2], mottoDrwtNo4: resultNumberList[3], mottoDrwtNo5: resultNumberList[4], mottoDrwtNo6: resultNumberList[5], mottoNum: i, isMotto: isMotto)
            mottoList.append(motto)
        }
        let mottoPaper = MottoPaper(mottoPaperDrwNo: 1, mottoPaperBuyDate: Date(), mottoPaper: mottoList, mottoPaperNum: 1, isMottoPaper: isMotto)
       
        
        try! localRealm.write{
            localRealm.add(mottoPaper)
        }
        
        
        // 데이터 넣어서 보여주기
        
        drawNoLabel.text = "\(mottoPaper.mottoPaperDrwNo)회차"
        updateTextOnLabel(label: gameALabel, mottoPaper: mottoPaper, game: 0)
        updateTextOnLabel(label: gameBLabel, mottoPaper: mottoPaper, game: 1)
        updateTextOnLabel(label: gameCLabel, mottoPaper: mottoPaper, game: 2)
        updateTextOnLabel(label: gameDLabel, mottoPaper: mottoPaper, game: 3)
        updateTextOnLabel(label: gameELabel, mottoPaper: mottoPaper, game: 4)
        
        
    
    }
    

    func createNumberList () -> [Int] {
        
        let resultList = includedNumberList + posibleNumberList.shuffled()
        return resultList
    }
    
    func updateTextOnLabel(label: UILabel, mottoPaper: MottoPaper ,game: Int){
        label.text = "\(mottoPaper.mottoPaper[game].mottoDrwtNo1) \(mottoPaper.mottoPaper[game].mottoDrwtNo2) \(mottoPaper.mottoPaper[game].mottoDrwtNo3) \(mottoPaper.mottoPaper[game].mottoDrwtNo4) \(mottoPaper.mottoPaper[game].mottoDrwtNo5) \(mottoPaper.mottoPaper[game].mottoDrwtNo6)"
    }
}
