//
//  DisplayRecipeViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/20/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class DisplayRecipeViewController: UIViewController {
    
 
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UITextView!
    @IBOutlet weak var cookMinutesLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    var image:UIImage!
    var titleForRecipe:String!
    var fat:String!
    var calories:String!
    var carbs:String!
    var protein:String!
    var servings:Int!
    var readyTime:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRecipe()
        resizeTextView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func resizeTextView(){
        let fixedWidth = recipeTitle.frame.size.width
        recipeTitle.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = recipeTitle.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = recipeTitle.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        recipeTitle.frame = newFrame;

    }
    
    func showRecipe(){
       recipeImageView.image=image
//        recipeTitle.text=recipeInfo!.title
        recipeTitle.text=titleForRecipe
        caloriesLabel.text=calories
        carbsLabel.text=carbs
        proteinLabel.text=protein
        fatLabel.text=fat
        servingLabel.text=String(servings)+" people"
        cookMinutesLabel.text=String(readyTime)+" minutes"
        
          }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
