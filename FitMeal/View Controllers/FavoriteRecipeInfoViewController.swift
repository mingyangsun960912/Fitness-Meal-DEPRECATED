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
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var readyInTimeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var vitaminALabel: UILabel!
    @IBOutlet weak var vitaminCLabel: UILabel!
    @IBOutlet weak var vitaminBOneLabel: UILabel!
    @IBOutlet weak var vitaminBSixLabel: UILabel!
    @IBOutlet weak var vitaminELabel: UILabel!
    @IBOutlet weak var vitaminKLabel: UILabel!
    
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var fiberLabel: UILabel!
    @IBOutlet weak var saturatedLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var choLabel: UILabel!
    @IBOutlet weak var calciumLabel: UILabel!
    @IBOutlet weak var ironLabel: UILabel!
    @IBOutlet weak var zincLabel: UILabel!
    @IBOutlet weak var potassiumLabel: UILabel!
    
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var stepTableView: UITableView!
    
    var titleOfRecipe:String=""
    var idOfRecipe:Int=0
    var image:String=""
    var ingredients:String=""
    var steps=""
    var fat = ""
    var protein=""
    var calories=""
    var carbs=""
    var servings=0
    var readyInTime=0
    var sugar:String=""
    var fiber:String=""
    var saturatedFat:String=""
    var sodium:String=""
    var cholesterol:String=""
    var calcium:String=""
    var iron:String=""
    var zinc:String=""
    var potassium:String=""
    var vitaminA:String=""
    var vitaminC:String=""
    var vitaminB1:String=""
    var vitaminB6:String=""
    var vitaminE:String=""
    var vitaminK:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIScreen.mainScreen().bounds.height==568){
            let fontForLabel=UIFont(name:"Gill Sans",size:15.0)
            readyInTimeLabel.font=fontForLabel
            servingLabel.font=fontForLabel
            caloriesLabel.font=fontForLabel
            let font=UIFont(name:"Times New Roman",size:15.0)
            proteinLabel.font=font
            carbsLabel.font=font
            fatLabel.font=font
            saturatedLabel.font=font
            sugarLabel.font=font
            fiberLabel.font=font
            sodiumLabel.font=font
            choLabel.font=font
            calciumLabel.font=font
            ironLabel.font=font
            zincLabel.font=font
            potassiumLabel.font=font
            vitaminALabel.font=font
            vitaminBOneLabel.font=font
            vitaminCLabel.font=font
            vitaminBSixLabel.font=font
            vitaminELabel.font=font
            vitaminKLabel.font=font
            
            
        }

        likeButton.selected=true
        let imageURL=image
        self.RecipeImageVIew.sd_setImageWithURL(NSURL(string:imageURL),placeholderImage:nil)
        self.shadowView.layer.shadowOffset=CGSize(width:2, height: 3)
        self.shadowView.layer.shadowOpacity=0.8
  
        self.ingredientTableView.dataSource=self
        self.ingredientTableView.delegate=self
        self.stepTableView.dataSource=self
        self.stepTableView.delegate=self
        titleLabel.text=titleOfRecipe
        let attr = NSDictionary(object: UIFont(name: "American Typewriter", size: 13.0)!, forKey: NSFontAttributeName)
        infoSegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
  
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        caloriesLabel.text=calories
        proteinLabel.text=protein
        fatLabel.text=fat
        servingLabel.text="  "+String(servings)+" servings"
        readyInTimeLabel.text="  "+String(readyInTime)+" mins"
        carbsLabel.text=carbs
        sugarLabel.text=sugar
        fiberLabel.text=fiber
        saturatedLabel.text=saturatedFat
        sodiumLabel.text=sodium
        choLabel.text=cholesterol
        calciumLabel.text=calcium
        potassiumLabel.text=potassium
        ironLabel.text=iron
        zincLabel.text=zinc
        vitaminALabel.text=vitaminA
        vitaminCLabel.text=vitaminC
        vitaminBOneLabel.text=vitaminB1
        vitaminBSixLabel.text=vitaminB6
        vitaminELabel.text=vitaminE
        vitaminKLabel.text=vitaminK
        
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
                let destination = segue.destinationViewController as! FavoriteRecipeViewController
                destination.searchActive=false
               
                
            }
        }
    }
    func trashWarning(){
        let warnAlertController=UIAlertController(title:"Destroy Forever", message: "You won't see this recipe ever again, are you sure you want to completely destroy it?",preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction=UIAlertAction(title:"Yes", style:UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.trashButton.selected=true
            let dislikeObject=DislikeIDObject()
            dislikeObject.dislikeID=self.idOfRecipe
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
        let id:Int=idOfRecipe
        likeObject.likeID=id
        RealmHelperClass.addLikeID(likeObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
        InformationInputViewController.likeIDsList.append(id)

        let newFavoriteRecipe=FavoriteRecipeObject()
        newFavoriteRecipe.title=titleOfRecipe
        newFavoriteRecipe.id=id
        newFavoriteRecipe.image=image
        newFavoriteRecipe.ingredients=ingredients
        newFavoriteRecipe.steps=steps
        newFavoriteRecipe.fat=fat
        newFavoriteRecipe.protein=protein
        newFavoriteRecipe.calories=calories
        newFavoriteRecipe.carbs=carbs
        newFavoriteRecipe.servings=servings
        newFavoriteRecipe.readyInTime=readyInTime
        newFavoriteRecipe.sugar=self.sugar
        newFavoriteRecipe.saturatedFat=self.saturatedFat
        newFavoriteRecipe.calcium=self.calcium
        newFavoriteRecipe.cholesterol=self.cholesterol
        newFavoriteRecipe.zinc=self.zinc
        newFavoriteRecipe.iron=self.iron
        newFavoriteRecipe.sodium=self.sodium
        newFavoriteRecipe.potassium=self.potassium
        newFavoriteRecipe.vitaminE=self.vitaminE
        newFavoriteRecipe.vitaminA=self.vitaminA
        newFavoriteRecipe.vitaminC=self.vitaminC
        newFavoriteRecipe.vitaminK=self.vitaminK
        newFavoriteRecipe.vitaminB6=self.vitaminB6
        newFavoriteRecipe.vitaminB1=self.vitaminB1
        newFavoriteRecipe.fiber=self.fiber
        RealmHelperClass.addFavoriteRecipe(newFavoriteRecipe)
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        //        FavoriteRecipeViewController.favorites.append(newLikeItem!)
        
        


    }
    func unlikeFunction(){
        likeButton.selected=false
        let realm = try! Realm()
        let unlikeId=idOfRecipe
        let unlikeIDObject = realm.objects(LikeIDObject).filter("likeID = \(unlikeId)")
        
        RealmHelperClass.deleteLikeID(unlikeIDObject)
        let unlikeItem=realm.objects(FavoriteRecipeObject).filter("id=\(unlikeId)")
        RealmHelperClass.deleteFavoriteRecipe(unlikeItem)
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
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
        let untrashIDObject = realm.objects(DislikeIDObject).filter("dislikeID = \(idOfRecipe)")
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
            let stepsArray=steps.componentsSeparatedByString("||")
            cellNumber=stepsArray.count
        }else if(tableView==self.ingredientTableView){
            let ingredientArray=ingredients.componentsSeparatedByString("||")
            if(ingredientArray.count % 2 == 0){
                cellNumber=ingredientArray.count/2
            }else{
                cellNumber=ingredientArray.count/2+1
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
            stepViewCell.stepDescript.text=""
            let stepsArray=steps.componentsSeparatedByString("||")
            stepViewCell.stepDescript.text = stepsArray[indexPath.row]
            stepViewCell.selectionStyle = .None
            return stepViewCell
        }
        if(tableView==self.ingredientTableView){
            let ingredientCell=tableView.dequeueReusableCellWithIdentifier("ingredientListCell") as! FavoriteRecipeIngredientTableViewCell
            let row=indexPath.row
             let ingredientsArray=ingredients.componentsSeparatedByString("||")
            let ingredientDescriptionOne=ingredientsArray[row*2]
            ingredientCell.ingredientFirstLabel.text=""
            ingredientCell.ingredientFirstLabel.text=ingredientDescriptionOne
           
            if(row*2+1<=ingredientsArray.count-1){
           let ingredientDescriptionTwo=ingredientsArray[row*2+1]
            ingredientCell.ingredientSecondLabel.text=""
            ingredientCell.ingredientSecondLabel.text=ingredientDescriptionTwo
                
            }
            return ingredientCell
        }
        return cell!
    }
}


