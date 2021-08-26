//
//  PokemonApiManager.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import Foundation

struct PokemonApiManager {
    
   static let shared  = PokemonApiManager()
    
  func getRequest(url : URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: [], options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
      func getRawPokemonListResult(offset : Int, limit : Int,callback : @escaping (_ results :NetworkResponse) -> Void) {
        
        let request = getRequest(url : URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=\(limit)")!)
     
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            ///response
            guard error == nil else {
                if let urlError = error as? URLError,
                   urlError.code == .timedOut {
                    callback(.timeout("API request timeout"))
                }
                callback(.faliure(error!))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                if let httpResponse = response as? HTTPURLResponse {
                    callback(.badCode(httpResponse.statusCode))
                } else {
                    callback(.invalid("Invalid response from the API"))
                }
                return
            }
            guard let data = data else {
//                Helper.debugLogs(anyData: "Data not recieved", andTitle: "Error")
                callback(.invalid("Data not recieved"))
                return
            }
            
                DispatchQueue.main.async {
                    do {
                        
                        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                            fatalError("Failed to retrieve managed object context")
                        }
                        let managedObjectContext = APPDELEGATE.persistentContainer.viewContext
                        let decoder = JSONDecoder()
                        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                        
                        let listPokemon = try decoder.decode(RawPokemonListResult.self, from: data)
                        //                    print(listPokemon)
                        listPokemon.pokemons.save()
                        callback(.success(listPokemon.pokemons))
                        
                    } catch let error {
                        callback(.invalid(error.localizedDescription))
                    }
                }
        }
        task.resume()
    }
    
      func getPokemonDetail(url : URL,callback : @escaping (_ pokemonDetail : PokemonDetail?, _ error : Error?) -> Void) {
        
        let request = getRequest(url : url)
     
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                            fatalError("Failed to retrieve managed object context")
                        }
                        let managedObjectContext = APPDELEGATE.persistentContainer.viewContext
                        let decoder = JSONDecoder()
                        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                        
                        let pokemonDetail = try  decoder.decode(PokemonDetail.self, from: data)
                        //                    print(pokemonDetail)
                        callback(pokemonDetail,nil)
                        
                    } catch let error {
                        callback(nil,error)
                    }
                }
            }else{
              let error =  NSError.getWith(description: "did not get response")
                callback(nil,error)
            }
        }
        task.resume()
    } 
}
