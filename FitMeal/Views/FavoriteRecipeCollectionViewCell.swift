//
//  FavoriteRecipeCollectionViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class FavoriteRecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    var title:String=""
    var image:UIImage?
    var id:Int=0
    var ingredients:[String]=[]
    var steps:[String]=[]
    var fat:String=""
    var protein:String=""
    var calories:String=""
    var carbs:String=""
    var servings:Int=0
    var readyInTime:Int=0
    
}
