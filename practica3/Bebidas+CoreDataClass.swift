//
//  Bebidas+CoreDataClass.swift
//  practica3
//
//  Created by DISMOV on 07/04/22.
//
//

import Foundation
import CoreData

@objc(Bebidas)
public class Bebidas: NSManagedObject {

    func inicializaCon (_ dict: [String:String]){
        let nombre = (dict["name"]) ?? ""
        let ingredientes = (dict["ingredients"]) ?? ""
        let instructions = (dict["directions"]) ?? ""
        let image = (dict["image"]) ?? "drinks"
        self.name = nombre
        self.ingredients = ingredientes
        self.directions = instructions
        self.image = image
    }
    
}
