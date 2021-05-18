//
//  MainTableView.swift
//  Mandatory1
//
//  Created by Daniel Mejlvang Rasmussen on 19/03/2021.
//

import UIKit

class MainTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbs.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        let object = fbs.recipes[indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }
    
    //methods which will be called when you interact with the table
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fbs.deleteRecipe(docID: fbs.recipes[indexPath.row].recipeID, index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
