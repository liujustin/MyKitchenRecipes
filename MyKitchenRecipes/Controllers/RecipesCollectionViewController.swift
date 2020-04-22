//
//  RecipesCollectionViewController.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/13/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecipesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var recipes: [RecipeGeneral] = []
    var viewTitle: String = ""
    var recipePhotos: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.contentInset = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 10)
        self.title = viewTitle
        self.loadImages()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    func loadImages() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        self.view.isUserInteractionEnabled = false
        for recipe in recipes {
            let photoLink = recipe.image
            if var httpParkLink = URLComponents(string: photoLink) {
                httpParkLink.scheme = "https"
                if let httpsParkLink = httpParkLink.string {
                    do {
                        let data = try Data(contentsOf: URL(string: httpsParkLink)!)
                        recipePhotos.append(UIImage(data: data) ?? nil)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        myGroup.leave()
        myGroup.notify(queue: .main) {
            print("Image loading complete")
            self.view.isUserInteractionEnabled = true
        }
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedRecipePhotoCell", for: indexPath) as! AnnotatedRecipePhotoCell
        let recipeImage = recipePhotos[indexPath.row]
        
        cell.photo = Photo(recipeName: recipes[indexPath.row].name, image: recipeImage ?? nil)
        cell.missingIngredients = recipes[indexPath.row].missingIngredients
    
        return cell
    }
    
    func generateRecipeInfo(json: JSON) -> RecipeInfo {
        return RecipeInfo(id: json["id"].int!, name: json["title"].string!, image: json["image"].string!, servings: json["servings"].int ?? 0, preparationInMinutes: json["preparationMinutes"].int ?? 0, cookingInMinutes: json["cookingMinutes"].int ?? 0)
    }
    
    func generateRecipeIngredients(ingredientsArray: JSON) -> RecipeIngredients {
        var recipeIngredients: [RecipeIngredient] = []
        for(_, subJson): (String, JSON) in ingredientsArray {
            if let id = subJson["id"].int {
                if let description = subJson["originalString"].string {
                    recipeIngredients.append(RecipeIngredient(id: id, description: description))
                }
            }
        }
        return RecipeIngredients(ingredients: recipeIngredients)
    }
    
    func generateRecipeInstructions(instructionsArray: JSON) -> RecipeInstructions {
        var recipeInstructions: [RecipeInstructionStep] = []
        for(_, subJson): (String, JSON) in instructionsArray[0]["steps"] {
            if let stepNumber = subJson["number"].int {
                if let stepDescription = subJson["step"].string {
                    recipeInstructions.append(RecipeInstructionStep(stepNumber: stepNumber, stepDescription: stepDescription))
                }
            }
        }
        return RecipeInstructions(instructions: recipeInstructions)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecipeId = recipes[indexPath.item].id
        var recipeData: Recipe?
        let myGroup = DispatchGroup()
        myGroup.enter()
        self.loadingSpinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        APIManager.sharedInstance.getRecipeById(id: selectedRecipeId, onSuccess: { json in
            print(json)
            let recipeInfo = self.generateRecipeInfo(json: json)
            let recipeIngredients = self.generateRecipeIngredients(ingredientsArray: json["extendedIngredients"])
            let recipeInstructions = self.generateRecipeInstructions(instructionsArray: json["analyzedInstructions"])
            recipeData = Recipe(info: recipeInfo, ingredients: recipeIngredients, instructions: recipeInstructions)
            myGroup.leave()
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: "\(error). Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error)
            myGroup.leave()
        })
        myGroup.notify(queue: .main) {
            self.loadingSpinner.stopAnimating()
            self.performSegue(withIdentifier: "showDetailedRecipe", sender: recipeData)
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let detailedRecipe = segue.destination as? DetailedRecipeTableViewController {
            if let recipeDataInfo = sender as? Recipe {
                detailedRecipe.recipe = recipeDataInfo
                detailedRecipe.viewTitle = recipeDataInfo.info.name
            }
        }
    }

}
