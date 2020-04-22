//
//  APIManager.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/13/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class APIManager: NSObject {
    
    
    static let sharedInstance = APIManager()
    
    let URLScheme = "https"
    let baseURL = "api.spoonacular.com"
    let getRecipesByIngredientsEndpoint = "/recipes/findByIngredients"
    let getRecipesByIdEndpoint = "/recipes"
    let getRandomRecipesEndpoint = "/recipes/random"
    
    var searchedRecipes: [String: JSON] = [:]
    
    // Default Max Number of Recipes to return
    let numberOfRecipesToReturn = 20
    
    func getRandomRecipes(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
            var components = URLComponents()
            components.scheme = URLScheme
            components.host = baseURL
            components.path = getRandomRecipesEndpoint
            components.queryItems = [
                URLQueryItem(name: "number", value: "\(numberOfRecipesToReturn)"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            guard let url = components.url else {
                let urlError = "Error in creating URL"
                print(urlError)
                onFailure(MyError(msg: urlError))
                return
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
                if(error != nil){
                    onFailure(error!)
                } else{
                    do {
                        let result = try JSON(data: data!)
                        onSuccess(result)
                    } catch let error {
                        print("Error: \(error)")
                        onFailure(error)
                    }
                }
            })
            task.resume()
        } else {
            onFailure(MyError(msg: "Error: API Key not found"))
        }
    }
    
    func getRecipesByIngredients(ingredients: [String], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
            if !ingredients.isEmpty {
                var components = URLComponents()
                components.scheme = URLScheme
                components.host = baseURL
                components.path = getRecipesByIngredientsEndpoint
                components.queryItems = [
                    URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
                    URLQueryItem(name: "number", value: "\(numberOfRecipesToReturn)"),
                    URLQueryItem(name: "ranking", value: "1"),
                    URLQueryItem(name: "apiKey", value: apiKey)
                ]
                
                guard let url = components.url else {
                    let urlError = "Error in creating URL"
                    print(urlError)
                    onFailure(MyError(msg: urlError))
                    return
                }
                
                let session = URLSession.shared
                let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        onFailure(error!)
                    } else{
                        do {
                            let result = try JSON(data: data!)
                            onSuccess(result)
                        } catch let error {
                            print("Error: \(error)")
                            onFailure(error)
                            return
                        }
                    }
                })
                task.resume()
            }
        } else {
            onFailure(MyError(msg: "Error: API Key not found"))
        }
    }

    func getRecipeById(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        if let foundRecipe = searchedRecipes["\(id)"] {
            onSuccess(foundRecipe)
        } else {
            if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
                var components = URLComponents()
                components.scheme = URLScheme
                components.host = baseURL
                components.path = getRecipesByIdEndpoint + "/\(id)/information"
                components.queryItems = [
                    URLQueryItem(name: "apiKey", value: apiKey)
                ]
                
                guard let url = components.url else {
                    let urlError = "Error in creating URL"
                    print(urlError)
                    onFailure(MyError(msg: urlError))
                    return
                }
                
                let session = URLSession.shared
                let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        onFailure(error!)
                    } else{
                        do {
                            let result = try JSON(data: data!)
                            self.searchedRecipes["\(id)"] = result
                            onSuccess(result)
                        } catch let error {
                            print("Error: \(error)")
                            onFailure(error)
                            return
                        }
                    }
                })
                task.resume()
            } else {
                onFailure(MyError(msg: "Error: API Key not found"))
            }
        }
    }
    
}
