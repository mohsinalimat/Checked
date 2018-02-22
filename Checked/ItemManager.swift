//
//  ItemManager.swift
//  Checked
//
//  Created by Roman Subrychak on 2/8/18.
//  Copyright © 2018 Roman Subrychak. All rights reserved.
//

import Foundation

enum RestoreDataError: Error {
	case loadDataFail
}

class ItemManager {
	
	private var items: [Status: [ToDoItem]]
	
	private(set) var activeCount: Int
	private(set) var finishedCount: Int
	
	init() {
		self.items = [.active: [], .finished: []]
		self.activeCount = 0
		self.finishedCount = 0
		
		guard let _ = try? loadToDoItems() else { return }
	}
	
	subscript(i: Status, j: Int) -> ToDoItem {
		return items[i]![j]
	}
	
	func add(item: ToDoItem) {
		guard var activeItems = items[.active] else { return }
		
		activeItems.insert(item, at: 0)
		items.updateValue(activeItems, forKey: .active)
		
		activeCount += 1
		
		saveToDoItems()
	}
	
	func remove(from section: Status, at index: Int) {
		guard var toDos = items[section] else { return }
		
		toDos.remove(at: index)
		items.updateValue(toDos, forKey: section)
		
		switch section {
		case .active:
			activeCount -= 1
		case .finished:
			finishedCount -= 1
		}
		
		saveToDoItems()
	}
	
	func checkItem(at index: Int) {
		guard var activeItems = items[.active],
			var finishedItems = items[.finished] else { return }
		
		let checkedItem = activeItems.remove(at: index)
		finishedItems.insert(checkedItem, at: 0)
		
		items.updateValue(activeItems, forKey: .active)
		items.updateValue(finishedItems, forKey: .finished)
		
		activeCount -= 1
		finishedCount += 1
		
		saveToDoItems()
	}
	
	func saveToDoItems() {
		guard let activeToDos = items[.active], let finishedToDos = items[.finished] else {
			return
		}
		
		let activeTodosData = NSKeyedArchiver.archivedData(withRootObject: activeToDos)
		let finishedTodosData = NSKeyedArchiver.archivedData(withRootObject: finishedToDos)
		
		UserDefaults.standard.set(activeTodosData, forKey: "activeTodos")
		UserDefaults.standard.set(finishedTodosData, forKey: "finishedTodos")
		UserDefaults.standard.set(activeCount, forKey: "activeCount")
		UserDefaults.standard.set(finishedCount, forKey: "finishedCount")
		UserDefaults.standard.synchronize()
	}
	
	func loadToDoItems() throws {
		guard let activeTodosData = UserDefaults.standard.object(forKey: "activeTodos") as? Data, let finishedTodosData = UserDefaults.standard.object(forKey: "finishedTodos") as? Data,
			let activeTodos = NSKeyedUnarchiver.unarchiveObject(with: activeTodosData) as? [ToDoItem],
			let finishedTodos = NSKeyedUnarchiver.unarchiveObject(with: finishedTodosData) as? [ToDoItem] else {
				throw RestoreDataError.loadDataFail
		}
		
		self.activeCount = UserDefaults.standard.integer(forKey: "activeCount")
		self.finishedCount = UserDefaults.standard.integer(forKey: "finishedCount")
		self.items = [.active: activeTodos, .finished: finishedTodos]
	}
}
