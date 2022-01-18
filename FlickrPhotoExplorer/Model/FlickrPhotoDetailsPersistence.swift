//
//  FlickrPhotoDetailsPersistence.swift
//  FlickrPhotoExplorer
//
//  Created by Elijah Tristan H. Chan on 1/16/22.
//

import UIKit
import CoreData

// MARK: - Core data stack -
class FlickrPhotoDetailsPersistence: NSObject {
	public static let shared = FlickrPhotoDetailsPersistence()
	let imageCache = NSCache<NSString, UIImage>()
	
	func loadImageFromCache(key: String) -> UIImage? {
		if let filePath = self.filePath(forKey: key), let fileData = FileManager.default.contents(atPath: filePath.path), let image = UIImage(data: fileData) {
			return image
		}
		return nil
	}
	
	func saveImageToCache(key: String, image: UIImage) {
		guard let imageData = image.pngData() else {
			return
		}
		if let filePath = filePath(forKey: key) {
			do  {
				try imageData.write(to: filePath, options: .atomic)
			} catch let err {
				print("Saving file resulted in error: ", err)
			}
		}
	}
	
	private func filePath(forKey key: String) -> URL? {
		let fileManager = FileManager.default
		
		guard let documentURL = fileManager.urls(for: .documentDirectory,
													in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
		
		return documentURL.appendingPathComponent(key + ".png")
	}
	
	func saveContext(forContext context: NSManagedObjectContext) {
		if context.hasChanges {
			context.performAndWait {
				do {
					try context.save()
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func save(photoDetails: FlickrPhotoInfo) {
			let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
			let entity = NSEntityDescription.entity(forEntityName: "FlickrPhotoDetailEntity", in: managedContext)!
			let avatar = NSManagedObject(entity: entity, insertInto: managedContext)
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotoDetailEntity")
			let predicate = NSPredicate(format: "id = %@", photoDetails.id)
			fetchRequest.predicate = predicate
			
			let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
			backgroundContext.parent = managedContext
			
			backgroundContext.performAndWait {
				do {
					let object = try managedContext.fetch(fetchRequest)
					if object.count == 0 {
						avatar.setValue(photoDetails.id, forKey: "id")
						avatar.setValue(photoDetails.secret, forKey: "secret")
						avatar.setValue(photoDetails.title, forKey: "title")
						avatar.setValue(photoDetails.server, forKey: "server")
						avatar.setValue(photoDetails.owner, forKey: "owner")

						saveContext(forContext: backgroundContext)
					}
					else {
						return
					}
				}
				catch {
					print(error.localizedDescription)
				}
				saveContext(forContext: managedContext)
			}
		}
		
		func delete(photoDetails: FlickrPhotoInfo) {
			let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotoDetailEntity")
			
			let predicate = NSPredicate(format: "id = %@", photoDetails.id)
			fetchRequest.predicate = predicate
			
			let objects = try! managedContext.fetch(fetchRequest)
			for obj in objects {
				managedContext.delete(obj as! NSManagedObject)
			}

			do {
				try managedContext.save() // <- remember to put this :)
			} catch {
				// Do something... fatalerror
			}
		}
		
		func deleteAllData() {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrPhotoDetailEntity")
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			let persistentContainer = CoreDataContainer.shared.persistentContainer
			
			do {
				try persistentContainer.viewContext.execute(deleteRequest)
			} catch let error as NSError {
				print(error)
			}

		}
	
	func checkIfPhotoInfoExist(id: String) -> Bool {
		let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FlickrPhotoDetailEntity")
		fetchRequest.fetchLimit =  1
		let predicate = NSPredicate(format: "id = %@", id)
		fetchRequest.predicate = predicate
		
		do {
			let count = try managedContext.count(for: fetchRequest)
			if count > 0 {
				return true
			}else {
				return false
			}
		}catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
			return false
		}
	}
		
		func retrievePhotoInfosFromCache(completion: @escaping (_ success: Bool, _ photoInfos: [FlickrPhotoInfo]) -> ()) {
			let managedContext = CoreDataContainer.shared.persistentContainer.viewContext
			
			let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FlickrPhotoDetailEntity")
			do {
				let managedUsers = try managedContext.fetch(fetchRequest)
				var photoDetails: [FlickrPhotoInfo] = []
				for managedUser in managedUsers {
					let photoDetail = FlickrPhotoInfo()
					photoDetail.id = managedUser.value(forKeyPath: "id") as! String
					photoDetail.secret = managedUser.value(forKeyPath: "secret") as! String
					photoDetail.title = managedUser.value(forKeyPath: "title") as! String
					photoDetail.server = managedUser.value(forKeyPath: "server") as! String
					photoDetail.owner = managedUser.value(forKeyPath: "owner") as! String
					
					if photoDetail.id != "-1" {
						photoDetails.append(photoDetail)
					}
				}
				completion(true, photoDetails)
			}
			catch let error as NSError {
				print("Could not fetch. \(error), \(error.userInfo)")
			}
		}
}
