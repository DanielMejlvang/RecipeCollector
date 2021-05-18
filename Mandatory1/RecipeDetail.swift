//
//  RecipeDetail.swift
//  Mandatory1
//
//  Created by Daniel Mejlvang Rasmussen on 19/03/2021.
//

import Foundation
import UIKit
import WebKit
import Firebase

class RecipeDetail: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var webView: WKWebView!
    
    var parent_view_controller:ViewController? = nil
    var recipe = Recipe(recipeID: "", title: "", notes: "", urlString: "")
    var recipeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = recipe.title
        
        //check if recipe has notes
        //if not, put placeholder text in textview
        notesTextView.delegate = self
        if recipe.notes == "" {
            notesTextView.text = "Write a note for this recipe!"
            notesTextView.textColor = UIColor.lightGray
        } else {
            notesTextView.text = recipe.notes
        }
        
        self.webView.load(URLRequest(url: URL(string: recipe.urlString)!))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if notesTextView.text == "Write a note for this recipe!" {
            recipe.notes = ""
        } else {
            recipe.notes = notesTextView.text
        }
        fbs.saveRecipe(recipe: recipe)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a note for this recipe!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func trashButton(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "Delete recipe?", message: "Are you sure you want to delete this recipe?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            fbs.deleteRecipe(docID: self.recipe.recipeID, index: self.recipeIndex)
            self.parent_view_controller?.tableView.deleteRows(at: [IndexPath(row: self.recipeIndex, section: 0)], with: .automatic)
            self.dismiss(animated: true, completion: nil)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(deleteAlert, animated: true, completion: nil)
    }
}
