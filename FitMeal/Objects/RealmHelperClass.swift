//
//  RealmHelperClass.swift
//  FitMeal
//
//  Created by Mingyang Sun on 8/5/16.
//  Copyright © 2016 MingyangSun. All rights reserved.
//

import RealmSwift

class RealmHelperClass {
    static func doSomething() {
        
    }
    static func addFavoriteRecipe(favoriteRecipe: FavoriteRecipeObject) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(favoriteRecipe)
        }
    }
    static func addShoppingListItem(shoppingListItem: ShoppingItemObject) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(shoppingListItem)
        }
    }
    static func addLikeID(LikeID:LikeIDObject ) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(LikeID)
        }
    }
    static func addDislikeID(DislikeID: DislikeIDObject) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(DislikeID)
        }
    }
    static func deleteFavoriteRecipe(favoriteRecipe: Results<FavoriteRecipeObject>) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(favoriteRecipe)
        }
    }
    static func deleteShoppingListItem(shoppingListItem: ShoppingItemObject) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(shoppingListItem)
        }
    }
    static func deleteLikeID(likeID:Results<LikeIDObject>) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(likeID)
        }
    }
    static func deleteDislikeID(dislikeID: Results<DislikeIDObject>) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(dislikeID)
        }
    }
    static func updateShoppingListItem(shoppingListItemToBeUpdated:ShoppingItemObject , newShoppingListItem: ShoppingItemObject) {
        let realm = try! Realm()
        try! realm.write() {
            shoppingListItemToBeUpdated.name=newShoppingListItem.name
            shoppingListItemToBeUpdated.note=newShoppingListItem.note
            shoppingListItemToBeUpdated.number=newShoppingListItem.number
            shoppingListItemToBeUpdated.unit=newShoppingListItem.unit
            shoppingListItemToBeUpdated.priceEst=newShoppingListItem.priceEst
            shoppingListItemToBeUpdated.finish=newShoppingListItem.finish
            shoppingListItemToBeUpdated.order=newShoppingListItem.order
         
            
        }
    }
    static func updateItemStatus(shoppingListItemToBeUpdated:ShoppingItemObject, status:Bool){
        let realm = try! Realm()
        try! realm.write() {
            shoppingListItemToBeUpdated.finish=status
            
        }

    }
    static func retrieveShoppingListItems() -> Results<ShoppingItemObject> {
        let realm = try! Realm()
        return realm.objects(ShoppingItemObject).sorted("order", ascending: false)
    }
    static func retrieveFavoriteRecipes() -> Results<FavoriteRecipeObject> {
        let realm = try! Realm()
        return realm.objects(FavoriteRecipeObject)
    }
    static func retrieveLikeIDObject() -> Results<LikeIDObject> {
        let realm = try! Realm()
        return realm.objects(LikeIDObject)
    }
    static func retrieveDislikeIDObject()->Results<DislikeIDObject>{
        let realm=try! Realm()
        return realm.objects(DislikeIDObject)
    }
    
}
