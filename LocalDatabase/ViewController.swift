//
//  ViewController.swift
//  LocalDatabase
//
//  Created by Shilp_m on 1/23/17.
//  Copyright © 2017 Shilp_mphoton pho. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    //var names = [String]()
    @IBOutlet weak var tableLabel: UILabel!
    var people = [NSManagedObject]()
    var status = "Added On:"
    let coredatahelper = CoreDataManager()
    let results = NSArray()
    //var myArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "To Do List"
        //tableView.register(UITableViewCell.self,
                                //forCellReuseIdentifier: "Cell")
        
        
        let results = self.coredatahelper.readData(tablename: "Person")
        if  (results.count != nil)
        {
            //for (var i=0; i < results.count; i++)
            for i in 0 ..< results.count
            {
                let single_result = results[i]
                //let out = (single_result as AnyObject).value(forKey: "name") as! String
                //print(out)
                people.append(single_result as! NSManagedObject)
            }
        }
        
        self.tableView.reloadData()
        
        //height of cell changes according to content
        tableView.estimatedRowHeight = 43.0;
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func AddName(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        //self.names.append(textField!.text!)
                                        
                                        //Taking current time
                                        let date = Date()
                                        let calendar = Calendar.current
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
                                        let dateString = dateFormatter.string(from: date)
                                        let hour = calendar.component(.hour, from: date)
                                        let minutes = calendar.component(.minute, from: date)
                                        let seconds = calendar.component(.second, from: date)
                                        print("hours = \(hour):\(minutes):\(seconds)")
                                        //let time = "\(dateString):\(hour):\(minutes):\(seconds)"
                                        self.status = "Added On:"
                                        //self.saveName(name: textField!.text!, time: dateString)
                                        
                                        var dictionary =  [String:String]()
                                        
                                        dictionary.updateValue(textField!.text!, forKey: "name")
                                        dictionary.updateValue(dateString, forKey: "time")
                                        dictionary.updateValue(self.status, forKey: "status")
                                        let InsertedValue = self.coredatahelper.saveData(tablename: "Person", record: dictionary as NSDictionary)
                                        self.people.append(InsertedValue)
                                        self.tableView.reloadData()
                                       
                                      
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
indexPath: IndexPath) -> UITableViewCell {
        
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let person = people[indexPath.row]
        cell.cellLable.sizeToFit()
        cell.cellLable.text =
            person.value(forKey: "name") as? String
        cell.cellLable.numberOfLines=0
        let timeString = person.value(forKey: "time") as? String
        if timeString != nil {
          cell.cellTimeLable.text = timeString!
        }
        cell.cellEditButton.tag = indexPath.row
        cell.cellEditButton .addTarget(self, action: #selector(editButton), for: .touchUpInside)
        cell.cellStatusLable.text = person.value(forKey: "status") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            people.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.coredatahelper.deleteData(tablename: "Person", index: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func editButton(sender:UIButton)
    {
       let buttonIndex = sender.tag
        print(buttonIndex)
        let person = people[buttonIndex]
        self.updateData(index: buttonIndex, name: (person.value(forKey: "name") as? String)!)
        
    }
   
    // did in the same file, now there is common method so commented here
    //save data
 /*   func saveName(name: String, time: String) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.getContext()
        //Data is in this case the name of the entity
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                                in: managedContext)
        let option = NSManagedObject(entity: entity!,
                                      insertInto:managedContext)
        
        option.setValue(name, forKey: "name")
        option.setValue(time, forKey: "time")
        option.setValue(self.status, forKey: "status")
        
        do {
            
            try managedContext.save()
            people.append(option)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //read data
    func read()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.getContext()
        //let fetchRequest = NSFetchRequest(entityName: "Data")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            var results = fetchedResults as! [NSManagedObject]
            if  results == fetchedResults as! [NSManagedObject]
            {
                //for (var i=0; i < results.count; i++)
                for i in 0 ..< results.count
                {
                    let single_result = results[i]
                    //let out = single_result.value(forKey: "name") as! String
                    //print(out)
                    //uncomment this line for adding the stored object to the core data array
                    people.append(single_result)
                }
            }
            else
            {
                print("cannot read")
            }
  
        
        } catch let error {
            print(error.localizedDescription)
        }
        
        
            }
    
    //delete data
    func clear_data(index: Int)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.getContext()
        
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
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
                self.tableView.reloadData()
            //}
          }
        } catch let error {
            print(error.localizedDescription)
        }
            
    }  */
    
    func updateData(index: Int, name: String) {
        
        
        let alert = UIAlertController(title: "Edit Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        
                                        //self.names.append(textField!.text!)
                                        
                                        //Taking current time
                                        let date = Date()
                                        let calendar = Calendar.current
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
                                        let dateString = dateFormatter.string(from: date)
                                        let hour = calendar.component(.hour, from: date)
                                        let minutes = calendar.component(.minute, from: date)
                                        let seconds = calendar.component(.second, from: date)
                                        print("hours = \(hour):\(minutes):\(seconds)")
                                        
                                        
                                        self.status = "Edited on :"
                                        var dictionary =  [String:String]()
                                        
                                        dictionary.updateValue(textField!.text!, forKey: "name")
                                        dictionary.updateValue(dateString, forKey: "time")
                                        dictionary.updateValue(self.status, forKey: "status")
                                        //self.coredatahelper.deleteData(tablename: "Person", index: index)
                                        //self.people.remove(at: index)
                                        let InsertedValue = self.coredatahelper.updateData(tablename: "Person", record: dictionary as NSDictionary, index: index)
                                        //let InsertedValue = self.coredatahelper.saveData(tablename: "Person", record: dictionary as NSDictionary)
                                        print(InsertedValue)
                                        //self.people.append(InsertedValue as NSManagedObject)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
            textField.text = name
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)
        
        
    }
    
   /* This BLOG saved my life.
    
    INCREMENTING
    
    for i in 0 ..< len {
    
    }
    DECREMENTING
    
    for i in (0 ..< len).reverse() {
    
    }
    NON-SEQUENTIAL INDEXING
    
    Using where
    
    for i in (0 ..< len) where i % 2 == 0 {
    
    }
    Using striding to or through
    
    for i in 0.stride(to: len, by: 2) {
    
    }*/
}

