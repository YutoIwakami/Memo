//
//  TableViewCell.swift
//  暗記Book
//
//  Created by T80 on 2016/04/01.
//
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var cell:UILabel!
    @IBOutlet var subtitle:UILabel!
    @IBOutlet var timeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cell.text = "title"
        subtitle.text = "text"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
