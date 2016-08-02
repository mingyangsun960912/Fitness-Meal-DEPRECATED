//
//  IngredientListViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/22/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class IngredientListViewCell: UITableViewCell {
    @IBOutlet weak var ingredientImageViewOne: UIImageView!
    @IBOutlet weak var ingredientImageViewTwo: UIImageView!

 
    @IBOutlet weak var descriptionTextViewTwo: UITextView!
    @IBOutlet weak var descriptionTextViewOne: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
