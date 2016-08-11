//
//  DisplaySimilarRecipesViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/27/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DisplaySimilarRecipesViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var idOfRecipe:Int?
    var chosenRecipeId:Int?
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
      
    ]
    var idOfIndividualRecipe:Int?
    var selectedImage:UIImage?
    var similarRecipes: [SimilarRecipeObject]=[]
    var titleOfRecipe:String?
    var selectedImageURL:String=""
    override func viewDidLoad() {
        
        super.viewDidLoad()
       self.tableView.delegate=self
        self.tableView.dataSource=self
        //getSimilarRecipes(idOfRecipe!)
        getSimilarRecipes(idOfRecipe!)

        // Do any additional setup after loading the view.
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
    //https://spoonacular.com/recipeImages/
    
    func getSimilarRecipes(id:Int){
        var parameters = [String:AnyObject]()
        parameters["id"]=id
        print(id)
        let iD=parameters["id"] as! Int
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(iD)/similar", parameters: parameters, encoding: ParameterEncoding.URL,headers: head) .responseJSON{ response in
            switch response.result{
            case .Success(let value):
                let resultDicArray=value as! [NSDictionary]
                for eachResultDic in resultDicArray{
                    let title=eachResultDic["title"] as! String
                    let id=eachResultDic["id"] as! Int
                    if(id==509856){
                        continue
                    }
                    if(InformationInputViewController.dislikeIDsList.contains(id)){
                        continue
                    }
                    let imagePartUrl=eachResultDic["image"] as! String
                    let imageURL="https://spoonacular.com/recipeImages/"+imagePartUrl
                    let readyInMinutes=eachResultDic["readyInMinutes"] as! Int
                    let similarRecipeObject=SimilarRecipeObject(title:title, id:id, imageURL:imageURL, readyInMinutes: readyInMinutes)
//                    self.similarRecipes.append(similarRecipeObject)
                    self.getStepsInformation(id, completionHandler:{ (deleteRecipe:Bool) ->Void in
                      
                        if (deleteRecipe==false){
                            
                            self.similarRecipes.append(similarRecipeObject)
                            dispatch_async(dispatch_get_main_queue()) {
//                                self.RecipeTableView.reloadData()
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
                
              
            case .Failure(let error):
                print("error:\(error.description)")
            }
        }
        
    }
    override  func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="toIndividualRecipe"){
            let destination=segue.destinationViewController as! SimilarIndividualRecipeViewController
          
            destination.idOfRecipe=self.chosenRecipeId!
            destination.imageurl=self.selectedImageURL
            destination.titleOfRecipe=self.titleOfRecipe!
            
        }
    }
    
    func getStepsInformation(idOfRecipe:Int, completionHandler:(Bool)->Void){
        let parameters=["id":idOfRecipe, "stepBreakdown":true]
        var neverAdd:Bool=false
        Alamofire.request(.GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(idOfRecipe)/analyzedInstructions?stepBreakdown=true", parameters: parameters as? [String : AnyObject], encoding:ParameterEncoding.URL , headers: head) .responseJSON{ response in
            switch response.result{
            case .Success(let value1):
                
                let response = value1 as! NSArray
                if(response.count == 0){
                    neverAdd=true
                }
                completionHandler(neverAdd)
            case .Failure(let error):
                print("error:\(error.description)")
                
                
            }
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)  as! SimilarRecipeTableViewCell
        self.chosenRecipeId = cell.idOfRecipe
       
        self.selectedImage=cell.similarRecipeImageView.image
        self.titleOfRecipe=cell.recipeNameLabel.text
        self.selectedImageURL=cell.imageUrl
              self.performSegueWithIdentifier("toIndividualRecipe", sender: self)
    }
    @IBAction func unwindToDisplaySimilarRecipesViewController(segue: UIStoryboardSegue) {
        for eachItem in similarRecipes{
            if InformationInputViewController.dislikeIDsList.contains(eachItem.id){
                if let index=similarRecipes.indexOf(eachItem){
                    similarRecipes.removeAtIndex(index)
                }
            }
        }
            self.tableView.reloadData()
           }

}
extension DisplaySimilarRecipesViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarRecipes.count
    }
       func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SimilarRecipeCell",
                                                               forIndexPath: indexPath) as! SimilarRecipeTableViewCell
        cell.similarRecipeImageView.image=nil
        cell.recipeNameLabel.hidden=true
        let cellObject = similarRecipes[indexPath.row]
        cell.idOfRecipe=cellObject.id
        cell.imageUrl=cellObject.imageURL
 
        imageDownloadHelper.sharedLoader.imageForUrl(cellObject.imageURL, completionHandler:{(image: UIImage?, url: String) in
            cell.similarRecipeImageView.image=image
            cell.recipeNameLabel.text=cellObject.title
            cell.recipeNameLabel.hidden=false
            //+"\n"+"Cooking Time: "+String(cellObject.readyInMinutes)+" minutes"
        })
       
        return cell
    }
}

