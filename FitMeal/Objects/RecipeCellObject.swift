//
//  RecipeCellObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/18/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Foundation

class RecipeCellObject: NSObject {
    var title=""
  
    var image=""
    var fat=""
    var calories=""
    var protein=""
    var carbs=""
    var id:Int?
    var readyMinutes:Int?
    var servings:Int?
    var missedIngredientsCount:Int?

    
    init(title:String, fat:String, calories:String, protein:String, carbs:String, image:String, id:Int!, readyMinutes:Int!, servings:Int!,missedIngredientsCount:Int!) {
        self.title=title
   
        self.fat=fat
        self.calories=calories
        self.protein=protein
        self.carbs=carbs
        self.image=image
        self.id=id
        self.servings=servings
        self.readyMinutes=readyMinutes
        self.missedIngredientsCount=missedIngredientsCount

        
    }
    
    
}
