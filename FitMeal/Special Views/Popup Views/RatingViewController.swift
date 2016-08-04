//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
 
    
    var name:String=""
   
    var quantityString=""
    var unit=""
    var note=""
    var priceEstString=""
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!

    @IBOutlet weak var priceEstTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!

    @IBOutlet weak var cosmosStarRating: CosmosView!
    
    @IBOutlet weak var noteTextView: UITextView!
 

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showInfo(){
 
        nameTextField.text=name
        print(name)
        quantityTextField.text=quantityString
        unitTextField.text=unit
        noteTextView.text=note
        priceEstTextField.text=priceEstString
        
    }
    func returnANewItem()->ShoppingItemObject{
        return ShoppingItemObject(name:nameTextField.text!,number:quantityTextField.text!,unit:unitTextField.text!,priceEst:priceEstTextField.text!,note:noteTextView.text!)
    }
   
    
}
