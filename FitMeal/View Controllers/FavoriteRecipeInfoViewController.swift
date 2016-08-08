//
//  FavoriteRecipeInfoViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteRecipeInfoViewController: UIViewController,UITableViewDelegate {
    var favoriteRecipe:FavoriteRecipeObject?

    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var infoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var RecipeImageVIew: UIImageView!
    @IBOutlet weak var summaryView: UIView!
    //MARK:summaryView Labels
    
    @IBOutlet weak var readyInTimeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var stepTableView: UITableView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButton.selected=true
        self.RecipeImageVIew.image=favoriteRecipe?.image
        self.ingredientTableView.dataSource=self
        self.ingredientTableView.delegate=self
        self.stepTableView.dataSource=self
        self.stepTableView.delegate=self
        titleLabel.text=favoriteRecipe!.title
  
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        caloriesLabel.text=favoriteRecipe!.calories
        proteinLabel.text=favoriteRecipe!.protein
        fatLabel.text=favoriteRecipe!.fat
        servingLabel.text=String(favoriteRecipe!.servings)+" people"
        readyInTimeLabel.text=String(favoriteRecipe!.readyInTime)+" minutes"
        carbsLabel.text=favoriteRecipe!.carbs
        self.ingredientTableView.hidden=true
        self.stepTableView.hidden=true
    }
    @IBAction func segmentedControlSelected(sender: UISegmentedControl) {
        showDifferentInfo()
    }
    
    func showDifferentInfo(){
        switch infoSegmentedControl.selectedSegmentIndex{
        case 0:
            
            self.summaryView.hidden=false
            self.stepTableView.hidden=true
            self.ingredientTableView.hidden=true
            
        case 1:
            self.summaryView.hidden=true
            self.stepTableView.hidden=true
            self.ingredientTableView.hidden=false
            
        case 2:
            self.summaryView.hidden=true
            self.stepTableView.hidden=false
            self.ingredientTableView.hidden=true
            self.stepTableView.reloadData()
            self.ingredientTableView.reloadData()
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        if(likeButton.selected==true){
            unlikeFunction()
        }else{
            if(trashButton.selected==true){
                likeFunction()
                untrashFunction()
            }
            likeFunction()
        }
        
    }
    
    
    @IBAction func trashButtonTapped(sender: UIButton) {
        
        if(trashButton.selected==true){
            untrashFunction()
        }else{
            if(likeButton.selected==true){
                unlikeFunction()
                trashFunction()
            }
            trashFunction()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toFavoriteCollectionViewController" {
                print("Cancel button tapped")
            }
        }
    }
    func trashWarning(){
        let warnAlertController=UIAlertController(title:"Destroy Forever", message: "You won't see this recipe ever again, are you sure you want to completely destroy it?",preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction=UIAlertAction(title:"Yes", style:UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.trashButton.selected=true
            let dislikeObject=DislikeIDObject()
            dislikeObject.dislikeID=self.favoriteRecipe!.id
            RealmHelperClass.addDislikeID(dislikeObject)
            InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
            self.performSegueWithIdentifier("toFavoriteCollectionViewController", sender: self)
        })
        let cancelAction=UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Default,handler:nil)
        warnAlertController.addAction(yesAction)
        warnAlertController.addAction(cancelAction)
        
        
        self.presentViewController(warnAlertController, animated: true, completion: nil)
    }
    func likeFunction(){
        likeButton.selected=true
        let likeObject=LikeIDObject()
        likeObject.likeID=favoriteRecipe!.id
        RealmHelperClass.addLikeID(likeObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
    }
    func unlikeFunction(){
        likeButton.selected=false
        let realm = try! Realm()
        let unlikeIDObject = realm.objects(LikeIDObject).filter("likeID = \(favoriteRecipe!.id)")
        RealmHelperClass.deleteLikeID(unlikeIDObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
//        if let index=FavoriteRecipeViewController.likeID.indexOf((favoriteRecipe?.id)!){
//            FavoriteRecipeViewController.likeID.removeAtIndex(index)
//        }
    }
    func trashFunction(){
        trashWarning()
    }
    func untrashFunction(){
        trashButton.selected=false
        let realm=try! Realm()
        let untrashIDObject = realm.objects(DislikeIDObject).filter("dislikeID = \(favoriteRecipe!.id)")
        RealmHelperClass.deleteDislikeID(untrashIDObject)
        InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
//        if let index=FavoriteRecipeViewController.dislikeID.indexOf((favoriteRecipe?.id)!){
//            FavoriteRecipeViewController.dislikeID.removeAtIndex(index)
//        }
//    }
    
    
}
}

extension FavoriteRecipeInfoViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNumber:Int=0
        if(tableView==self.stepTableView){
            cellNumber=(favoriteRecipe?.steps)!.count
        }else if(tableView==self.ingredientTableView){
            if((favoriteRecipe?.ingredients)!.count % 2 == 0){
                cellNumber=(favoriteRecipe?.ingredients)!.count/2
            }else{
                cellNumber=(favoriteRecipe?.ingredients)!.count/2+1
            }
        }
        return cellNumber
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if(tableView==self.stepTableView){
            let stepViewCell = tableView.dequeueReusableCellWithIdentifier("stepListCell",
                                                                           forIndexPath: indexPath) as! SimilarRecipeStepTableViewCell
            
            stepViewCell.stepDescript.text = (favoriteRecipe?.steps[indexPath.row])!
            stepViewCell.selectionStyle = .None
            return stepViewCell
        }
        if(tableView==self.ingredientTableView){
            let ingredientCell=tableView.dequeueReusableCellWithIdentifier("ingredientListCell") as! FavoriteRecipeIngredientTableViewCell
            let row=indexPath.row
            let ingredientDescriptionOne=(favoriteRecipe?.ingredients[row*2])!
            ingredientCell.ingredientFirstLabel.text=ingredientDescriptionOne
           
            if(row*2+1<=favoriteRecipe!.ingredients.count-1){
           let ingredientDescriptionTwo=favoriteRecipe!.ingredients[row*2+1]
            ingredientCell.ingredientSecondLabel.text=ingredientDescriptionTwo
                
            }
            return ingredientCell
        }
        return cell!
    }
}


