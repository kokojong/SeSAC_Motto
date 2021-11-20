//
//  HomeViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/18.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var drawNumLabel: UILabel!
    
    let localRealm = try! Realm()
    
    var drawResults : Results<DrawResult>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Realm:",localRealm.configuration.fileURL!) // 경로 찾기
        
        drawResults = localRealm.objects(DrawResult.self)
        
        for i in 1...3 {
            let predicate = NSPredicate(format: "drwNo == %@", NSNumber(integerLiteral: i))

            if drawResults.filter(predicate).count == 0 {
                loadDrawData(drwNo: i)
            }
            
        }
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func loadDrawData(drwNo: Int) {
        
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        
            // https://www.dhlottery.co.kr/common.do? method=getLottoNumber&drwNo=903
            
            AF.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
//                    @Persisted var drwNo: Int // 회차
//                    @Persisted var drwNoDate: String // 발표일자 "2021-10-23"
//                    @Persisted var drwtNo1: Int // 1
//                    @Persisted var drwtNo2: Int // 2
//                    @Persisted var drwtNo3: Int // 3
//                    @Persisted var drwtNo4: Int // 4
//                    @Persisted var drwtNo5: Int // 5
//                    @Persisted var drwtNo6: Int // 6
                    
                //    @Persisted var totSellamnt: Int // 총 판매액(안써도 될듯)
//                    @Persisted var firstAccumamnt: Int // 1등 총 당첨액
//                    @Persisted var firstWinamnt: Int // 1인당 1등 당첨액
//                    @Persisted var firstPrzwnerCo: Int // 1등 당첨자 수
                //    @Persisted var returnValue: String // "success" or "fail" -> 이건 json 받아오면서 체크하는 용으로 쓰기
                    
                    if json["returnValue"] == "fail" {
                        return
                    }
                    
                    let drwNo = json["drwNo"].intValue
                    let drwNoDate = json["drwNoDate"].stringValue
                    let drwtNo1 = json["drwtNo1"].intValue
                    let drwtNo2 = json["drwtNo2"].intValue
                    let drwtNo3 = json["drwtNo3"].intValue
                    let drwtNo4 = json["drwtNo4"].intValue
                    let drwtNo5 = json["drwtNo5"].intValue
                    let drwtNo6 = json["drwtNo6"].intValue
                    let bnusNo = json["bnusNo"].intValue
                    let firstAccumamnt = json["firstAccumamnt"].intValue
                    let firstWinamnt = json["firstWinamnt"].intValue
                    let firstPrzwnerCo = json["firstPrzwnerCo"].intValue
                    
                    
                    //
                    let result = DrawResult(drwNo: drwNo, drwNoDate: drwNoDate, drwtNo1: drwtNo1, drwtNo2: drwtNo2, drwtNo3: drwtNo3, drwtNo4: drwtNo4, drwtNo5: drwtNo5, drwtNo6: drwtNo6, firstAccumamnt: firstAccumamnt, firstWinamnt: firstWinamnt, firstPrzwnerCo: firstPrzwnerCo, bnusNo: bnusNo)
  
                    self.saveResult(drawResult: result)
//
//                    let date = json["drwNoDate"].stringValue
//                    let drwtNumbers: [Any] = [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo, date]
//                    UserDefaults.standard.set(drwtNumbers, forKey: drwNo)
//                    print(drwtNumbers)
//                    self.drwDateLabel.text = "\(date) 추첨"
//
//                    self.result1Label.text = "\(drwtNo1)"
//                    self.result2Label.text = "\(drwtNo2)"
//                    self.result3Label.text = "\(drwtNo3)"
//                    self.result4Label.text = "\(drwtNo4)"
//                    self.result5Label.text = "\(drwtNo5)"
//                    self.result6Label.text = "\(drwtNo6)"
//
//                    self.resultBonusLabel.text = "\(bnusNo)"
                    
                    
                case .failure(let error):
                    // 네트워크 오류라던가
                    print(error)
            }
        }
    }
    
    func saveResult(drawResult: DrawResult){
        try! self.localRealm.write {
            localRealm.add(drawResult)
        }
    }
    


}
