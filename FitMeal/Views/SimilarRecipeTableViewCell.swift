//
//  SimilarRecipeTableViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/27/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class SimilarRecipeTableViewCell: UITableViewCell {
   
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var similarRecipeImageView: UIImageView!
    var idOfRecipe:Int!
    var imageUrl:String=""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recipeNameLabel.backgroundColor=UIColor.blackColor().colorWithAlphaComponent(0.5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
