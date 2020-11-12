//
//  DemoViewModel.swift
//  practicalencore
//
//  Created by Mac Mini on 12/11/20.
//  
//

import Foundation
import CoreData

class AudioListViewModel: BaseViewModel {
    var albumModel: [AlbumModel] = []
    var elementName: String = String()
    
    var aTitle = String()
    var aArtist = String()
    var aName = String()
    var aLink = String()
    var aCategory = String()
    var aImage = String()
    
    var coreDataUtill = CoreDataFunctions()
    var albums: [NSManagedObject] = []
    
    func fetchAlbumList() {
        albums = coreDataUtill.fetchAlbumList()
    }
    
    func saveAlbumToDataBase(completion: @escaping (Bool) -> ()) {
        for index in 0..<self.albumModel.count {
            let item  = self.albumModel[index]
            DispatchQueue.main.async {
                self.coreDataUtill.save(title: item.title, name: item.name, link: item.link, artist: item.artist, category: item.category, image: item.image)
            }
            if index == 19 {
                completion(true)
            }
        }
    }
    func callAlbulListAPI(completion: @escaping (Bool) -> ()) {
        let task = URLSession.shared.dataTask(with: URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=20/xml")!) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                
                print(self.albumModel.count)
                if self.albumModel.count == 20 {
                    self.saveAlbumToDataBase { (status) in
                        completion(true)
                    }
                }
            }
        }
        task.resume()
    }
}

extension AudioListViewModel: XMLParserDelegate {
    
    // Did Start Element Method
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "entry" {
            aTitle = String()
            aName = String()
            aArtist = String()
            aLink = String()
            aCategory = String()
            aImage = String()
        }
        if elementName == "link" {
            if let href = attributeDict["href"] {
                if href.contains("plus.aac.p.m4a") {
                    aLink = href
                }
            }
        }
        if elementName == "category" {
            if let term = attributeDict["term"] {
                aCategory = term
            }
        }

        self.elementName = elementName
    }

    // Found characters Method
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                aTitle += data
            } else if self.elementName == "im:name" {
                aName += data
            } else if self.elementName == "im:artist" {
                aArtist += data
            } else if self.elementName == "link" {
//                aLink += data
            } else if self.elementName == "category" {
//                aCategory += data
            } else if self.elementName == "im:image" {
                if string.contains("170x170bb") {
                    aImage += data
                }
            }
        }
    }

    // Did End Element Method
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            let album = AlbumModel(title: aTitle, name: aName, link: aLink, artist: aArtist, category: aCategory, image: aImage)
            albumModel.append(album)
        }
    }

}
