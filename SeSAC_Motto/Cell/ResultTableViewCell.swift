//
//  ResultTableViewCell.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/20.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = "ResultTableViewCell"

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var winLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
