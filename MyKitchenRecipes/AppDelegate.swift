//
//  AppDelegate.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 11/24/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    struct Ingredient: Codable {
        var id: Int
        var amount: Float
        var unit: String
        var name: String
        var image: String
    }
    
    struct RecipeSteps: Codable {
        var number: Int
        var step: String
    }
    
    struct Recipe: Codable {
        var id: Int
        var title: String
        var image: String
        var missedIngredients: [Ingredient]
        var usedIngredients: [Ingredient]
        var likes: Int
        var steps: [RecipeSteps]?
    }
    
    struct Recipes: Codable {
        var recipes: [Recipe] = []
    }

    func recipeEndpoint(ingredients: [String], completion:@escaping (Recipes)->Void) -> Void {
        if (!ingredients.isEmpty) {
            if let apiKey = ProcessInfo.processInfo.environment["apiKey"] {
                var components = URLComponents()
                components.scheme = "https"
                components.host = "api.spoonacular.com"
                components.path = "/recipes/findByIngredients"
                components.queryItems = [
                    URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
                    URLQueryItem(name: "apiKey", value: apiKey)
                ]
                guard let url = components.url else {
                    print("Error in creating URL")
                    return
                }
                let session = URLSession.shared
                var recipeList = Recipes()
                let task = session.dataTask(with: url) {data, response, error in
                    guard error == nil else {
                        print("Error in calling GET on \(url)")
                        return
                    }
                    guard let responseData = data else {
                        print("Error: did not receive data")
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            print("Error: HTTP Status \(httpResponse.statusCode) received")
                        } else {
                            do {
                                let decoder = JSONDecoder()
                                recipeList.recipes = try! decoder.decode(Array<Recipe>.self, from: responseData)

                            } catch {
                                print("Error decoding and parsing JSON data")
                                return
                            }
                        }
                    }
                }
                task.resume()
                print(recipeList.recipes)
            }
            print("Error: No API Key Found")
            return
        } else {
            print("Error: No Ingredients Provided")
            return
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

