//
//  CoreDataContainer.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import Foundation
import CoreData

class CoreDataContainer {
	public static let shared = CoreDataContainer()
	
	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "FlickrPhotoCoreData")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving support
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
