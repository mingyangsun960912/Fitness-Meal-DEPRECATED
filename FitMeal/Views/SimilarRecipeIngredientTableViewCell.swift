//
//  SimilarRecipeIngredientTableViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/29/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class SimilarRecipeIngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewOne: UIImageView!

    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var textViewOne: UITextView!
    @IBOutlet weak var textViewTwo: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
