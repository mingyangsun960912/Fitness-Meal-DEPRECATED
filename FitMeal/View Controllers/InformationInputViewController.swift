//
//  InformationInputViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 7/11/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import RealmSwift

class InformationInputViewController: UIViewController {
    var mode:String!
    var status:String!
    var active:String!
    var bmr:Double!
    var caloriesHighLimit:Int!
    var caloriesLowlimit:Int!
    var carbs:Int!
    var fat:Int!
    var protein:Int!
    var food:String!
    static var suggestions:String!
    
    var activityFactorLowLimit:Double!
    var activityFactorHighLimit:Double!
    var activityExplanation:String!
    var fatIndex:Double!
    var carbIndex:Double!
    var proteinIndex:Double!
    var eatAmount:String!
    var gender:String!
    var weight:Int!
    var height:Int!
    var age:Int!
    var modeStatus:Int!
    @IBOutlet weak var tipsButton: UIButton!
    
    @IBOutlet weak var tipsTextView: UITextView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: all critical information text fields
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var cookButton: UIButton!
    
    @IBOutlet weak var restaurantButton: UIButton!
    //MARK: selector outlets
    @IBOutlet weak var statusSelector: UISegmentedControl!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    @IBOutlet weak var activeSelector: UISegmentedControl!
    
    static var likeIDs: Results<LikeIDObject>!
    static var dislikeIDs:Results<DislikeIDObject>!
    static var likeIDsList:[Int]=[]
    static var dislikeIDsList:[Int]=[]
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var frontView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tipsTextView.text=""
        self.tipsTextView.font=UIFont(name:"Times New Roman",size:17)
        self.backgroundImageView.image = UIImage(named: "WallPaper")
        let placeHolderColor:UIColor=UIColor(red:255.0,green:255.0,blue:255.0, alpha:0.5)
        genderTextField.attributedPlaceholder = NSAttributedString(string:"M/F",
                                                               attributes:[NSForegroundColorAttributeName: placeHolderColor])
        ageTextField.attributedPlaceholder = NSAttributedString(string:"0",
                                                                attributes:[NSForegroundColorAttributeName: placeHolderColor])
        heightTextField.attributedPlaceholder = NSAttributedString(string:"0.0 ft",
                                                                   attributes:[NSForegroundColorAttributeName: placeHolderColor])
        weightTextField.attributedPlaceholder = NSAttributedString(string:"0.0 lbs",
                                                                   attributes:[NSForegroundColorAttributeName: placeHolderColor])
        let attr = NSDictionary(object: UIFont(name: "American Typewriter", size: 13.0)!, forKey: NSFontAttributeName)

        
        if(UIScreen.mainScreen().bounds.height<=568.0){
              let attr = NSDictionary(object: UIFont(name: "American Typewriter", size: 10.0)!, forKey: NSFontAttributeName)
            statusSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
            modeSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
            activeSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
            let Font=UIFont(name:"American Typewriter", size:13.0)
            tipsButton.titleLabel!.font=Font
            let FontChalk=UIFont(name:"Chalkboard SE",size:15.0)
            cookButton.titleLabel!.font=FontChalk
            restaurantButton.titleLabel!.font=FontChalk

        }else{
        statusSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
        modeSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
            activeSelector.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)}
        self.tipsButton.layer.borderWidth=1
            self.tipsButton.layer.borderColor=UIColor.whiteColor().CGColor
        self.tipsButton.layer.cornerRadius=6
        self.tipsButton.backgroundColor=UIColor.whiteColor()
        
        self.cookButton.layer.borderWidth=1.5
        self.cookButton.layer.borderColor=UIColor.blackColor().CGColor
        self.cookButton.layer.cornerRadius=6
        self.cookButton.backgroundColor=UIColor.whiteColor()
        self.restaurantButton.layer.borderWidth=1.5
        self.restaurantButton.layer.borderColor=UIColor.blackColor().CGColor
        self.restaurantButton.layer.cornerRadius=6
        self.restaurantButton.backgroundColor=UIColor.whiteColor()
        self.view.backgroundColor=UIColor(red:220.0,green:220.0,blue:220.0,alpha:1.0)
        self.scrollView.backgroundColor=UIColor(red:220.0,green:220.0,blue:220.0,alpha:1.0)
        self.frontView.backgroundColor=UIColor(red:220.0,green:220.0,blue:220.0,alpha:1.0)
        
       
        
        
        InformationInputViewController.likeIDs=RealmHelperClass.retrieveLikeIDObject()
        InformationInputViewController.dislikeIDs=RealmHelperClass.retrieveDislikeIDObject()
        
         var likeIDObject=Array<LikeIDObject>(InformationInputViewController.likeIDs)
        for eachObject in likeIDObject{
            InformationInputViewController.likeIDsList.append(eachObject.likeID)
        }
        var dislikeIDObject=Array<DislikeIDObject>(InformationInputViewController.dislikeIDs)
        for eachObject in dislikeIDObject{
            InformationInputViewController.dislikeIDsList.append(eachObject.dislikeID)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        modeSelector.selectedSegmentIndex=0
        modeChoice()
        statusSelector.selectedSegmentIndex=0
        statusChoice()
        activeSelector.selectedSegmentIndex=0
        activeChoice()
    }
//MARK: Input critical information

//MARK: select mode and status
    @IBAction func modeSelectorSelected(sender: UISegmentedControl) {
        modeChoice()
    }
    
    @IBAction func statusSelectorSelected(sender: UISegmentedControl) {
        statusChoice()
    }
    @IBAction func activitySelectorSelected(sender: UISegmentedControl) {
        activeChoice()
    }
    func modeChoice(){
        switch modeSelector.selectedSegmentIndex{
        case 0:
            mode="lose weight"
            eatAmount="less than this amount (500 cal less)."
            proteinIndex=1.2
            fatIndex=0.8
            modeStatus=0
        case 1:
            mode="grow muscles"
            eatAmount="more than (150-300 cal more) or equal to this amount."
            proteinIndex=1.4
            fatIndex=1.2
            modeStatus=1
        case 2: mode="build shape"
            eatAmount="right equal to this amount."
            proteinIndex=1
            fatIndex=1
            modeStatus=2
        default:
            break
        }
    }
    
    func statusChoice(){
        switch modeSelector.selectedSegmentIndex{
        case 0:
            status="don't have any plan to work out"
        case 1:
            status="are ready to begin working out soon"
        case 2:
            status="are working out right now"
        case 3:
            status="just finished working out"
        default:
            break
        }
    }
    
    func activeChoice(){
        switch activeSelector.selectedSegmentIndex{
        case 0:
            active="not"
            activityFactorLowLimit=1.0
            activityFactorHighLimit=1.29
            activityExplanation="you basically didn't/won't do any exercise"
        case 1:
            active="lightly"
            activityFactorLowLimit=1.4
            activityFactorHighLimit=1.59
            activityExplanation="you did/will do 30-60 minutes of easy physical activity"
        case 2:
            active="moderately"
            activityFactorLowLimit=1.6
            activityFactorHighLimit=1.89
            activityExplanation="you did/will do 60 minutes of moderate physical activity"
        case 3:
            active="very"
            activityFactorHighLimit=2.5
            activityFactorLowLimit=1.9
            activityExplanation="you do at least 60 minutes of moderate physical activity plus 60 minutes of vigorous activity or do at least 120 minutes of moderate activity"
        default:
            break
        }
    }
    
    func calculateBMR(){
        let weight = Double(weightTextField.text!)
        let height = Double(heightTextField.text!)
        let age = Double(ageTextField.text!)
        
        var bmrPart1:Double!
        var bmrPart2:Double!
        
        if(genderTextField.text == "M"){
            bmrPart1=66+6.23*weight!
            bmrPart2=12.7*height!*12-6.8*age!
            
            bmr=bmrPart1+bmrPart2
        }else if(genderTextField.text == "F"){
            bmrPart1=655+4.35*weight!
            bmrPart2=4.7*height!*12-4.7*age!
            
            bmr=bmrPart1+bmrPart2
        }
    }
    
    func calculateCaloriesToday(){
        calculateBMR()
        
        caloriesHighLimit=Int(bmr * activityFactorHighLimit * 0.9)
        caloriesLowlimit=Int(bmr * activityFactorLowLimit * 0.9)
        if(modeStatus == 0){
            caloriesLowlimit=caloriesLowlimit-300
            caloriesHighLimit=caloriesHighLimit-300
        }
        if(modeStatus==1){
            caloriesLowlimit=caloriesLowlimit+150
            caloriesHighLimit=caloriesHighLimit+150
        }
        
    }
    
    func calculateNutritionConsumption(){
        let weight=Double(weightTextField.text!)
        protein=Int(weight!*proteinIndex)
        fat=Int(fatIndex*0.3*Double(caloriesLowlimit)/9)
        let midValueOfCalories = (caloriesHighLimit - caloriesLowlimit) / 2 + caloriesLowlimit
        carbs=(midValueOfCalories - (4 * protein) - (9 * fat)) / 4
    }
    func changeGender(){
        if(genderTextField.text == "M"){
            gender="male"
        }else if(genderTextField.text == "F"){
            gender="female"
        }
    }
    
    @IBAction func tipsButtonTapped(sender: AnyObject) {
        if errorCheck() {
            changeGender()
            calculateCaloriesToday()
            calculateNutritionConsumption()
    
            let basicInfo="You are a \(ageTextField.text!) \(gender). Your height is \(heightTextField.text!) ft and your weight is \(weightTextField.text!) lbs. Your goal is to \(mode) and you \(status) now. Here are some suggestions for you based on your information: \n"+"\n"
            let suggestions="You need \(caloriesLowlimit) to \(caloriesHighLimit) cal today to maintain your body activities and help achieve your goal. You are \(active) active today, which means that \(activityExplanation). Your daily consumptions of protein, carbs and fat should approximately be: \n"+"\n"+"Protein: \(protein) g \n"+"Carbs: \(carbs) g\n"+"Fat: \(fat) g."
            
           InformationInputViewController.suggestions = suggestions
            tipsTextView.text=basicInfo+suggestions
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
    func errorCheck() -> Bool {
        if(genderTextField.text == "") {
            nilError()
          
            return false
        }
        
        if(weightTextField.text == "" ){
            nilError()
         
            return false
        }
        
        if(ageTextField.text == ""){
            nilError()
   
            return false
        }
        
        if(heightTextField.text == ""){
            nilError()

            return false
        }
        
        if(!(genderTextField.text == "M" || genderTextField.text == "F")){
            if(genderTextField.text == "m" || genderTextField.text=="male" || genderTextField.text=="boy" || genderTextField.text == "Boy" || genderTextField.text=="man"||genderTextField.text == "Man" || genderTextField.text == "Gentleman" || genderTextField.text == "gentleman"){
                genderTextField.text="M"
            }
            else if(genderTextField.text=="f" || genderTextField.text == "female"||genderTextField.text=="girl" || genderTextField.text == "Girl" || genderTextField.text=="woman"||genderTextField.text == "Woman" || genderTextField.text == "lady" || genderTextField.text == "Lady"){
                genderTextField.text="F"
            }else{
                unrecognizableError()
                return false
            }
        }
        
        if(Double(weightTextField.text!) == nil){
            if(Int(weightTextField.text!) != nil){
                weight=Int(weightTextField.text!)
                weightTextField.text=String(Double(weight))
            }else{
                unrecognizableError()
                return false
            }
        }
        
        if(Double(heightTextField.text!) == nil){
            if(Int(heightTextField.text!) != nil){
                height=Int(heightTextField.text!)
                heightTextField.text=String(Double(height))
            }else{
                unrecognizableError()
                return false
            }
        }
        
        if(Double(ageTextField.text!)==nil){
            if(Int(ageTextField.text!) != nil){
                age=Int(ageTextField.text!)
                ageTextField.text=String(Double(age))
            }else{
                unrecognizableError()
                return false
            }
        }
        
        return true
    }
    
    func nilError(){
        let nilAlertController=UIAlertController(title:"No Value", message: "You don't input all necessry information, please check again!",preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction=UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil)
        nilAlertController.addAction(alertAction)
        
        self.presentViewController(nilAlertController, animated: true, completion: nil)
    }
    
    @IBAction func findRestApp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.yelp.com")!)
    }
    
    func unrecognizableError(){
        let alertController=UIAlertController(title: "Unrecognizable Input",message: "You input something unrecognizable, please check your input again!", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction=UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func unwindToMealPlanViewController(segue: UIStoryboardSegue){
    
    }
}
