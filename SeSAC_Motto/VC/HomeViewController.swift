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
    
    var recentDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") {
        didSet {
            drawNumLabel.text = "\(recentDrawNo)"
            print("recentDrawNo",recentDrawNo)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Realm:",localRealm.configuration.fileURL!) // 경로 찾기
        
        drawResults = localRealm.objects(DrawResult.self)
        
        // 기본적으로 처음에 realm에 저장
        if recentDrawNo == 0 {
            for i in 1...989 {
                let predicate = NSPredicate(format: "drwNo == %@", NSNumber(integerLiteral: i))

                if drawResults.filter(predicate).count == 0 {
                    loadAllDrawData(drwNo: i)
                }
            }
            UserDefaults.standard.set(989, forKey: "recentDrawNo")
            recentDrawNo = 989
        }
        
        checkIsRecent(recent: recentDrawNo)
        
    }
    
    func loadAllDrawData(drwNo: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
            // https://www.dhlottery.co.kr/common.do? method=getLottoNumber&drwNo=903
            
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
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
                
                let result = DrawResult(drwNo: drwNo, drwNoDate: drwNoDate, drwtNo1: drwtNo1, drwtNo2: drwtNo2, drwtNo3: drwtNo3, drwtNo4: drwtNo4, drwtNo5: drwtNo5, drwtNo6: drwtNo6, firstAccumamnt: firstAccumamnt, firstWinamnt: firstWinamnt, firstPrzwnerCo: firstPrzwnerCo, bnusNo: bnusNo)
                self.saveResult(drawResult: result)
                
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
    
    func checkIsRecent(recent: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(recent + 1)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["returnValue"] == "fail" { // 아직 발표 이전
                    print("발표 이전")
                    return
                } else { // 새로운 회차가 있다면
                    UserDefaults.standard.set(recent+1, forKey: "recentDrawNo")
                    self.recentDrawNo = recent+1
                    
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
                    
                    let result = DrawResult(drwNo: drwNo, drwNoDate: drwNoDate, drwtNo1: drwtNo1, drwtNo2: drwtNo2, drwtNo3: drwtNo3, drwtNo4: drwtNo4, drwtNo5: drwtNo5, drwtNo6: drwtNo6, firstAccumamnt: firstAccumamnt, firstWinamnt: firstWinamnt, firstPrzwnerCo: firstPrzwnerCo, bnusNo: bnusNo)
                    self.saveResult(drawResult: result)
                }
                
            case.failure(let error):
                print(error)
            
            }
        
        }
    }
    


}
