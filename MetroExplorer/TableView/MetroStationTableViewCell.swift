//
//  MetroStationTableViewCell.swift
//  MetroExplorer
//
//  Created by Chris Sun on 11/30/18.
//  Copyright © 2018 Chris Sun. All rights reserved.
//

import UIKit

class MetroStationTableViewCell: UITableViewCell {

    @IBOutlet weak var MetroStationName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
