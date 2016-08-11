//
//  FavoriteRecipeViewController.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/3/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteRecipeViewController: UIViewController,UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultView: UIView!
    static var favorites:Results<FavoriteRecipeObject>!
    var searchActive : Bool = false
    var filtered:[FavoriteRecipeObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteRecipeViewController.favorites=RealmHelperClass.retrieveFavoriteRecipes()
        collectionView.backgroundColor=UIColor.clearColor()
        collectionView.delegate=self
        collectionView.dataSource=self
        searchBar.delegate=self
                if(FavoriteRecipeViewController.favorites.count==0){
            noResultView.hidden=false
            collectionView.hidden=true
            searchBar.hidden=false
        }else{
            noResultView.hidden=true
            collectionView.hidden=false
            searchBar.hidden=false
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
         
        self.collectionView.reloadData()
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = FavoriteRecipeViewController.favorites.filter({ (item) -> Bool in
            let tmp: NSString = item.title
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.collectionView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="toFavoriteRecipe"){
            let destination=segue.destinationViewController as! FavoriteRecipeInfoViewController
            let indexPaths=collectionView.indexPathsForSelectedItems()
            let indexPath=indexPaths![0]
            let item:FavoriteRecipeObject?
            if(searchActive && searchBar.text != "") {
             item=filtered[indexPath.row]
            }else{
             item=FavoriteRecipeViewController.favorites[indexPath.row]
        }
            destination.favoriteRecipe=item
           
            
        }
        
    }
    @IBAction func unwindToFavoriteCollectionViewController(segue: UIStoryboardSegue){
        self.collectionView.reloadData()
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

extension FavoriteRecipeViewController:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive && searchBar.text != "") {
            return filtered.count
        }
        return FavoriteRecipeViewController.favorites.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("FavoriteRecipeCell", forIndexPath: indexPath) as! FavoriteRecipeCollectionViewCell
        if(searchActive && searchBar.text != ""){
            let imageUrl=filtered[indexPath.row].image
            imageDownloadHelper.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
                
                cell.recipeImage.image=image
               
            })
           
        } else {
            let imageUrl=FavoriteRecipeViewController.favorites[indexPath.row].image
            imageDownloadHelper.sharedLoader.imageForUrl(imageUrl, completionHandler:{(image: UIImage?, url: String) in
                cell.recipeImage.image=image
            })

          
        }
       
        return cell
    }
}

extension FavoriteRecipeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake((UIScreen.mainScreen().bounds.width-6)/4,(UIScreen.mainScreen().bounds.width-6)/4) //use height whatever you wants.
    }
    
}
