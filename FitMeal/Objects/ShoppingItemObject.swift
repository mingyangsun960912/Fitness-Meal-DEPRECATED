//
//  ShoppingItemObject.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/1/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class ShoppingItemObject: NSObject {
    var name:String
    var unit:String
    var number:String
    var note:String
    var priceEst:String
    init(name:String,number:String,unit:String,priceEst:String,note:String) {
        self.name=name
        self.unit=unit
        self.number=number
        self.note=note
        self.priceEst=priceEst
    }
}
