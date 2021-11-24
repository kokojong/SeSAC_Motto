//
//  ResultViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/20.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let localRealm = try! Realm()
    
    var mottoes: Results<Motto>!
    
    var drawResults: Results<DrawResult>!
    
    var winMottoes: [Motto] = []
    
    var winDrawResults: [DrawResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mottoes = localRealm.objects(Motto.self)
        drawResults = localRealm.objects(DrawResult.self)
        

        let nibName = UINib(nibName: ResultTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for motto in mottoes {
            for drawResult in drawResults {
                // 모두 일치한다면
                if motto.mottoDrwtNo1 == drawResult.drwtNo1 && motto.mottoDrwtNo2 == drawResult.drwtNo2 && motto.mottoDrwtNo3 == drawResult.drwtNo3 && motto.mottoDrwtNo4 == drawResult.drwtNo4 && motto.mottoDrwtNo5 == drawResult.drwtNo5 && motto.mottoDrwtNo6 == drawResult.drwtNo6 {
                    
                    if !winMottoes.contains(motto) {
                        winMottoes.append(motto)
                        winDrawResults.append(drawResult)
                    }
                    
                }
            }
            
        }
        print(winMottoes)
        print(winDrawResults)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }
  
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winMottoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        
        cell.testLabel.text = "\(winMottoes[indexPath.row].mottoDrwNo)회차 1등 상금: \(winDrawResults[indexPath.row].firstWinamnt)"
        
//        cell.testLabel.text = "test"
        
        cell.backgroundColor = .yellow
        
        return cell
    }
    
    
}
