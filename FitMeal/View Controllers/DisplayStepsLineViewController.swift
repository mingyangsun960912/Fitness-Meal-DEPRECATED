//
//  DisplayStepsLineViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/25/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import Alamofire
class DisplayStepsProgressViewController: UIViewController, UITableViewDelegate {
    
    var cellObjects:[StepCellObject]=[]
    
    @IBOutlet weak var tableView: UITableView!
   

   
    let head: [String: String] = [
        "X-Mashape-Key": "1C9TO0ENkpmsho9kJK5xKzEcSdJAp1XiAgsjsn5TythzmyNqSb",
        "Accept": "application/json"
    ]
    var idOfRecipe:Int?
    var numberStringArray:[String]=[]
    var stepsStringArray:[String]=[]
    var stepsResult:[String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.dataSource=self
     self.tableView.separatorColor = UIColor.clearColor()
       
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        getAllSteps()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getAllSteps(){
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
               
              self.tableView.reloadData()
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

extension DisplayStepsProgressViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellObjects.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stepCell",
                                                               forIndexPath: indexPath) as! StepsTableViewCell
        
        let cellObject = cellObjects[indexPath.row]
        cell.stepDescriptionLabel.text = cellObject.step
       cell.selectionStyle = .None
        return cell
    }
}