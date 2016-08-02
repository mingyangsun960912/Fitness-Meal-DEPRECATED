//
//  SimilarRecipeObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/27/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class SimilarRecipeObject: NSObject {
    var title:String
    var id:Int
    var imageURL:String
    var readyInMinutes:Int
    init(title:String,id:Int,imageURL:String,readyInMinutes:Int){
        self.title=title
        self.id=id
        self.imageURL=imageURL
        self.readyInMinutes=readyInMinutes
        
    }
    
}
