//
//  ViewController.swift
//  Checked
//
//  Created by Roman Subrychak on 2/6/18.
//  Copyright © 2018 Roman Subrychak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var dataSource: ToDoItemsDataSource!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "ToDos"
		
		tableView.delegate = self
	}
	
	
	@IBAction func addToDoTapped(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add ToD", message: nil,
									  preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = "Description"
		}

		let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
			guard let itemDescription = alert.textFields?[0].text else { return }

			let toDo = ToDoItem(itemDescription: itemDescription)

			self.tableView.beginUpdates()
			self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
									  with: .automatic)
			self.dataSource.itemManager.add(item: toDo)
			self.tableView.endUpdates()
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		alert.addAction(addAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true, completion: nil)
	}
}
	

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		var contextualActions = [UIContextualAction]()
		
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
			[unowned self] (action, view, completionHandler) in
			
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			self.dataSource.itemManager.remove(from:
				Status(rawValue: indexPath.section)!, at: indexPath.row)
			tableView.endUpdates()

			completionHandler(true)
		}
		
		contextualActions.append(deleteAction)
		
		if let section = Status(rawValue: indexPath.section),
			section == .active {
			
			let checkAction = UIContextualAction(style: .normal, title: "✓") {
				[unowned self] (action, view, completionHandler) in
				
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .fade)
				self.dataSource.itemManager.checkItem(at: indexPath.row)
				let newIndexPath = IndexPath(row: 0, section: 1)
				tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.automatic)
				tableView.endUpdates()
				
				completionHandler(true)
			}
			checkAction.backgroundColor = .green
			
			contextualActions.append(checkAction)
		}
		return UISwipeActionsConfiguration(actions: contextualActions)
	}
}
