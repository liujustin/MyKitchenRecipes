//
//  IngredientsTableViewController.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/7/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class IngredientsTableViewController: UITableViewController, UITextFieldDelegate {

    var ingredientsList: [Ingredient] = []
    var recipeGeneralList: [RecipeGeneral] = []
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBAction func addIngredient(_ sender: Any) {
        addIngredientInTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.placeholder = "Ingredient Name"
        addSearchButtonView()
        tableView.keyboardDismissMode = .onDrag
        self.ingredientTextField.delegate = self
    }
    
    func addIngredientInTextField() {
        if ingredientTextField.text != nil && ingredientTextField.text != "" {
            let ingredientName = ingredientTextField.text
            if !ingredientsList.contains(where: {$0.name == ingredientName}) {
                let newIngredient = Ingredient(name: ingredientName!)
                // Add ingredient to the end of the list and update the table view to reflect changes
                ingredientsList.append(newIngredient)
                ingredientTextField.text = nil
                tableView.beginUpdates()
                let currentIndex = ingredientsList.count - 1 > 0 ? ingredientsList.count - 1 : 0
                tableView.insertRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        addIngredientInTextField()
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredientsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = ingredientsList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           self.ingredientsList.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func addSearchButtonView() {
        let searchButton = UIButton()

        searchButton.backgroundColor = .green
        searchButton.setTitle("Search", for: .normal)
        tableView.addSubview(searchButton)

        // set position
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.widthAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    @objc func searchAction(sender: UIButton!) {
        if ingredientsList.isEmpty {
            let alert = UIAlertController(title: "Warning", message: "Please add an ingredient before searching", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            sender.isEnabled = false
            sender.backgroundColor = .systemBlue
            sender.setTitle("Loading...", for: .disabled)
            let ingredients = ingredientsList.map{$0.name}
            let myGroup = DispatchGroup()
            myGroup.enter()
            APIManager.sharedInstance.getRecipesByIngredients(ingredients: ingredients, onSuccess: { json in
                for (index, subJson):(String, JSON) in json {
                    DispatchQueue.main.async {
                        sender.setTitle("Loading... (\(index)/\(json.count)", for: .disabled)
                    }
                    self.recipeGeneralList.append(RecipeGeneral(id: subJson["id"].int!, name: subJson["title"].string!, image: subJson["image"].string!, missingIngredients: subJson["missedIngredientCount"].int!))
                }
                myGroup.leave()
            }, onFailure: { error in
                sender.isEnabled = true
                sender.backgroundColor = .green
                sender.setTitle("Search", for: .normal)
                let alert = UIAlertController(title: "Error", message: "\(error). Please try again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                myGroup.leave()
            })
            myGroup.notify(queue: .main) {
                if !self.recipeGeneralList.isEmpty {
                    self.performSegue(withIdentifier: "showRecipesSegue", sender: nil)
                    self.recipeGeneralList = []
                }
                sender.backgroundColor = .green
                sender.setTitle("Search", for: .normal)
                sender.isEnabled = true
            }
        }
    }
    
    func sortRecipeListByMissedIngredients() {
        self.recipeGeneralList.sort(by: {$0.missingIngredients < $1.missingIngredients})
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let recipeGeneralCollection = segue.destination as? RecipesCollectionViewController {
            sortRecipeListByMissedIngredients()
            recipeGeneralCollection.recipes = self.recipeGeneralList
            recipeGeneralCollection.viewTitle = "Found Recipes"
        }
    }

}
