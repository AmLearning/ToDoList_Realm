//
//  Item.swift
//  ToDoList_Realm
//
//  Created by Theodore Schrey on 4/15/18.
//  Copyright © 2018 stuckonapps. All rights reserved.
//
/*
 - To use REALM you need to make data models subclass Realm's Object class.
 - PROPERTIES need to be declared @objc dynamic var which allows Realm to observe for any changes in the property.
 - To specify RELATIONSHIPs, use Realms' LIST container type for the data and for the inverse relationship, use LinkingObjects(<type linked to>, <name of type linked to>)
 */

import Foundation
import RealmSwift

class Item : Object {
    
    //propery declaration needs to be @objc dynamic so Realm can observe
    @objc dynamic var title = ""
    @objc dynamic var done = false
    
    //Challenge to sort by date created instead of title, so creating property.  in TodDoList instantiate upon Item creation
    @objc dynamic var  dateCreated : NSDate?

    
    //inverse relationship to item:
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
