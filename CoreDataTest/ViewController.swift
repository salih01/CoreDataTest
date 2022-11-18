//
//  ViewController.swift
//  CoreDataTest
//
//  Created by ALFA on 17.11.2022.
//

import UIKit
import CoreData

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
        
    }
    
    
}

class ViewController: UIViewController {
    
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var people = [NSManagedObject]()
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "isim"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    // MARK: - Functions
    
    func saveData(name:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue(name, forKey: "name")
        
        do {
            try context.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - Actions
    
    
    
    @IBAction func addName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Uyarı", message: "Eklenecek İsmi girin", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){ [self]
            action in
            
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text
            else
            {
                return
            }
            
            self.saveData(name: nameToSave)
            tableView.reloadData()
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.textFields?.first
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        present(alert, animated: true)
        
        
    }
    
}
