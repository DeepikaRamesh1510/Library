//
//  BookListCellTableViewCell.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookListCellTableViewCell: UITableViewCell {

    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var synopsis: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var author: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
