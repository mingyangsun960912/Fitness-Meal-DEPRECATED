//
//  ShoppingListTableViewCell.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/1/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import PopupDialog
class ShoppingListTableViewCell: UITableViewCell {
    var viewController:ShoppingListViewController?
    var item:ShoppingItemObject?
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    @IBAction func checkButtonTapped(sender: UIButton) {
        if(checkButton.selected){
            checkButton.selected=false
            
        }else{
            checkButton.selected=true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func edit(sender: UIButton) {
        showCustomDialog()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        func showCustomDialog() {
    
            // Create a custom view controller
            let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
             ratingVC.name=item!.name
            
            ratingVC.quantityString=item!.number
            ratingVC.note=item!.note
            ratingVC.unit=item!.unit
            ratingVC.priceEstString=item!.priceEst
        
            // Create the dialog
            let popup = PopupDialog(viewController: ratingVC, transitionStyle: .ZoomIn, buttonAlignment: .Horizontal, gestureDismissal: false)
    
            // Create first button
            let buttonOne = CancelButton(title: "CANCEL") {
    
            }
    
            // Create second button
            let buttonTwo = DefaultButton(title: "SAVE") {
                self.item!.name=ratingVC.nameTextField.text!
                self.item!.number=ratingVC.quantityTextField.text!
                self.item!.unit=ratingVC.unitTextField.text!
                self.item!.note=ratingVC.noteTextView.text
                self.item!.priceEst=ratingVC.priceEstTextField.text!
                self.itemLabel.text = self.item!.name
               
            }
    
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
    
            // Present dialog
             viewController!.presentViewController(popup, animated: true, completion: nil)
        }

}
