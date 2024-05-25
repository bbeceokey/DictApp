//
//  CoreDataManager.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func saveContext()
    func fetchData() -> [WordData]?
    func saveRecentSearch(name: String)
    func deleteWordData(_ data: WordData)
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "DictApp")
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
    }
    
    func saveRecentSearch(name: String) {
        let fetchData = fetchData()
        let context = persistentContainer.viewContext
        
        guard !name.isEmpty else { return }
        if let existingData = fetchData?.filter({ $0.name == name }), !existingData.isEmpty {
            for item in existingData {
                context.delete(item)
            }
            saveContext()
        }
        let wordData = WordData(context: context)
        wordData.name = name
        saveContext()
    }


    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("core data ya eklendi")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [WordData]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WordData> = WordData.fetchRequest()
        do {
            let data = try context.fetch(fetchRequest)
            return data
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteWordData(_ data: WordData) {
        persistentContainer.viewContext.delete(data)
        saveContext()
    }
}
