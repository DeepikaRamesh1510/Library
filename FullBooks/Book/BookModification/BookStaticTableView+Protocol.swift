//
//  BookStaticTableView+Protocol.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BookStaticTableViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.item == 5 {
			return 150
		}
		return 60
	}
}
