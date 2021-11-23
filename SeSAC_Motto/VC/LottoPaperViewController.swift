//
//  LottoPaperViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/23.
//

import UIKit

class LottoPaperViewController: UIViewController {
    
    static let identifier = "LottoPaperViewController"
    
    var includedNumberList: [Int] = []
    var exceptedNumberList: [Int] = []
    
    var posibleNumberList: [Int] = [] //
    var resultNumberList: [Int] = [] // 최종 결과

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...45 {
            if exceptedNumberList.contains(i) {
                
            } else if includedNumberList.contains(i) {
                
            } else { // 나머지 수
                posibleNumberList.append(i)
            }
        }
        
        resultNumberList = includedNumberList + posibleNumberList.shuffled()
        print(resultNumberList)
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
