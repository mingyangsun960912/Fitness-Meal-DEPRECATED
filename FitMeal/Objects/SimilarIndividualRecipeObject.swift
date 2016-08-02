//
//  SimilarIndividualRecipeObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/29/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class SimilarIndividualRecipeObject: NSObject {
    var fat:String
    var protein:String
    var calories:String
    var carbs:String
    var servings:Int
    var readyInTime:Int
    
    init(fat:String,protein:String, calories:String, carbs:String, servings:Int, readyInTime:Int){
        self.fat=fat
        self.protein=protein
        self.calories=calories
        self.carbs=carbs
        self.servings=servings
        self.readyInTime=readyInTime
        
    }
}
