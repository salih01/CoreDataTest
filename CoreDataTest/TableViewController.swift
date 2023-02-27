//
//  TableViewController.swift
//  CoreDataTest
//
//  Created by Salih on 27.02.2023.
//

import UIKit
import CoreData

class TableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var people:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    // MARK: - Function Alert
    
    func makeAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default){ [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    
    // MARK: - Core Data Save
    
    func save(name:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // MARK: - 1 - Context
        let context = appDelegate.persistentContainer.viewContext
        // MARK: - 2 - Entity
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        // MARK: - 3 - Attirbute
        let person = NSManagedObject(entity: entity, insertInto: context)
        // MARK: - 4 - SetValue
        person.setValue(name, forKey: "name")
        
        do {
            try context.save()
            people.append(person)
        } catch {
            print("Error Save : \(error.localizedDescription)")
        }
         
    }
    
    // MARK: -  Core Data Load
    
    func load(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            
            people = try context.fetch(fetchRequest)
            
        } catch {
            
            print("Core data load Error: \(error.localizedDescription)")
            
        }
        
    }
    

    @IBAction func addName(_ sender: UIBarButtonItem) {

        makeAlert(title: "NE EKLEYELİM KARDEŞİME", message: "isim olsun Lütfen")
    }
}

extension TableViewController:UITableViewDelegate,UITableViewDataSource {
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
