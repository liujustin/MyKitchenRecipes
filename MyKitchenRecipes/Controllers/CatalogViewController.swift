//
//  CatalogViewController.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/15/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class CatalogViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    
    var randomRecipeGeneralList: [RecipeGeneral] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let myGroup = DispatchGroup()
        myGroup.enter()
        loadingSpinner.startAnimating()
        loadingText.text = "Recipes Loading"
        APIManager.sharedInstance.getRandomRecipes(onSuccess: { json in
            for (_, subJson):(String, JSON) in json["recipes"] {
                print(subJson)
                if let id = subJson["id"].int {
                    if let name = subJson["title"].string {
                        if let image = subJson["image"].string {
                            self.randomRecipeGeneralList.append(RecipeGeneral(id: id, name: name, image: image, missingIngredients: 0))
                        }
                    }
                }
            }
            myGroup.leave()
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: "\(error). Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            myGroup.leave()
        })
        myGroup.notify(queue: .main) {
            self.performSegue(withIdentifier: "visualizeRecipes", sender: nil)
            self.loadingSpinner.stopAnimating()
            self.loadingText.text = ""
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let recipeGeneralCollection = segue.destination as? RecipesCollectionViewController {
            recipeGeneralCollection.recipes = self.randomRecipeGeneralList
            recipeGeneralCollection.navigationItem.setHidesBackButton(true, animated: true)
            recipeGeneralCollection.viewTitle = "Recipes Catalog"
        }
    }

}
