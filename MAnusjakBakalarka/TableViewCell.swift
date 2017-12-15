//
//  TableViewCell.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 10/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = .none
    }
}
