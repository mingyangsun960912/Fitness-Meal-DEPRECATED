//
//  FavoriteRecipeObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteRecipeObject: Object {
    dynamic var title=""
    dynamic var id=0
    dynamic var image:String=""
    dynamic var ingredients:String=""
    dynamic var steps:String=""
    dynamic var fat:String=""
    dynamic var protein:String=""
    dynamic var calories:String=""
    dynamic var carbs:String=""
    dynamic var servings:Int=0
    dynamic var readyInTime:Int=0
    
  
 
}
