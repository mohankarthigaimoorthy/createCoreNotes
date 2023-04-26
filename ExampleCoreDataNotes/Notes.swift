//
//  Notes.swift
//  ExampleCoreDataNotes
//
//  Created by Mohan K on 17/03/23.
//

import Foundation
import UIKit
import CoreData

@objc(Note)
public class Note: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged var dateAdded: Date?
    @NSManaged var noteText: String?
    @NSManaged var priorityColor: UIColor?
}

extension Note: Identifiable {}
