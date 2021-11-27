//
//  HomeTableViewCell.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/27.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    static let identifier = "HomeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
