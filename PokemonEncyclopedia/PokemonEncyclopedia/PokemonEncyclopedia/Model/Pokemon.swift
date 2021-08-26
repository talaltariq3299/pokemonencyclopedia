//
//  Pokemon.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import Foundation
import UIKit
import CoreData
 
extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}

class Pokemon : NSManagedObject, Codable  {
    
    @NSManaged var name : String
    @NSManaged var url : URL
    @NSManaged var number : NSNumber?
    @NSManaged var detail : PokemonDetail?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case detail
    }
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)

        if number != nil && detail == nil{
            setupDetail()
        }
    }

    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: managedObjectContext) else {
            fatalError("Failed to decode PokemonDetail")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        url = try values.decode(URL.self, forKey: .url)
        var absoluteString = url.absoluteString
        absoluteString.removeLast()
        number = NSNumber(value: Int(absoluteString.components(separatedBy: "/").last ?? "-1")  ?? -1)
        setupDetail()
    }
    
    func setupDetail() {
        PokemonApiManager.shared.getPokemonDetail(url: url) {[weak self] detail, error in
         
            guard let self = self else {
                print("detail asdf found at = " )
                return
            }
            if let detail = detail{
               
                self.detail = detail
                self.detail?.updateData(name: self.name)
                print("detail was found at = " ,self.url)
            }else{
                print("detail was nil for = " ,self.url)
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(detail, forKey: .detail)
    }
    
}
 

extension Array where Element == Pokemon {
    func save(){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        
        //We need to create a context from this container
        let managedContext = APPDELEGATE.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        do {
                    try managedContext.save()
                   
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
        
    }

    
}

extension PokemonDetail  {
func updateData(name:String){
 
     //As we know that container is set up in the AppDelegates so we need to refer that container.
     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
     
     //We need to create a context from this container
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Pokemon")
     fetchRequest.predicate = NSPredicate(format: "name = %@",name)
     do
     {
         let test = try managedContext.fetch(fetchRequest)

             let objectUpdate = test[0] as! NSManagedObject
             objectUpdate.setValue(self, forKey: "detail")
             do{
                 try managedContext.save()
             }
             catch
             {
                 print(error)
             }
         }
     catch
     {
         print(error)
     }
 }
}
extension Pokemon{
   static func fetchFromStorage() -> [Pokemon] {
        let managedObjectContext = APPDELEGATE.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Pokemon>(entityName: "Pokemon")
        fetchRequest.fetchLimit = MODEL_RESULT_LIMIT

    if CONTENT_OFFSET == 0 {
        fetchRequest.predicate = NSPredicate(format: "number > \(CONTENT_OFFSET - 1)")
    }else{
        fetchRequest.predicate = NSPredicate(format: "number > \(CONTENT_OFFSET)")
    }
    let sortDescriptor1 = NSSortDescriptor(key: "number", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            let pokemons = try managedObjectContext.fetch(fetchRequest)
            return pokemons
        } catch let error {
            print(error)
            return []
        }
    }
}
