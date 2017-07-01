//
//  FirstTableViewCell.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
