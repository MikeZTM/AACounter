//
//  ItemCell.swift
//  
//
//  Created by Mike Lee on 8/3/15.
//
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var note: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
