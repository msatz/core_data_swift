//
//  JsonInCoreDataViewController.swift
//  core_data_db
//
//  Created by smac on 10/4/18.
//  Copyright © 2018 Enchanter. All rights reserved.
//

import UIKit
import CoreData

class JsonInCoreDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dataTableView: UITableView!
    var image = [String]()
    var titleString = [String]()
    var categ:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true{
            loadData()
        }
        else {
            fetchDataFromCore()
        }
        // Do any additional setup after loading the view.
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Reachability.isConnectedToNetwork() == true{
            return titleString.count
             }
        return categ.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JsonValueTableViewCell
        if Reachability.isConnectedToNetwork() == true{
            cell.titleLab.text = titleString[indexPath.row]
        }
        else {
            cell.titleLab.text = categ[indexPath.row].value(forKey: "category_Name") as? String
        }
        return cell
    }
    func loadData(){
        let urlString = URL(string:"")
        let requestURL = URLRequest(url: urlString!)
        URLSession.shared.dataTask(with: requestURL, completionHandler: {(data,response,error) in
            DispatchQueue.main.async {
                do {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                   // print(json!)
                    let resultjson = json as! NSDictionary
                    let values = resultjson.value(forKey: "result") as! NSArray
                    for result in values{
                        if let resultDict = result as? NSDictionary{
                            let titleStringJson = resultDict ["category_name"] as! String
                            self.titleString.append(titleStringJson)
                            if  self.titleString.count <= 10{
                                self.coreStorage(catgName: titleStringJson)
                                print ("check")
                            }
                        }
                        self.dataTableView.reloadData()
                    }
                }
            }
       }).resume()
    }
    func coreStorage(catgName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let category = NSManagedObject(entity: entity, insertInto: managedContext)
        category.setValue(catgName, forKey: "category_Name")
        do {
             try managedContext.save()
            } catch let error as NSError {
                print("could not save in db.\(error) \(error.userInfo)")
        }
    }
    func fetchDataFromCore(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Category")
        do {
            categ =  try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
         self.dataTableView.reloadData()
    }
}

