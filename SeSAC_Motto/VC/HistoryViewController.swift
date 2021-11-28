//
//  StatisticsViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/18.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "구매 기록"
        
    }
    
    @IBAction func onMottoResultButtonClicked(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ResultViewController.identifier) as? ResultViewController else { return }
        
        vc.isMotto = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   

    @IBAction func onLottoResultButtonClicked(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ResultViewController.identifier) as? ResultViewController else { return }
        vc.isMotto = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
