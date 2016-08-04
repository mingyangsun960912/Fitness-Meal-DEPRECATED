//
//  FavoriteRecipeObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class FavoriteRecipeObject: NSObject {
    var title:String
    var id:Int
    var image:UIImage
    var ingredients:[String]
    var steps:[String]
    var fat:String
    var protein:String
    var calories:String
    var carbs:String
    var servings:Int
    var readyInTime:Int
    init(title:String,id:Int,image:UIImage,ingredients:[String], steps:[String],fat:String,protein:String,calories:String,carbs:String,servings:Int,readyInTime:Int){
        self.title=title
        self.id=id
        self.image=image
        self.ingredients=ingredients
        self.steps=steps
        self.fat=fat
        self.protein=protein
        self.calories=calories
        self.carbs=carbs
        self.servings=servings
        self.readyInTime=readyInTime
    }
}
