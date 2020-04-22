//
//  PhotoStruct.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/15/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import Foundation

struct Photo {
    var recipeName: String
    var image: UIImage

    init(recipeName: String, image: UIImage?) {
      self.recipeName = recipeName
      self.image = image ?? UIImage()
    }
}
