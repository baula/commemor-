//
//  TableCell.swift
//  MyStory
//
//  Created by Jessica Choi on 7/11/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var imageBorder: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
