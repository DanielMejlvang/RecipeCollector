//
//  FirebaseService.swift
//  Mandatory1
//
//  Created by Daniel Mejlvang Rasmussen on 19/03/2021.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService {
    private var db = Firestore.firestore()
    
    var recipes = [Recipe]()
    private var collectionPath = "recipes"
    var storage = Storage.storage()
    var storageRef:StorageReference?
    
    var parent:Updatable?
    
    func startListener() {
        //listen to changes to collection -> get entire updated collection
        db.collection(collectionPath).addSnapshotListener { (snap, error) in
            if let e = error {
                print("Error in fetching data: \(e)")
            } else {
                if let s = snap {
                    self.recipes.removeAll()
                    for doc in s.documents {
                        //create Recipe and put into array
                        let recipeID = doc.documentID
                        let title = doc.data()["title"] as? String ?? "No title found"
                        let notes = doc.data()["notes"] as? String ?? "No notes found"
                        let urlString = doc.data()["urlString"] as? String ?? "No url found"
                        let recipe = Recipe(recipeID: recipeID , title: title, notes: notes, urlString: urlString)
                        self.recipes.append(recipe)
                    }
                    self.parent?.update(obj: nil)
                }
            }
        }
    }
    
    func saveRecipe(recipe: Recipe) {
        let doc = db.collection(collectionPath).document(recipe.recipeID)
        var data = [String:String]()
        data["title"] = recipe.title
        data["notes"] = recipe.notes
        data["urlString"] = recipe.urlString
        doc.setData(data)
    }
    
    func addRecipe(url: String) {
        let array = url.components(separatedBy: "/")
        let title = array[3].replacingOccurrences(of: "-", with: " ").capitalizingFirstLetter()
        
        let doc = db.collection(collectionPath).document()
        var data = [String:String]()
        data["title"] = title
        data["notes"] = ""
        data["urlString"] = "https://www.justtherecipe.app/recipe?url=" + url
        doc.setData(data)
    }
    
    func deleteRecipe(docID: String, index: Int) {
        db.collection(collectionPath).document(docID).delete() { err in
            if let e = err {
                print("Error deleting: \(e)")
            } else {
                print("OK delete")
            }
        }
        self.recipes.remove(at: index)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
