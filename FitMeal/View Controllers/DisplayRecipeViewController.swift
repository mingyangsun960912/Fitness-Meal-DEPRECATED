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
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        ]
 
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var cookMinutesLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    var originalStringArray:[String]=[]
    var image:UIImage!
    var titleForRecipe:String!
    var fat:String!
    var calories:String!
    var carbs:String!
    var protein:String!
    var servings:Int!
    var readyTime:Int!
    var idOfRecipe:Int!
    var readyMinutes:Int!
    var numberStringArray:[String]=[]
    var stepsStringArray:[String]=[]
    var stepsResult:[String]=[]
    var returnToLast:Bool=false
    var newLikeItem:FavoriteRecipeObject?
    override func viewDidLoad() {
        super.viewDidLoad()
               showRecipe()
        self.likeButton.hidden=true
        self.trashButton.hidden=true
        getBasicInformationAndIngredients()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        if(FavoriteRecipeViewController.likeID.contains(idOfRecipe)){
            likeButton.selected=true
        }else{
            likeButton.selected=false
        }
        if(FavoriteRecipeViewController.dislikeID.contains(idOfRecipe)){
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
        caloriesLabel.text=calories
        carbsLabel.text=carbs
        proteinLabel.text=protein
        fatLabel.text=fat
        servingLabel.text=String(servings)+" people"
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
                self.servings=value.objectForKey("servings") as? Int
                let ingredientList=value.objectForKey("extendedIngredients") as! [NSDictionary]
                //MARK:Get Ingredients Informaiton
                
                for eachIngredient in ingredientList{
                    let imageURL=eachIngredient["image"] as? String
                    let description=eachIngredient["originalString"] as? String
                    if let imageURL=imageURL{
                        self.originalStringArray.append(description!)
                    }
                }
                self.getSteps({()->Void in
                    
                    let newLikeItem=FavoriteRecipeObject(title:self.titleForRecipe,id:self.idOfRecipe,image:self.image,ingredients:self.originalStringArray, steps:self.stepsResult,fat:self.fat,protein:self.protein,calories:self.calories,carbs:self.carbs,servings:self.servings,readyInTime:self.readyTime)
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
//        FavoriteRecipeViewController.likeID.append(idOfRecipe)
        FavoriteRecipeViewController.favorites.append(newLikeItem!)
        self.likeButton.selected=true
       
    }
    func unlikeFunction(){
        likeButton.selected=false
        if let index=FavoriteRecipeViewController.likeID.indexOf(idOfRecipe){
        FavoriteRecipeViewController.likeID.removeAtIndex(index)
        }
    }
    func trashFunction(){
 
        trashWarning()
    }
    func untrashFunction(){
        trashButton.selected=false
        if let index=FavoriteRecipeViewController.dislikeID.indexOf(idOfRecipe){
        FavoriteRecipeViewController.dislikeID.removeAtIndex(index)
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
