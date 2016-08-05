//
//  DisplayIngredientsViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/22/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire
class DisplayIngredientsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var ingredientsTableView: UITableView!
   
    
    var idOfRecipe:Int?
    var missedIngredientsCount:Int?
    var missedIngredients:String?
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsTableView.separatorColor=UIColor.clearColor()
        self.ingredientsTableView.delegate=self
        self.ingredientsTableView.dataSource=self
        getIngredientApiResult()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //missedIngredientsTextView.text=missedIngredients
        //missedIngredientsLabel.text=String(missedIngredientsCount)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var nameArray:[String] = []
    var imageArray:[String] = []
    var originalStringArray:[String] = []

      func getIngredientApiResult(){
         var parameters = [String:AnyObject]()
        parameters["id"]=idOfRecipe!
        parameters["includeNutrition"]=false
        
        Alamofire.request( .GET, "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(idOfRecipe!)/information", parameters: parameters, encoding: ParameterEncoding.URL, headers: head) .responseJSON { response in
            switch response.result{
            case .Success(let value):
      
                var ingredientList=value.objectForKey("extendedIngredients") as! [NSDictionary]
                for eachIngredient in ingredientList{
                    var name=eachIngredient["name"] as? String
                    var imageURL=eachIngredient["image"] as? String
                    var description=eachIngredient["originalString"] as? String
                    if let imageURL=imageURL{
                    self.nameArray.append(name!)
                    self.imageArray.append(imageURL)
                        self.originalStringArray.append(description!)
                    }
                }
                
                self.ingredientsTableView.reloadData()
               
            case .Failure(let error):
                print("error:\(error.description)")
            }
        }

        
        }
    

    @IBAction func addingItemsToShoppingCart(sender: UIButton) {
        addingNewItemToCart()
           }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addingNewItemToCart(){
        for eachItem in self.nameArray{
            
            let newAddingItem=ShoppingItemObject(name:eachItem,number:"",unit:"",priceEst:"",note:"")
            ShoppingListViewController.shoppingItems.append(newAddingItem)
        }

    }

}

extension DisplayIngredientsViewController:UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(nameArray.count % 2 == 0){
            return nameArray.count/2
        }else{
            return nameArray.count/2+1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("IngredientListCell") as! IngredientListViewCell
        let row=indexPath.row
        let imageURLOne=imageArray[row*2]
        let ingredientDescriptionOne=originalStringArray[row*2]
        imageDownloadHelper.sharedLoader.imageForUrl(imageURLOne, completionHandler:{(image: UIImage?, url: String) in

            cell.ingredientImageViewOne.image=image
            cell.descriptionTextViewOne.text=ingredientDescriptionOne
                   })
        if(row*2+1<=imageArray.count-1){
        let imageURLTwo = imageArray[row*2+1]
        if imageURLTwo != "" {
            let ingredientDescriptionTwo=originalStringArray[row*2+1]
            imageDownloadHelper.sharedLoader.imageForUrl(imageURLTwo, completionHandler:{(image: UIImage?, url: String) in
      
             cell.ingredientImageViewTwo.image=image
                cell.descriptionTextViewTwo.text=ingredientDescriptionTwo
                print(cell.ingredientImageViewOne.image)
            })
        }
        }
        return cell
    }
 

}


