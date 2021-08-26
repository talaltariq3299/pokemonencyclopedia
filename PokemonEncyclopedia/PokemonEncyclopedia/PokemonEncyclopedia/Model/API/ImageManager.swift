//
//  ImageManager.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//
 
import Foundation
//import AVFoundation
import AssetsLibrary
import Photos
//import Combine


class ImageCacheManager {
    
   private let fileManager = FileManager.default
    
    func getImage(imageURL: URL , callback: @escaping (Result<URL>) -> Void ) {
//        print("getFileWith (imageURL : URL")
        DispatchQueue.global(qos:.background).async {
            //so the given imageURL is going to be downloaded or will be get from the dir so no need to for the current calle to add a subscription for the update
//            self.removeSubcriberIfExist(imageURL)
            
            guard  let file = self.directoryFor(imageURL: imageURL) else{
                let error = NSError.getWith(description: "did not get url for doc")
                callback(Result.failed(error))
                return
            }
            
            //return file path if already exists in cache directory
            guard !self.fileManager.fileExists(atPath: file.path)  else {
                callback(Result.successfull(file))
                return
            }
            
            guard let documentsDirectoryURL = self.docDirectoryURL else { return }
        
            URLSession.shared.downloadTask(with: imageURL) { (tmpURL, response, error ) in 
                guard let tmpURL = tmpURL  else {
                    return
                    
                }
                let imageName = imageURL.lastPathComponent
                let destinationURL = documentsDirectoryURL.appendingPathComponent(imageName)
                self.moveFileFrom(sourceUrl: tmpURL, to: destinationURL) { result in
                    callback(result)
                }
                
            }.resume()
        }
    }
     
    
    private func moveFileFrom(sourceUrl : URL, to destinationUrl : URL , callback: @escaping (Result<URL>) -> Void) {
        
        do {
            try FileManager.default.moveItem(at: sourceUrl, to: destinationUrl)
            callback(Result.successfull(destinationUrl))
            //             try? FileManager.default.removeItem(at: locationUrl)
        } catch {
            callback(Result.failed(error))
            print("Result.failure(error)",error.localizedDescription)
        }
        
    }
    
    private func directoryFor(imageURL: URL) -> URL? {
        let fileURL = imageURL.lastPathComponent 
        if  let file = self.docDirectoryURL?.appendingPathComponent(fileURL){
            return file
        }
        return nil
    }
     
    
    private lazy var docDirectoryURL: URL? = {
        guard let documentDirectoryURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{  return nil  }
        
        let docUrl = documentDirectoryURL.appendingPathComponent("Images")
        if !FileManager.default.fileExists(atPath: docUrl.path) {
            do {
                try FileManager.default.createDirectory(atPath: docUrl.path, withIntermediateDirectories: true, attributes: nil)
                return docUrl
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }else{
            return docUrl
        }
    }()
     
    
    static let shared = ImageCacheManager()
    
    public enum Result<T> {
        case successfull(T)
        case failed(Error)
    }
    
}

extension URL {
    
    var secondLast : String? {
        let count = self.pathComponents.count
        return count > 1 ? (self.pathComponents[count-2]+".png") : nil
    }
}
