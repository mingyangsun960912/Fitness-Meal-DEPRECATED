//
//  ShoppingListViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/1/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import PopupDialog
class ShoppingListViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultUIView: UIView!
    static var shoppingItems:[ShoppingItemObject]=[]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
          self.navigationController?.navigationBarHidden=false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if (ShoppingListViewController.shoppingItems.count==0){
            noResultUIView.hidden=false
            tableView.hidden=true
        }else{
            noResultUIView.hidden=true
            tableView.hidden=false
        }
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateMoneyTotal(sender: UIButton) {
        calculateMoney()
    }
    @IBAction func addNewItem(sender: AnyObject) {
        showCustomDialog()
    }
    func showCustomDialog() {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
     
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, transitionStyle: .BounceUp, buttonAlignment: .Horizontal, gestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "SAVE") {

            var newItem:ShoppingItemObject=ratingVC.returnANewItem()
            ShoppingListViewController.shoppingItems.append(newItem)
             self.tableView.reloadData()
            self.noResultUIView.hidden=true
            self.tableView.hidden=false
           
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.presentViewController(popup, animated: true, completion: nil)
    }
    func calculateMoney(){
        var totalMoney:Double=0.0
        for eachItem in ShoppingListViewController.shoppingItems{
            if(Double(eachItem.priceEst) != nil){
                totalMoney=totalMoney+Double(eachItem.priceEst)!
            }else{
                continue
            }
        }
        self.moneyLabel.text=String(totalMoney)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
//    */
}

extension ShoppingListViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListViewController.shoppingItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCellWithIdentifier("ShoppingListTableViewCell") as! ShoppingListTableViewCell
       
        if(ShoppingListViewController.shoppingItems.count != 0){
                cell.viewController=self
                let row=indexPath.row
                let item=ShoppingListViewController.shoppingItems[row]
                cell.item=item
                cell.itemLabel.text=item.name
        
        }else{
            cell.itemLabel.text=""
        }
        return cell
    }
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        if editingStyle == .Delete {
            // 3
            ShoppingListViewController.shoppingItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            // 4
            if(ShoppingListViewController.shoppingItems.count==0){
                noResultUIView.hidden=false
                tableView.hidden=true
            }
            tableView.reloadData()
        }
    }

}
