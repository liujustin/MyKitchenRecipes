//
//  AnnotatedRecipePhotoCell.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/14/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit

class AnnotatedRecipePhotoCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var recipeName: UILabel!
    @IBOutlet private weak var missedIngredients: UILabel!
    
    var missingIngredients: Int? {
        didSet {
            if let missingIngredients = missingIngredients {
                if missingIngredients > 0 {
                    missedIngredients.backgroundColor = .red
                    missedIngredients.text = "Missing \(missingIngredients) ingredients"
                    missedIngredients.numberOfLines = 0
                    missedIngredients.lineBreakMode = .byWordWrapping
                    missedIngredients.textAlignment = .center
                } else {
                    missedIngredients.text = nil
                }
            }
        }
    }
    
    var photo: Photo? {
      didSet {
        if let photo = photo {
            imageView.image = photo.image
            recipeName.text = photo.recipeName
            recipeName.numberOfLines = 0
            recipeName.lineBreakMode = .byWordWrapping
            recipeName.textAlignment = .center
            recipeName.sizeToFit()
        }
      }
    }
}
