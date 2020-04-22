//
//  RecipeInfoTableViewCell.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/14/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit

class RecipeInfoTableViewCell: UITableViewCell {
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var servings: UILabel!
    @IBOutlet var preparationInMinutes: UILabel!
    @IBOutlet var cookingInMinutes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
