//
//  ToDoItemsDataSource.swift
//  Checked
//
//  Created by Roman Subrychak on 2/9/18.
//  Copyright © 2018 Roman Subrychak. All rights reserved.
//

import UIKit

class ToDoItemsDataSource: NSObject, UITableViewDataSource {
	
	lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/YYYY"
		return dateFormatter
	}()
	
	let itemManager = ItemManager()
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let title = Status(rawValue: section)?.description else { return "" }
		return title
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = Status(rawValue: section)!
		switch section {
		case .active:
			return itemManager.activeCount
		case .finished:
			return itemManager.finishedCount
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let identifier = Status(rawValue: indexPath.section),
			let cell = tableView.dequeueReusableCell(withIdentifier:
				identifier.description, for: indexPath) as? ToDoItemCell else {
				return UITableViewCell()
		}
		
		let item = itemManager[identifier, indexPath.row]
		
		cell.title.text = item.itemDescription
		cell.date.text = dateFormatter.string(from: item.date)
		
		return cell
	}
}
