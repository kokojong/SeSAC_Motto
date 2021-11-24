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
import Network

class HomeViewController: UIViewController {
    
    @IBOutlet weak var drawNumLabel: UILabel!
    @IBOutlet weak var firstAccumamntLabel: UILabel!
    @IBOutlet weak var firstWinamntLabel: UILabel!
    @IBOutlet weak var firstPrzwnerCoLabel: UILabel!
    @IBOutlet weak var resultStackView: UIStackView!
    
    let localRealm = try! Realm()
    
    var drawResults : Results<DrawResult>!
    
    var recentDrawNo = UserDefaults.standard.integer(forKey: "recentDrawNo") {
        didSet {
            drawNumLabel.text = "\(recentDrawNo)"
            print("recentDrawNo",recentDrawNo)
            print(recentDrawResult.first)
            
            UserDefaults.standard.set(recentDrawNo, forKey: "recentDrawNo")
            let predicate = NSPredicate(format: "drwNo == %@", NSNumber(integerLiteral: recentDrawNo))
            recentDrawResult = drawResults.filter(predicate) // 가장 최근 회차 정보
            checkIsRecent(recent: recentDrawNo)
            updateUIByRecentDrawNo()
            
        }
    }
    
    var recentDrawResult: Results<DrawResult>! {
        didSet {
            updateUIByRecentDrawNo()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let result = monitorNetwork()
        print("result", result)
        
        print("Realm:",localRealm.configuration.fileURL!) // 경로 찾기
        
        let dispatch = DispatchGroup()
        
        drawResults = localRealm.objects(DrawResult.self)
        
        let predicate = NSPredicate(format: "drwNo == %@", NSNumber(integerLiteral: recentDrawNo))
        recentDrawResult = drawResults.filter(predicate) // 가장 최근 회차 정보
        
        // 기본적으로 처음에 realm에 저장
        if drawResults.count < 989 { // 네트워크 오류 등으로 989개를 못받은 경우 -> 모자란 만큼 받아오자
            DispatchQueue.global().sync {
                for i in 1...989 {
                    let predicate = NSPredicate(format: "drwNo == %@", NSNumber(integerLiteral: i))

                    if drawResults.filter(predicate).count == 0 {
                        loadAllDrawData(drwNo: i)
                    }
                    
                }
                
                UserDefaults.standard.set(989, forKey: "recentDrawNo")
                self.recentDrawNo = 989
            }
           
            
            
            
//            dispatch.notify(queue: .main){
//                print("dispatch")
//                UserDefaults.standard.set(989, forKey: "recentDrawNo")
//                self.recentDrawNo = 989
//            }
//            UserDefaults.standard.set(989, forKey: "recentDrawNo")
//            recentDrawNo = 989
        }
        
        checkIsRecent(recent: recentDrawNo)
        
        updateUIByRecentDrawNo()
        
        
        
    }
    
    func loadAllDrawData(drwNo: Int) {
    
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
            // https://www.dhlottery.co.kr/common.do? method=getLottoNumber&drwNo=903
        
//        let sessionManager: Session = {
//          //2
//        let configuration = URLSessionConfiguration.af.default
//          //3
//        configuration.timeoutIntervalForRequest = 30
//          //4
//        configuration.waitsForConnectivity = true
//
//          return Session(configuration: configuration)
//        }()
        
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
        
        DispatchQueue.global().sync {
            
            AF.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    if json["returnValue"] == "fail" { // 아직 발표 이전
                        print("발표 이전")
                        return
                    } else { // 새로운 회차가 있다면
                  
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
                        
//                        UserDefaults.standard.set(recent+1, forKey: "recentDrawNo")
                        print("UD: ", UserDefaults.standard.integer(forKey: "recentDrawNo"))
                        self.recentDrawNo = recent+1
                    }
                    
                case.failure(let error):
                    print(error)
                
                }
            
            }
            
            
            
        }
        
    }
    

    func monitorNetwork() -> Bool {
            
        var status: Bool = false
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied {
                status = true
                DispatchQueue.main.async {
                    print("연결되어 있음")
                    status = true
                    
                }
            } else {
                status = false
                DispatchQueue.main.async {
                    print("연결되어 있지 않음")
                    status = false
                    
                    let alert = UIAlertController(title: "네트워크 오류", message: "네트워크에 연결되어 있지 않아요.\n설정화면으로 이동합니다 🥲", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                   
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
        
//        print("status",status)
        return status
    }

    func updateUIByRecentDrawNo() {
        
        drawNumLabel.text = "\(recentDrawNo)"
        let recentResult = recentDrawResult.first ?? DrawResult(drwNo: 0, drwNoDate: "", drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, firstAccumamnt: 0, firstWinamnt: 0, firstPrzwnerCo: 0, bnusNo: 0)
        print("update",recentDrawResult.first)
//        let recentResult = recentDrawResult.first!
        var index = 1
        for v in resultStackView.arrangedSubviews {
            let label = v as! UILabel
            
            switch index {
            case 1: label.text = "\(recentResult.drwtNo1)"
            case 2: label.text = "\(recentResult.drwtNo2)"
            case 3: label.text = "\(recentResult.drwtNo3)"
            case 4: label.text = "\(recentResult.drwtNo4)"
            case 5: label.text = "\(recentResult.drwtNo5)"
            case 6: label.text = "\(recentResult.drwtNo6)"
            case 8: label.text = "\(recentResult.bnusNo)"
            default: // 7번은 +
                label.text = "+"
            }
       
            index += 1
        }
        
        firstWinamntLabel.text = "\(recentResult.firstWinamnt)"
        firstAccumamntLabel.text = "\(recentResult.firstAccumamnt)"
        firstPrzwnerCoLabel.text = "\(recentResult.firstPrzwnerCo)"
        
    }
}
