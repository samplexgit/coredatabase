//
//  CoreDataManager.swift
//  LocalDatabase
//
//  Created by Shilp_m on 1/23/17.
//  Copyright © 2017 Shilp_mphoton pho. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {

    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    
    
    //save data
    func saveData(tablename: String, record: NSDictionary)->NSManagedObject {
        
        let managedContext = appDelegate.getContext()
        //Data is in this case the name of the entity
        print(record)
        
          let entity = NSEntityDescription.entity(forEntityName: tablename,
                                                in: managedContext)
          let option = NSManagedObject(entity: entity!,
                                     insertInto:managedContext)
          if(tablename == "Person"){
            option.setValue(record["name"] as! NSString, forKey: "name")
            option.setValue(record["time"] as! NSString, forKey: "time")
            option.setValue(record["status"] as! NSString, forKey: "status")
          }
        
          do {
            
            try managedContext.save()
            
           
          } catch let error as NSError {
             print("Could not save. \(error), \(error.userInfo)")
            
          }
        
        return option
    }
    
    //read data
    func readData(tablename: String) -> NSArray
    {
        let results = NSArray()
        let managedContext = appDelegate.getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tablename)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            let results = fetchedResults as! [NSManagedObject]
            return results as NSArray
            
        } catch let error {
            print(error.localizedDescription)
            return results
        }
        
        
    }
    
    //delete data
    func deleteData(tablename: String, index: Int)
    {
        let managedContext = appDelegate.getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tablename)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            var results = fetchedResults as! [NSManagedObject]
            if  results == fetchedResults as! [NSManagedObject]
            {
                //for (var i=0; i < results.count; i += 1)
                //for i in 0 ..< results.count
                //{
                let value = results[index]
                print(value)
                managedContext.delete(value)
                try managedContext.save()
                //self.tableView.reloadData()
                //}
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    //TO DO
   /* func updateData(tablename: String, record: NSDictionary, index: Int)->NSManagedObject {
       
        
        let managedContext = appDelegate.getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tablename)
        var newManagedObject = NSEntityDescription.insertNewObject(forEntityName: tablename, into: managedContext)
        do {
         let fetchedResults = try managedContext.fetch(fetchRequest)
         let results = fetchedResults as! [NSManagedObject]
            
            deleteData(tablename: tablename, index: index)
            fetchRequest.predicate = NSPredicate(format: "name = %@","update")
            
            if results.count != 0 // Check notificationId available then not save
            {
                if(tablename == "Person"){
                 newManagedObject = results[0]
                 newManagedObject.setValue(record["name"] as! NSString, forKey: "name")
                 newManagedObject.setValue(record["time"] as! NSString, forKey: "time")
                 newManagedObject.setValue(record["status"] as! NSString, forKey: "status")
                 
                }
               try managedContext.save()
            }
        } catch let error {
            print(error.localizedDescription)
            
        }
       return newManagedObject
    
    }*/
    
    
}
