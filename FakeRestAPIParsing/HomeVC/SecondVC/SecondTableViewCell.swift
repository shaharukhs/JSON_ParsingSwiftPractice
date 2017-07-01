//
//  SecondTableViewCell.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 28/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var LastNameLabel: UILabel!
	
	@IBOutlet weak var userImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
