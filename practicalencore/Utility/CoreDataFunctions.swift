//
//  CoreDataFunctions.swift
//  practicalencore
//
//  Created by Mac Mini on 12/11/20.
//

import UIKit
import CoreData

class CoreDataFunctions: NSObject {
    var albums: [NSManagedObject] = []
    
    func fetchAlbumList() -> [NSManagedObject] {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Album")
        
        //3
        do {
            albums = try managedContext.fetch(fetchRequest)
            return albums
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func save(title: String, name: String, link: String, artist: String, category: String, image: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Album",
                                       in: managedContext)!
        
        let album = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        album.setValue(name, forKeyPath: "name")
        album.setValue(link, forKeyPath: "link")
        album.setValue(category, forKeyPath: "category")
        album.setValue(artist, forKeyPath: "artist")
        album.setValue(title, forKeyPath: "title")
        album.setValue(image, forKeyPath: "image")
        
        do {
            try managedContext.save()
            albums.append(album)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData(entity: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if #available(iOS 9, *)
        {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
            }
            catch
            {
                print("There was an error:\(error)")
            }
        }
        else
        {
            do{
                let deleteRequest = try managedContext.fetch(deleteFetch)
                for anItem in deleteRequest {
                    managedContext.delete(anItem as! NSManagedObject)
                }
            }
            catch
            {
                print("There was an error:\(error)")
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
