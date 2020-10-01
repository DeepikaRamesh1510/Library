//
//  BookListCellTableViewCell.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
	@IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
	var parentViewController: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
