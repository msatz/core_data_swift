//
//  JsonValueTableViewCell.swift
//  core_data_db
//
//  Created by smac on 10/4/18.
//  Copyright © 2018 Enchanter. All rights reserved.
//

import UIKit

class JsonValueTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
