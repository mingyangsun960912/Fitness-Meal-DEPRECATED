//
//  FavoriteRecipeIngredientTableViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class FavoriteRecipeIngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientFirstLabel: UILabel!

    @IBOutlet weak var ingredientSecondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
