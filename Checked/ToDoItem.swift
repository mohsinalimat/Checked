//
//  ToDoItem.swift
//  Checked
//
//  Created by Roman Subrychak on 2/6/18.
//  Copyright © 2018 Roman Subrychak. All rights reserved.
//

import Foundation

class ToDoItem: NSObject, NSCoding {
	
	var itemDescription: String
	let date: Date
	
	init(itemDescription: String) {
		self.itemDescription = itemDescription
		date = Date()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(itemDescription, forKey: "itemDescription")
		aCoder.encode(date, forKey: "date")
	}
	
	required init?(coder aDecoder: NSCoder) {
		guard let itemDescription =
			aDecoder.decodeObject(forKey: "itemDescription") as? String,
			let date = aDecoder.decodeObject(forKey: "date") as? Date else {
				return nil
		}
		
		self.itemDescription = itemDescription
		self.date = date
	}
}
