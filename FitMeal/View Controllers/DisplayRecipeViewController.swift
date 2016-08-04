//
//  DisplayRecipeViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/20/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire

class DisplayRecipeViewController: UIViewController {
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        ]
 
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UITextView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FavoriteRecipeViewController.likeID.contains(idOfRecipe)){
            likeButton.selected=true
        }else{
            likeButton.selected=false
        }
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
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likeButtonTapped(sender: UIButton) {
    }
    @IBAction func trashButtonTapped(sender: UIButton) {
    }
    @IBOutlet weak var trashButton: UIButton!
    
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

    func prepareForLikeFunction(){
        
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
                self.readyMinutes=value.objectForKey("readyInMinutes") as? Int
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
                print(response)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
