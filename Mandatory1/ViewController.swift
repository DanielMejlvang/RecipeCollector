//
//  ViewController.swift
//  Recipe Collector
//
//  Created by Daniel Mejlvang Rasmussen on 19/03/2021.
//

import UIKit
import WebKit

let fbs = FirebaseService()
var dataSource = MainTableView()

class ViewController: UIViewController, Updatable, WKNavigationDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = dataSource
        self.webView.navigationDelegate = self
        
        fbs.parent = self
        fbs.storageRef = fbs.storage.reference()
        fbs.startListener()
    }

    var ip = IndexPath()
    func update(obj: NSObject?) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? RecipeDetail{
            let recipeIndex = tableView.indexPathForSelectedRow?.row ?? 0
            ip = tableView.indexPathForSelectedRow!
            dest.recipe = fbs.recipes[recipeIndex]
            dest.recipeIndex = recipeIndex
            dest.parent_view_controller = self
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBAction func clickedbutton(_ sender: UIButton) {
        print("hello")
    }
    
    @IBAction func searchForRecipe(_ sender: UIButton) {
        if var query = searchField.text {
            query = query.replacingOccurrences(of: " ", with: "+")
            let url = URL(string: "https://www.valdemarsro.dk/soeg/?terms=&terms2=&q=" + query + "&q2=")!
            self.webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if !webView.url!.absoluteString.contains("soeg") && !webView.url!.absoluteString.contains("wikimedia") {
            fbs.addRecipe(url: webView.url!.absoluteString)
            self.webView.load(URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Checkmark_green.svg/277px-Checkmark_green.svg.png")!))
        }
    }
}
