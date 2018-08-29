//
//  dataTableViewCell.swift
//  core_data_db
//
//  Created by smac on 8/29/18.
//  Copyright © 2018 Enchanter. All rights reserved.
//

import UIKit

class dataTableViewCell: UITableViewCell {

    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
