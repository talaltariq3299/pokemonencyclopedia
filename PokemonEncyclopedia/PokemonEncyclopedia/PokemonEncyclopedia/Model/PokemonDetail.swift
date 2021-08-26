//
//  PokemonDetail.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import Foundation
import CoreData

class PokemonDetail: NSManagedObject, Codable {
    
    @NSManaged var abilities : [String]
    @NSManaged var imageURL : URL?
    @NSManaged var height  : Int64
    @NSManaged var weight  : Int64
    @NSManaged var baseExperience  : Int64
    @Published var imageFileURL : URL?
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case sprites
        case height
        case weight
        case baseExperience = "base_experience"
        case imageURL
    }
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        if imageURL != nil {
            setupImagelocalPath()
        }
        
    }
    required convenience init(from decoder: Decoder) throws {
        
      
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "PokemonDetail", in: managedObjectContext) else {
            fatalError("Failed to decode PokemonDetail")
        }


        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        abilities = try values.decode([Ability].self, forKey: .abilities).map{$0.ability.name}
        imageURL = try values.decodeIfPresent(Sprites.self, forKey: .sprites)?.other.officialArtwork.frontDefault.possibleURL
     
        height =  try values.decodeIfPresent(Int64.self, forKey: .height)  ?? -1
        weight =  try values.decodeIfPresent(Int64.self, forKey: .weight) ?? -1
        baseExperience =  try values.decodeIfPresent(Int64.self, forKey: .baseExperience)  ?? -1
        setupImagelocalPath()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(abilities, forKey: .abilities)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(baseExperience, forKey: .baseExperience)
    }
    
    func setupImagelocalPath( ) {
        if let imageURL = imageURL {
            print("imageURL = ",imageURL.absoluteString)
            ImageCacheManager.shared.getImage(imageURL: imageURL ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .successfull(let url):
                        self.imageFileURL = url
//                        self.updateData(name: name)
                        print("got image",url)
                    case .failed(let error):
                        print(error)
                        assert(false, "dont knwo what happend")
                    }
                }
            }
        }else{
            print("asdf")
        }
    }
    
}
public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
