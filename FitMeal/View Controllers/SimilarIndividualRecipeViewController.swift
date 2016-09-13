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
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet var behindView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var infoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var RecipeImageVIew: UIImageView!
    @IBOutlet weak var summaryView: UIView!
//MARK:summaryView Labels
    
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var readyInTimeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
//MARK: Nutrients
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var fiberLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
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

    @IBOutlet weak var totalAmountLabel: UILabel!


    @IBOutlet weak var basicStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var stepTableView: UITableView!
    var idOfRecipe:Int=0
    var image:UIImage?
    var imageurl:String=""
    var nameArray:[String]=[]
    var imageArray:[String]=[]
    var numberStringArray:[String]=[]
    var stepsStringArray:[String]=[]
    var originalStringArray:[String]=[]
     var cellObjects:[StepCellObject]=[]
      var stepsResult:[String]=[]
    var titleOfRecipe:String=""
    var servings:Int=0
    var readyMinutes:Int=0
    var fat:String=""
    var calories:String=""
    var carbs:String=""
    var protein:String=""
    var sugar:String=""
    var fiber:String=""
    var saturatedFat:String=""
    var sodium:String=""
    var chole:String=""
    var calcium:String=""
    var iron:String=""
    var zinc:String=""
    var potassium:String=""
    var vitaminA:String=""
    var vitaminC:String=""
    var vitaminBOne:String=""
    var vitaiminBSix:String=""
    var vitaminE:String=""
    var vitaminK:String=""
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        ]
    var newLikeObject:FavoriteRecipeObject?
    var returnToLast:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shadowView.layer.shadowOffset=CGSize(width:2, height: 3)
        self.shadowView.layer.shadowOpacity=0.8
        calLabel.text=""
        proteinLabel.text=""
        servingLabel.text=""
        readyInTimeLabel.text=""
        carbsLabel.text=""
        sugarLabel.text=""
        fiberLabel.text=""
        fatLabel.text=""
        saturatedLabel.text=""
        sodiumLabel.text=""
        choLabel.text=""
        calciumLabel.text=""
        ironLabel.text=""
        zincLabel.text=""
        potassiumLabel.text=""
        vitaminALabel.text=""
        vitaminBOneLabel.text=""
        vitaminCLabel.text=""
        vitaminBSixLabel.text=""
        vitaminELabel.text=""
        vitaminKLabel.text=""
        if(UIScreen.mainScreen().bounds.height==568){
            let fontForLabel=UIFont(name:"Gill Sans",size:15.0)
            readyInTimeLabel.font=fontForLabel
            servingLabel.font=fontForLabel
            calLabel.font=fontForLabel
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
        totalAmountLabel.textColor=UIColor(red:80.0/255,green:83.0/255,blue:61.0/255,alpha:1)
        let attr = NSDictionary(object: UIFont(name: "American Typewriter", size: 13.0)!, forKey: NSFontAttributeName)
        infoSegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
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
            self.servings=value.objectForKey("servings") as! Int
                self.readyMinutes=value.objectForKey("readyInMinutes") as! Int
                let wholeNutritionDic=value.objectForKey("nutrition") as! NSDictionary
                let nutritionsArray=wholeNutritionDic["nutrients"] as! [NSDictionary]
                let ingredientList=value.objectForKey("extendedIngredients") as! [NSDictionary]
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
                        self.calLabel.text="  "+String(caloriesAmount)+" Cal"
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
                        self.chole=" Cholesterol: "+String(choleAmount)+" \(unit)"

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
                        self.vitaiminBSix=" Vitamin B6: "+String(vitaminBSixAmount)+" \(unit)"

                        
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
                        self.vitaminBOne=" Vitamin B1: "+String(vitaminB1Amount)+" \(unit)"

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
    
                self.servingLabel.text="  "+String(self.servings)+" servings"
                self.readyInTimeLabel.text="  "+String(self.readyMinutes) + " mins"
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
            newDislikeIDObject.dislikeID=self.idOfRecipe
            RealmHelperClass.addDislikeID(newDislikeIDObject)
            InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
            InformationInputViewController.dislikeIDsList.append(self.idOfRecipe)
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

        let newLikeItem=FavoriteRecipeObject()
        newLikeItem.title=titleOfRecipe
        newLikeItem.id=idOfRecipe
        newLikeItem.image=imageurl
        let ingredientsString=originalStringArray.joinWithSeparator("||")
        newLikeItem.ingredients=ingredientsString
        let stepsString=stepsResult.joinWithSeparator("||")
        newLikeItem.steps=stepsString
        newLikeItem.fat=fat
        newLikeItem.protein=protein
        newLikeItem.calories=calories
        newLikeItem.carbs=carbs
        newLikeItem.servings=servings
        newLikeItem.readyInTime=readyMinutes
        newLikeItem.sugar=self.sugar
        newLikeItem.saturatedFat=self.saturatedFat
        newLikeItem.calcium=self.calcium
        newLikeItem.cholesterol=self.chole
        newLikeItem.zinc=self.zinc
        newLikeItem.iron=self.iron
        newLikeItem.sodium=self.sodium
        newLikeItem.potassium=self.potassium
        newLikeItem.vitaminE=self.vitaminE
        newLikeItem.vitaminA=self.vitaminA
        newLikeItem.vitaminC=self.vitaminC
        newLikeItem.vitaminK=self.vitaminK
        newLikeItem.vitaminB6=self.vitaiminBSix
        newLikeItem.vitaminB1=self.vitaminBOne
        newLikeItem.fiber=self.fiber
        
        RealmHelperClass.addFavoriteRecipe(newLikeItem)
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        let newlikeIDObject=LikeIDObject()
        newlikeIDObject.likeID=self.idOfRecipe
        RealmHelperClass.addLikeID(newlikeIDObject)
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
        InformationInputViewController.likeIDsList.append(self.idOfRecipe)
    }
    func unlikeFunction(){
        likeButton.selected=false
        let realm=try! Realm()
        let unlikeIDObject=realm.objects(LikeIDObject).filter("likeID=\(self.idOfRecipe)")
        RealmHelperClass.deleteLikeID(unlikeIDObject)
        let unlikeItem=realm.objects(FavoriteRecipeObject).filter("id=\(self.idOfRecipe)")
        RealmHelperClass.deleteFavoriteRecipe(unlikeItem)
        InformationInputViewController.likeIDs = RealmHelperClass.retrieveLikeIDObject()
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        if let index=InformationInputViewController.likeIDsList.indexOf(idOfRecipe){
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
        if let index=InformationInputViewController.dislikeIDsList.indexOf(idOfRecipe){
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
            ingredientCell.imageViewOne.sd_setImageWithURL(NSURL(string:imageURLOne),placeholderImage:nil)
                ingredientCell.textViewOne.text=ingredientDescriptionOne
         
            if(row*2+1<=imageArray.count-1){
                let imageURLTwo = imageArray[row*2+1]
                if imageURLTwo != "" {
                    let ingredientDescriptionTwo=originalStringArray[row*2+1]
                    ingredientCell.imageViewTwo.sd_setImageWithURL(NSURL(string:imageURLTwo),placeholderImage:nil)
                    ingredientCell.textViewTwo.text=ingredientDescriptionTwo
                 
                }
            }
            return ingredientCell
        }
            return cell!
        }
    }



