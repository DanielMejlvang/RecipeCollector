//
//  Recipe.swift
//  Mandatory1
//
//  Created by Daniel Mejlvang Rasmussen on 19/03/2021.
//

import Foundation

class Recipe {
    var recipeID: String
    var title: String
    var notes: String
    var urlString: String
    
    init(recipeID: String, title: String, notes: String, urlString: String) {
        self.recipeID = recipeID
        self.title = title
        self.notes = notes
        self.urlString = urlString
    }
}
