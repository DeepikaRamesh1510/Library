//
//  BookListCellTableViewCell.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet var bookImage: UIImageView!
	@IBOutlet var addBookButton: UIButton!
    @IBOutlet var title: UILabel!
    @IBOutlet var author: UILabel!
	var parentViewController: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	@IBAction func presentModalToAddBookToMyLibrary(_ sender: Any) {
//		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//		guard let bookViewController = storyBoard.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
//			print("Failed to instantiate Book view controller!")
//			return
//		}
//		bookViewController.modalPresentationStyle = .popover
//		parentViewController?.present(bookViewController, animated: true, completion: nil)
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
