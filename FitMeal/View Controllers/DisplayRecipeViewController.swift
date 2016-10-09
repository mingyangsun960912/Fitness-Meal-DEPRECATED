//
//  DisplayRecipeViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/20/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class DisplayRecipeViewController: UIViewController {
    let head: [String: String] = [
        "X-Mashape-Key": AppDelegate.head,
        ]
 
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cookMinutesLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var fiberLabel: UILabel!
    @IBOutlet weak var saturatedLabel: UILabel!
    
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var choLabel: UILabel!
    
    @IBOutlet weak var calciumLabel: UILabel!
    @IBOutlet weak var ironLabel: UILabel!
    @IBOutlet weak var zincLabel: UILabel!
    @IBOutlet weak var potassiumLabel: UILabel!
    @IBOutlet weak var vitaminALabel: UILabel!
    @IBOutlet weak var vitaminCLabel: UILabel!
    
    @IBOutlet weak var vitaminBOneLabel: UILabel!
    @IBOutlet weak var vitaminBSixLabel: UILabel!
    @IBOutlet weak var vitaminELabel: UILabel!
    @IBOutlet weak var vitaminKLabel: UILabel!
    
    


    var originalStringArray:[String]=[]
    var imageurl:String=""
    var image:UIImage?
    var titleForRecipe:String=""
    var fat:String=""
    var calories:String=""
    var carbs:String=""
    var protein:String=""
    var servings:Int=0
    var readyTime:Int=0
    var idOfRecipe:Int=0
    var readyMinutes:Int=0
    var numberStringArray:[String]=[]
    var stepsStringArray:[String]=[]
    var stepsResult:[String]=[]
    var returnToLast:Bool=false
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

    var newLikeItem:FavoriteRecipeObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIScreen.mainScreen().bounds.height<=568){
            let fontForLabel=UIFont(name:"Gill Sans",size:15.0)
            cookMinutesLabel.font=fontForLabel
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
        self.recipeTitle.text=""
        self.cookMinutesLabel.text=""
        self.servingLabel.text=""
        self.caloriesLabel.text=""
        self.carbsLabel.text=" Carbs: N/A"
        self.proteinLabel.text=" Protein: N/A"
        self.fatLabel.text=" Fat: N/A"
        sugarLabel.text=" Sugar: N/A"
        fiberLabel.text=" Fiber: N/A"
        saturatedLabel.text=" Saturated: N/A"
        sodiumLabel.text=" Sodium: N/A"
        choLabel.text=" Cholesterol: N/A"
        calciumLabel.text=" Calcium: N/A"
        ironLabel.text=" Iron: N/A"
        zincLabel.text=" Zinc: N/A"
        potassiumLabel.text=" Potassium: N/A"
        vitaminALabel.text=" Vitamin A: N/A"
        vitaminBOneLabel.text=" Vitamin B: N/A"
        vitaminCLabel.text=" Vitamin C: N/A"
        vitaminBSixLabel.text=" Vitamin B6: N/A"
        vitaminELabel.text=" Vitamin E: N/A"
        vitaminKLabel.text=" Vitamin K: N/A"
        totalAmountLabel.textColor=UIColor(red:80.0/255,green:83.0/255,blue:61.0/255,alpha:1)
        self.shadowView.layer.shadowOffset=CGSize(width:2, height: 3)
        self.shadowView.layer.shadowOpacity=0.8
        let greyColor:UIColor=UIColor(red:220.0/255,green:220.0/255,blue:220.0/255,alpha:1)
        self.carbsLabel.backgroundColor=greyColor
        self.proteinLabel.backgroundColor=greyColor
        self.fatLabel.backgroundColor=greyColor
        self.saturatedLabel.backgroundColor=greyColor
        self.calciumLabel.backgroundColor=greyColor
        self.ironLabel.backgroundColor=greyColor
        self.vitaminALabel.backgroundColor=greyColor
        self.vitaminCLabel.backgroundColor=greyColor
        self.vitaminELabel.backgroundColor=greyColor
        self.vitaminKLabel.backgroundColor=greyColor
        self.shadowView.layer.shadowColor=UIColor.grayColor().CGColor
        
        self.likeButton.hidden=true
        self.trashButton.hidden=true
  
        
        showRecipe()
        getBasicInformationAndIngredients()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        


        if(InformationInputViewController.likeIDsList.contains(idOfRecipe)){
            likeButton.selected=true
        }else{
            likeButton.selected=false
        }
        if(InformationInputViewController.dislikeIDsList.contains(idOfRecipe)){
            trashButton.selected=true
        }else{
            trashButton.selected=false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likeButtonTapped(sender: UIButton) {
        if(likeButton.selected==true){
            unlikeFunction()
        }else{
            if(trashButton.selected==true){
                untrashFunction()
                likeFunction()
                
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
    @IBOutlet weak var trashButton: UIButton!
    
    func showRecipe(){
        recipeImageView.image=image
        recipeTitle.text=titleForRecipe
//        caloriesLabel.text=calories
//        carbsLabel.text=carbs
//        proteinLabel.text=protein
//        fatLabel.text=fat
        servingLabel.text=String(servings)+" servs"
        cookMinutesLabel.text=String(readyTime)+" minutes"
        
          }


    
    func getBasicInformationAndIngredients(){
        var parameters = [String:AnyObject]()
        
        parameters["id"]=idOfRecipe
        parameters["includeNutrition"]=true
        let iD=parameters["id"] as! Int
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(iD)/information?includeNutrition=true", parameters: parameters, encoding: ParameterEncoding.URL,headers: head) .responseJSON{ response in
            switch response.result{
            case .Success(let value):
                
                //MARK: get basic informaiton
                self.servings=value.objectForKey("servings") as! Int
                let ingredientList=value.objectForKey("extendedIngredients") as! [NSDictionary]
                //MARK:Get Ingredients Informaiton
                
                for eachIngredient in ingredientList{
                    let imageURL=eachIngredient["image"] as? String
                    
                    let description=eachIngredient["originalString"] as! String
                    if let imageURL=imageURL{
                        self.originalStringArray.append(description)
                    }
                }
                let wholeNutritionDic=value.objectForKey("nutrition") as! NSDictionary
                let nutritionsArray=wholeNutritionDic["nutrients"] as! [NSDictionary]
                for eachNutrtion in nutritionsArray{
                    let theTitle=eachNutrtion["title"] as! String
                    
                    if(theTitle == "Fat"){
                        let fatAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.fatLabel.text=" Fat: "+String(fatAmount)+" \(unit)"
                        self.fat=" Fat: "+String(fatAmount)+" \(unit)"
                    }
                    if(theTitle == "Calories"){
                        let caloriesAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.caloriesLabel.text="  "+String(caloriesAmount)+" Cal"
                        self.calories="  "+String(caloriesAmount)+" Cal"
                    }
                    if(theTitle == "Carbohydrates"){
                        let CarbohydratesAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.carbsLabel.text=" Carbs: "+String(CarbohydratesAmount)+" \(unit)"
                        self.carbs=" Carbs: "+String(CarbohydratesAmount)+" \(unit)"
                    }
                    if(theTitle == "Protein"){
                        let proteinAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.proteinLabel.text=" Protein: "+String(proteinAmount)+" \(unit)"
                        self.protein=" Protein: "+String(proteinAmount)+" \(unit)"
                    }
                    if(theTitle == "Saturated Fat"){
                        let saturatedFatAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.saturatedLabel.text=" Saturated: "+String(saturatedFatAmount)+" \(unit)"
                        self.saturatedFat=" Saturated: "+String(saturatedFatAmount)+" \(unit)"
                    }
                    
                    if(theTitle == "Sugar"){
                        let sugarAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.sugarLabel.text=" Sugar: "+String(sugarAmount)+" \(unit)"
                        self.sugar=" Sugar: "+String(sugarAmount)+" \(unit)"
                    }
                    if(theTitle == "Cholesterol"){
                        let choleAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.choLabel.text=" Cholesterol: "+String(choleAmount)+" \(unit)"
                        self.cholesterol=" Cholesterol: "+String(choleAmount)+" \(unit)"
                    }
                    if(theTitle == "Sodium"){
                        let sodiumAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.sodiumLabel.text=" Sodium: "+String(sodiumAmount)+" \(unit)"
                        self.sodium=" Sodium: "+String(sodiumAmount)+" \(unit)"
                    }
                    if(theTitle == "Vitamin K"){
                        let vitaminKAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminKLabel.text=" Vitamin K: "+String(vitaminKAmount)+" \(unit)"
                        self.vitaminK=" Vitamin K: "+String(vitaminKAmount)+" \(unit)"
                    }
                    
                    if(theTitle == "Vitamin A"){
                        let vitaminAAmount=eachNutrtion["amount"] as! Double
                        let vitaminValidAmount=vitaminAAmount*0.3/1000
                        let vitaminAFinalAmount=(round(100*vitaminValidAmount)/100)
                        //                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminALabel.text=" Vitamin A: "+String(vitaminAFinalAmount)+" mg"
                        self.vitaminA=" Vitamin A: "+String(vitaminAFinalAmount)+" mg"
                    }
                    if(theTitle == "Vitamin C"){
                        let vitaminCAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminCLabel.text=" Vitamin C: "+String(vitaminCAmount)+" \(unit)"
                        self.vitaminC=" Vitamin C: "+String(vitaminCAmount)+" \(unit)"
                    }
                    if(theTitle == "Zinc"){
                        let zincAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.zincLabel.text=" Zinc: "+String(zincAmount)+" \(unit)"
                        self.zinc=" Zinc: "+String(zincAmount)+" \(unit)"
                    }
                    
                    if(theTitle == "Vitamin B6"){
                        let vitaminBSixAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminBSixLabel.text=" Vitamin B6: "+String(vitaminBSixAmount)+" \(unit)"
                        self.vitaminB6=" Vitamin B6: "+String(vitaminBSixAmount)+" \(unit)"
                        
                    }
                    if(theTitle == "Iron"){
                        let ironAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.ironLabel.text=" Iron: "+String(ironAmount)+" \(unit)"
                        self.iron=" Iron: "+String(ironAmount)+" \(unit)"
                    }
                    if(theTitle == "Vitamin E"){
                        let vitaminEAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminELabel.text=" Vitamin E: "+String(vitaminEAmount)+" \(unit)"
                        self.vitaminE=" Vitamin E: "+String(vitaminEAmount)+" \(unit)"
                    }
                    if(theTitle == "Potassium"){
                        let potassiumAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.potassiumLabel.text=" Potassium: "+String(potassiumAmount)+" \(unit)"
                        self.potassium=" Potassium: "+String(potassiumAmount)+" \(unit)"
                    }
                    if(theTitle == "Vitamin B1"){
                        let vitaminB1Amount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.vitaminBOneLabel.text=" Vitamin B1: "+String(vitaminB1Amount)+" \(unit)"
                        self.vitaminB1=" Vitamin B1: "+String(vitaminB1Amount)+" \(unit)"
                    }
                    if(theTitle == "Fiber"){
                        let fiberAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.fiberLabel.text=" Fiber: "+String(fiberAmount)+" \(unit)"
                        self.fiber=" Fiber: "+String(fiberAmount)+" \(unit)"

                    }
                    if(theTitle == "Calcium"){
                        let calciumAmount=eachNutrtion["amount"] as! Double
                        let unit=eachNutrtion["unit"] as! String
                        self.calciumLabel.text=" Calcium: "+String(calciumAmount)+" \(unit)"
                        self.calcium=" Calcium: "+String(calciumAmount)+" \(unit)"
                    }
                    
                }

                self.getSteps({()->Void in
                    

                    let newLikeItem=FavoriteRecipeObject()
                    newLikeItem.title=self.titleForRecipe
                    newLikeItem.id=self.idOfRecipe
                    newLikeItem.image=self.imageurl
                    let ingredientString=self.originalStringArray.joinWithSeparator("||")
                    newLikeItem.ingredients=ingredientString
                    let stepString=self.stepsResult.joinWithSeparator("||")
                    newLikeItem.steps=stepString
                    newLikeItem.fat=self.fat
                    newLikeItem.protein=self.protein
                    newLikeItem.calories=self.calories
                    newLikeItem.carbs=self.carbs
                    newLikeItem.servings=self.servings
                    newLikeItem.readyInTime=self.readyTime
                    newLikeItem.sugar=self.sugar
                    newLikeItem.saturatedFat=self.saturatedFat
                    newLikeItem.calcium=self.calcium
                    newLikeItem.cholesterol=self.cholesterol
                    newLikeItem.zinc=self.zinc
                    newLikeItem.iron=self.iron
                    newLikeItem.sodium=self.sodium
                    newLikeItem.potassium=self.potassium
                    newLikeItem.vitaminE=self.vitaminE
                    newLikeItem.vitaminA=self.vitaminA
                    newLikeItem.vitaminC=self.vitaminC
                    newLikeItem.vitaminK=self.vitaminK
                    newLikeItem.vitaminB6=self.vitaminB6
                    newLikeItem.vitaminB1=self.vitaminB1
                    newLikeItem.fiber=self.fiber
                    self.newLikeItem=newLikeItem
                    self.likeButton.hidden=false
                    self.trashButton.hidden=false
                })
                
            case .Failure(let error):
                print("error:\(error.description)")
            }
        }
        
    }

    func getSteps(completion:()->Void){
        let parameters=["id":idOfRecipe, "stepBreakdown":true]
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(idOfRecipe)/analyzedInstructions?stepBreakdown=true", parameters: parameters as? [String : AnyObject], encoding:ParameterEncoding.URL , headers: head) .responseJSON{ response in
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
                }
                completion()
            case .Failure(let error):
                print("error:\(error.description)")
            }
            
            
        }
        
    }
    func trashWarning(){
        let warnAlertController=UIAlertController(title:"Destroy Forever", message: "You won't see this recipe ever again, are you sure you want to completely destroy it?",preferredStyle: UIAlertControllerStyle.Alert)
        let yesAction=UIAlertAction(title:"Yes", style:UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.trashButton.selected=true
            let newDislikeObject=DislikeIDObject()
            newDislikeObject.dislikeID=self.idOfRecipe
            RealmHelperClass.addDislikeID(newDislikeObject)
            InformationInputViewController.dislikeIDsList.append(self.idOfRecipe)
            InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
           
//            FavoriteRecipeViewController.dislikeID.append(self.idOfRecipe!)
               self.performSegueWithIdentifier("toRecipeListViewController", sender: self)
        })
        let cancelAction=UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Default,handler:nil)
        warnAlertController.addAction(yesAction)
        warnAlertController.addAction(cancelAction)
        
        
        self.presentViewController(warnAlertController, animated: true, completion: nil)
    }
    //MARK:Handle all buttons
    
    func likeFunction(){
        likeButton.selected=true
        let newLikeObject=LikeIDObject()
        newLikeObject.likeID=idOfRecipe
        RealmHelperClass.addLikeID(newLikeObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
         InformationInputViewController.likeIDsList.append(idOfRecipe)
//        FavoriteRecipeViewController.likeID.append(idOfRecipe)
        let newFavoriteRecipe=FavoriteRecipeObject()
        newFavoriteRecipe.title=newLikeItem!.title
        newFavoriteRecipe.id=newLikeItem!.id
        newFavoriteRecipe.image=newLikeItem!.image
        newFavoriteRecipe.ingredients=newLikeItem!.ingredients
        newFavoriteRecipe.steps=newLikeItem!.steps
        newFavoriteRecipe.fat=newLikeItem!.fat
newFavoriteRecipe.protein=newLikeItem!.protein
        newFavoriteRecipe.calories=newLikeItem!.calories
        newFavoriteRecipe.carbs=newLikeItem!.carbs
        newFavoriteRecipe.servings=newLikeItem!.servings
        newFavoriteRecipe.readyInTime=newLikeItem!.readyInTime
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
       
        self.likeButton.selected=true
       
    }
    func unlikeFunction(){
        likeButton.selected=false
        let realm=try! Realm()
        let unlikeIDObject=realm.objects(LikeIDObject).filter("likeID=\(self.idOfRecipe)")
        RealmHelperClass.deleteLikeID(unlikeIDObject)
        InformationInputViewController.likeIDs = RealmHelperClass.retrieveLikeIDObject()
        if let index=InformationInputViewController.likeIDsList.indexOf(idOfRecipe){
        InformationInputViewController.likeIDsList.removeAtIndex(index)
        }
        let unlikeItem=realm.objects(FavoriteRecipeObject).filter("id=\(self.idOfRecipe)")
        RealmHelperClass.deleteFavoriteRecipe(unlikeItem)
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
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
        if let index=InformationInputViewController.dislikeIDsList.indexOf(idOfRecipe){
        InformationInputViewController.dislikeIDsList.removeAtIndex(index)
        }
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
