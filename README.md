# MyKitchenRecipes
Find recipes for ingredients you have in your kitchen with the least amount of missing ingredients you need to purchase.

## Video of MyKitchenRecipes in action
https://drive.google.com/file/d/1Z_7EfE8oA9VxcJrhH7kZ1HQxmk3qs6ih/view

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What you need to have before being able to use this project.

* [Python 2.7](https://www.python.org)
* [Flask](http://flask.pocoo.org)
* [Virtualenv](https://virtualenv.pypa.io/)
* [Virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/)
* [MySQL](https://www.mysql.com)

### Installing

A step by step series of examples that tell you have to get a development env running

To get started, open a terminal window and run the following commands:

```bash
git clone git@github.com:liujustin/MyKitchenRecipes.git
```

After doing so you should have a copy of the repo in whatever directory you chose to clone it in. The folder name should be `MyKitchenRecipes`

```bash
cd MyKitchenRecipes
```

**Before continuing, ensure that you have installed [CocoaPods](https://cocoapods.org/) as the project is reliant on some Pods. If not, the instructions on how to do so are located at https://cocoapods.org/**

Go/CD into the folder and run `pod install` to install the pods.. 

Once you are done with that, instead of opening `.xcodeproj`, open `.xcworkspace` instead so that you can view the project and also install it to your phone/simulator.

If you don't know how XCode is laid out, I suggest that you read up on how to build and run the app. Here's a good tutorial on [Apple's site](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/BuildingYourApp.html):

https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/BuildingYourApp.html.

In addition, as this project is using the [Spoonacular API](https://spoonacular.com/food-api) please make sure that you get an API Key before proceeding.

Take that API Key that you got from [Spoonacular API](https://spoonacular.com/food-api) and put it inside the scheme when you run the app. It should be located in Product -> Edit Scheme -> Run -> Arguments -> Environment Variables    Like so:

![Edit Scheme -> Add API Key](https://i.imgur.com/G8tVYEc.png)

## Built With

* [Swift](https://developer.apple.com/swift/)
* [Spoonacular API](https://spoonacular.com/food-api)
* [Xcode](https://developer.apple.com/xcode/)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Versioning

I used [Git](https://git-scm.com) for versioning. Everything was pushed to [GitHub](https://github.com) 

## Authors

* **Justin Liu** - [LinkedIn](https://www.linkedin.com/in/imjustliu/)  [GitHub](https://github.com/liujustin)

## Features:
- [X] Beautiful grid layout
- [X] View a catalog of random recipes
- [X] Input ingredients into a list
- [X] Delete ingredients from a list
- [X] View an image of the final product for a recipe
- [X] See preperation/cooking time for a recipe
- [X] See how many servings in each recipe
