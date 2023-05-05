//
//  CoreDataManager.swift
//  LuLuLemonProjectSwiftUI
//
//  Created by Talor Levy on 3/24/23.
//

import Foundation
import CoreData


class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    var garmentList: [Garment] = []

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent container failure: \(error)")
            }
        })
        return container
    }()

    func saveContext (context: NSManagedObjectContext, completion: () -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                let error = error
                context.rollback()
                fatalError("Save context failure: \(error)")
            }
        }
    }

    func fetchGarmentsFromCoreData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Garment> = Garment.fetchRequest()
        do {
            garmentList = try context.fetch(fetchRequest)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func sortGarmentList(segment: SegControl) {
        var sortedGarments = garmentList
        switch segment {
        case .alphabetic:
            sortedGarments.sort { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
        case .creationTime:
            sortedGarments.sort { $0.creationTime ?? Date() < $1.creationTime ?? Date()}
        }
        garmentList = sortedGarments
    }

    func addGarment(name: String) {
        let context = persistentContainer.viewContext
        let garment = Garment(context: context)
        garment.name = name
        garment.creationTime = Date()
        saveContext(context: context) {
            garmentList.append(garment)
        }
    }

    func deleteGarment(garment: Garment) {
        let context = persistentContainer.viewContext
        context.delete(garment)
        saveContext(context: context) {
            if let index = garmentList.firstIndex(of: garment) {
                garmentList.remove(at: index)
            }
        }
    }

    func updateGarment(garment: Garment, updatedName: String) {
        let context = persistentContainer.viewContext
        garment.name = updatedName
        saveContext(context: context) {
            if let index = garmentList.firstIndex(where: { $0.creationTime == garment.creationTime }) {
                garmentList[index].name = updatedName
            }
        }
    }
}



//class CoreDataManager {
//
//    static let shared = CoreDataManager()
//    private init() {}
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "CoreData")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                fatalError("Persistent container failure: \(error)")
//            }
//        })
//        return container
//    }()
//
//    func saveContext (context: NSManagedObjectContext) {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let error = error
//                fatalError("Save context failure: \(error)")
//            }
//        }
//    }
//
//    func fetchGarmentsFromCoreData() -> [Garment] {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Garment> = Garment.fetchRequest()
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    func addGarment(name: String) {
//        let context = persistentContainer.viewContext
//        let garment = Garment(context: context)
//        garment.name = name
//        garment.creationTime = Date()
//        saveContext(context: context)
//    }
//
//    func deleteGarment(garment: Garment) {
//        persistentContainer.viewContext.delete(garment)
//        do {
//            try persistentContainer.viewContext.save()
//        } catch {
//            persistentContainer.viewContext.rollback()
//            print("Failed: \(error)")
//        }
//    }
//
//    func updateGarment(garment: Garment, updatedName: String) {
//        let context = persistentContainer.viewContext
//        garment.name = updatedName
//        saveContext(context: context)
//    }
//}
