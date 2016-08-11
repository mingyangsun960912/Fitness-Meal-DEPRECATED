//
//  RecipeListViewCellTableViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/18/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class RecipeListViewCellTableViewCell: UITableViewCell {
    @IBOutlet weak var recipePicImageView: UIImageView!
    
    @IBOutlet weak var recipeTitleTextView: UITextView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
  
    @IBOutlet weak var fatLabel: UILabel!
    var servings:Int?
    var readyMinutes:Int?
    var missedIngredientsCount:Int?
    var missedIngredients:String?
    var idOfRecipe:Int?
    var imageURL:String=""
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.recipeTitleTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        self.recipePicImageView.layer.borderWidth=2
        self.recipePicImageView.layer.borderColor=UIColor.whiteColor().CGColor
           self.recipePicImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.recipePicImageView.layer.shadowOpacity = 0.7
            self.recipePicImageView.layer.shadowRadius = 2
            
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
