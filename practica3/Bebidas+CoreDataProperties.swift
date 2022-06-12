//
//  Bebidas+CoreDataProperties.swift
//  practica3
//
//  Created by DISMOV on 07/04/22.
//
//

import Foundation
import CoreData


extension Bebidas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bebidas> {
        return NSFetchRequest<Bebidas>(entityName: "Bebidas")
    }

    @NSManaged public var image: String?
    @NSManaged public var directions: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var name: String?

}

extension Bebidas : Identifiable {

}
