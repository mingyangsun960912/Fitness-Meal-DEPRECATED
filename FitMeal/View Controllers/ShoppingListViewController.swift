//
//  ShoppingListViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/1/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultUIView: UIView!
    static var shoppingItems:[ShoppingItemObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        if (ShoppingListViewController.shoppingItems.count==0){
            noResultUIView.hidden=false
            tableView.hidden=true
        }else{
            noResultUIView.hidden=true
            tableView.hidden=false
        }
        self.tableView.reloadData()
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
               let row=indexPath.row
             let item=ShoppingListViewController.shoppingItems[row]
        cell.itemLabel.text=item.name
        
        }else{
            cell.itemLabel.text=""
        }
        return cell
    }

}
