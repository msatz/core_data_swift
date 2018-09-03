//
//  ViewController.swift
//  core_data_db
//
//  Created by Enchanter on 13/09/17.
//  Copyright © 2017 Enchanter. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var Show_data: UITableView!
   // var name:[String]=[]
    var people:[NSManagedObject]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Name List"
       // Show_data.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add name list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (name : UITextField!) in
            name.placeholder = "Enter Name"
        })
        alert.addTextField(configurationHandler: {(age : UITextField!) in
            age.placeholder = "Enter Age"
        })
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
          let nameToSave = alert.textFields![0] as UITextField
            let age = alert.textFields![1] as UITextField
//            guard let textField = alert.textFields?.first,
//
//                 let nameToSave = textField.text else{
//                    return
//            }
        //    self.name.append(nameToSave)
            self.save(name: nameToSave.text!, age: Int(age.text!))
            self.Show_data.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
       // alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
     //   [unowed self] action in
       
        
    }
    func save(name: String, age: Int?){
        let randomNum:UInt32 = arc4random_uniform(10000)
        let Uid:String = String(randomNum)
        print(Uid)
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
        return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(age, forKey: "age")
        person.setValue(Uid, forKey: "uid")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("could not save in db.\(error) \(error.userInfo)")
        }
        print("Data \(people)...")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! dataTableViewCell
        let person = people[indexPath.row]
      //  cell.textLabel?.text = name[indexPath.row]
       // cell.textLabel?.text  = person.value(forKeyPath: "name") as? String
        let name = person.value(forKey: "name") as? String
        let age = person.value(forKey: "age") as? Int
        cell.name.text = "Name: "+name!
        cell.age.text = "Age: \(age!)"
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(people[indexPath.row])
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
          
           
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appdelegate?.persistentContainer.viewContext
                managedContext?.delete(people[indexPath.row])
            do{
                try managedContext?.save()
            }catch let error as NSError{
                print("Error while deleting \(error.userInfo)")
            }
              people.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
            Show_data.reloadData()
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Person")
//            do{
//                let fetchData = try managedContext?.fetch(fetchRequest)
//                managedContext?.delete(fetchData![indexPath.row])
//            }catch{
//
//            }
           // let fetchData = managedContext?.fetch(fetchRequest)
          //  managedContext?.delete(fetchResults[indexPath.row])
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Person")
        
        do {
           people =  try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
             print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

