//
//  AlbumTableViewCell.swift
//  FakeRestAPIParsing
//
//  Created by Ascra on 29/06/17.
//  Copyright © 2017 Ascracom.ascratech. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

	@IBOutlet weak var idCount: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
