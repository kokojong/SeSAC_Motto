//
//  ResultViewController.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/20.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: ResultTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: ResultTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
  
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    
}
