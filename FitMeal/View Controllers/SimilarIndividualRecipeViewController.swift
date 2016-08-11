//
//  SimilarIndividualRecipeViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/29/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
class SimilarIndividualRecipeViewController: UIViewController, UITableViewDelegate
{
    
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
    var idOfRecipe:Int?
    var image:UIImage?
    var imageurl:String?
    var nameArray:[String]=[]
    var imageArray:[String]=[]
    var numberStringArray:[String]=[]
    var stepsStringArray:[String]=[]
    var originalStringArray:[String]=[]
     var cellObjects:[StepCellObject]=[]
      var stepsResult:[String]=[]
    var titleOfRecipe:String=""
    var servings:Int?
    var readyMinutes:Int?
    var fat:String?
    var calories:String?
    var carbs:String?
    var protein:String?
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        ]
    var newLikeObject:FavoriteRecipeObject?
    var returnToLast:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        if(InformationInputViewController.likeIDsList.contains(idOfRecipe!)){
            likeButton.selected=true
        }else{
            likeButton.selected=false
        }
        if(InformationInputViewController.dislikeIDsList.contains(idOfRecipe!)){
            trashButton.selected=true
        }else{
            trashButton.selected=false
        }
//        if(FavoriteRecipeViewController.likeID.contains(idOfRecipe!)){
//            likeButton.selected=true
//        }else{
//            likeButton.selected=false
//        }
        titleLabel.text=titleOfRecipe
        self.RecipeImageVIew.image=image
     self.ingredientTableView.dataSource=self
    self.ingredientTableView.delegate=self
        self.stepTableView.dataSource=self
        self.stepTableView.delegate=self
        // Do any additional setup after loading the view.
        getBasicInformationAndIngredients()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        caloriesLabel.text=""
        proteinLabel.text=""
        fatLabel.text=""
        servingLabel.text=""
        readyInTimeLabel.text=""
        carbsLabel.text=""
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
    func getBasicInformationAndIngredients(){
        var parameters = [String:AnyObject]()
       
        parameters["id"]=idOfRecipe
        parameters["includeNutrition"]=true
        let iD=parameters["id"] as! Int
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(iD)/information?includeNutrition=true", parameters: parameters, encoding: ParameterEncoding.URL,headers: head) .responseJSON{ response in
            switch response.result{
            case .Success(let value):
                
                //MARK: get basic informaiton
            self.servings=value.objectForKey("servings") as? Int
                self.readyMinutes=value.objectForKey("readyInMinutes") as? Int
                let wholeNutritionDic=value.objectForKey("nutrition") as? NSDictionary
                let nutritionsArray=wholeNutritionDic!["nutrients"] as? [NSDictionary]
                let ingredientList=value.objectForKey("extendedIngredients") as! [NSDictionary]
                for eachNutrtion in nutritionsArray!{
                    let theTitle=eachNutrtion["title"] as! String
                    if(theTitle == "Fat"){
                        let fatAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.fat=String(fatAmount)+" \(unit)"
                    }
                    if(theTitle == "Calories"){
                        let caloriesAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.calories=String(caloriesAmount)+" \(unit)"
                    }
                    if(theTitle == "Carbohydrates"){
                        let CarbohydratesAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.carbs=String(CarbohydratesAmount)+" \(unit)"
                    }
                    if(theTitle == "Protein"){
                        let proteinAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.protein=String(proteinAmount)+" \(unit)"
                    }
                    
                }
            
                self.caloriesLabel.text=self.calories!
                self.fatLabel.text=self.fat!
                self.proteinLabel.text=self.protein!
                self.carbsLabel.text=self.carbs!
                self.servingLabel.text=String(self.servings!)+" servings"
                self.readyInTimeLabel.text=String(self.readyMinutes!) + " minutes"
                //MARK:Get Ingredients Informaiton
                
                for eachIngredient in ingredientList{
                    let name=eachIngredient["name"] as? String
                    let imageURL=eachIngredient["image"] as? String
                    let description=eachIngredient["originalString"] as? String
                    if let imageURL=imageURL{
                        self.nameArray.append(name!)
                        self.imageArray.append(imageURL)
                        self.originalStringArray.append(description!)
                    }
                }
                self.getSteps({()->Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.stepTableView.reloadData()
                          self.ingredientTableView.reloadData()
                    }
                })
             
            case .Failure(let error):
                print("error:\(error.description)")
            }
        }

    }
 
    func getSteps(completion:()->Void){
        let parameters=["id":idOfRecipe!, "stepBreakdown":true]
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(idOfRecipe!)/analyzedInstructions?stepBreakdown=true", parameters: parameters as? [String : AnyObject], encoding:ParameterEncoding.URL , headers: head) .responseJSON{ response in
            switch response.result{
            case .Success(let value1):
               
                let value = (value1 as! NSArray)[value1.count-1]
                
                let stepsResultArray=value.objectForKey("steps") as! [NSDictionary]
                for eachStep in stepsResultArray{
                    let stepNumber=eachStep["number"] as! Int
                    self.numberStringArray.append(String(stepNumber))
                    let stepDetail=eachStep["step"] as! String
                    self.stepsStringArray.append(stepDetail)
                    
                }
                
                
                for index in 0..<self.stepsStringArray.count{
                    let stringRep="\(self.numberStringArray[index]). \(self.stepsStringArray[index])"
                    self.stepsResult.append(stringRep)
                    let cellObject=StepCellObject(step:stringRep)
                    self.cellObjects.append(cellObject)
                    
                }
                
//                self.stepTableView.reloadData()
                completion()
            case .Failure(let error):
                print("error:\(error.description)")
            }
            
            
        }

    }
    
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
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "toDisplaySimilarRecipesViewController" {
            return returnToLast
        }
        
        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toDisplaySimilarRecipesViewController" {
                print("Cancel button tapped")
            }
        }
    }
    func trashWarning(){
        let warnAlertController=UIAlertController(title:"Destroy Forever", message: "You won't see this recipe ever again, are you sure you want to completely destroy it?",preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction=UIAlertAction(title:"Yes", style:UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.trashButton.selected=true
            let newDislikeIDObject=DislikeIDObject()
            newDislikeIDObject.dislikeID=self.idOfRecipe!
            RealmHelperClass.addDislikeID(newDislikeIDObject)
            InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
            InformationInputViewController.dislikeIDsList.append(self.idOfRecipe!)
//            FavoriteRecipeViewController.dislikeID.append(self.idOfRecipe!)
            self.performSegueWithIdentifier("toDisplaySimilarRecipesViewController", sender: self)
        })
        let cancelAction=UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Default,handler:nil)
        warnAlertController.addAction(yesAction)
        warnAlertController.addAction(cancelAction)
      
        
        self.presentViewController(warnAlertController, animated: true, completion: nil)
    }
    func likeFunction(){
        likeButton.selected=true
//        FavoriteRecipeViewController.likeID.append(idOfRecipe!)
//        let newLikeItem=FavoriteRecipeObject(title:titleOfRecipe, id:idOfRecipe!,image:image!,ingredients:originalStringArray, steps:stepsResult, fat:fat!, protein:protein!, calories:calories!, carbs:carbs!, servings:servings!, readyInTime:readyMinutes!)
//        FavoriteRecipeViewController.favorites.append(newLikeItem)
        let newLikeItem=FavoriteRecipeObject()
        newLikeItem.title=titleOfRecipe
        newLikeItem.id=idOfRecipe!
        newLikeItem.image=imageurl!
        let ingredientsString=originalStringArray.joinWithSeparator("||")
        newLikeItem.ingredients=ingredientsString
        let stepsString=stepsResult.joinWithSeparator("||")
        newLikeItem.steps=stepsString
        newLikeItem.fat=fat!
        newLikeItem.protein=protein!
        newLikeItem.calories=calories!
        newLikeItem.carbs=carbs!
        newLikeItem.servings=servings!
        newLikeItem.readyInTime=readyMinutes!
        self.newLikeObject=newLikeItem
        RealmHelperClass.addFavoriteRecipe(newLikeItem)
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        let newlikeIDObject=LikeIDObject()
        newlikeIDObject.likeID=self.idOfRecipe!
        RealmHelperClass.addLikeID(newlikeIDObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
        InformationInputViewController.likeIDsList.append(self.idOfRecipe!)
    }
    func unlikeFunction(){
        likeButton.selected=false
        let realm=try! Realm()
        let unlikeIDObject=realm.objects(LikeIDObject).filter("likeID=\(self.idOfRecipe)")
        RealmHelperClass.deleteLikeID(unlikeIDObject)
        RealmHelperClass.deleteFavoriteRecipe(self.newLikeObject!)
        InformationInputViewController.likeIDs = RealmHelperClass.retrieveLikeIDObject()
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        if let index=InformationInputViewController.likeIDsList.indexOf(idOfRecipe!){
            InformationInputViewController.likeIDsList.removeAtIndex(index)
        }
//
//        likeButton.selected=false
//        if let index=FavoriteRecipeViewController.likeID.indexOf(idOfRecipe!){
//            FavoriteRecipeViewController.likeID.removeAtIndex(index)
//        }
    }
    func trashFunction(){
        trashWarning()
    }
    func untrashFunction(){
        trashButton.selected=false
        let realm = try! Realm()
        let untrashIDObject = realm.objects(DislikeIDObject).filter("dislikeID=\(self.idOfRecipe)")
        RealmHelperClass.deleteDislikeID(untrashIDObject)
        InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
        if let index=InformationInputViewController.dislikeIDsList.indexOf(idOfRecipe!){
            InformationInputViewController.dislikeIDsList.removeAtIndex(index)
        }

//        trashButton.selected=false
//        if let index=FavoriteRecipeViewController.dislikeID.indexOf(idOfRecipe!){
//            FavoriteRecipeViewController.dislikeID.removeAtIndex(index)
//        }
    }

    
}

extension SimilarIndividualRecipeViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNumber:Int=0
        if(tableView==self.stepTableView){
              cellNumber=cellObjects.count
        }else if(tableView==self.ingredientTableView){
            if(nameArray.count % 2 == 0){
                cellNumber=nameArray.count/2
            }else{
                cellNumber=nameArray.count/2+1
            }
        }
        return cellNumber
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if(tableView==self.stepTableView){
        let stepViewCell = tableView.dequeueReusableCellWithIdentifier("StepListCell",
                                                               forIndexPath: indexPath) as! SimilarRecipeStepTableViewCell
        stepViewCell.stepDescript.text=""
        let cellObject = cellObjects[indexPath.row]
        stepViewCell.stepDescript.text = cellObject.step
        stepViewCell.selectionStyle = .None
        return stepViewCell
        }
        if(tableView==self.ingredientTableView){
            let ingredientCell=tableView.dequeueReusableCellWithIdentifier("ingredientListCell") as! SimilarRecipeIngredientTableViewCell
            ingredientCell.textViewOne.text=""
            ingredientCell.textViewTwo.text=""
            let row=indexPath.row
            let imageURLOne=imageArray[row*2]
            let ingredientDescriptionOne=originalStringArray[row*2]
            imageDownloadHelper.sharedLoader.imageForUrl(imageURLOne, completionHandler:{(image: UIImage?, url: String) in
                
                ingredientCell.imageViewOne.image=image
                ingredientCell.textViewOne.text=ingredientDescriptionOne
            })
            if(row*2+1<=imageArray.count-1){
                let imageURLTwo = imageArray[row*2+1]
                if imageURLTwo != "" {
                    let ingredientDescriptionTwo=originalStringArray[row*2+1]
                    imageDownloadHelper.sharedLoader.imageForUrl(imageURLTwo, completionHandler:{(image: UIImage?, url: String) in
                        
                        ingredientCell.imageViewTwo.image=image
                        ingredientCell.textViewTwo.text=ingredientDescriptionTwo
                    })
                }
            }
            return ingredientCell
        }
            return cell!
        }
    }



