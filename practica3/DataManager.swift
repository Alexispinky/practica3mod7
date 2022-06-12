//
//  DataManager.swift
//  practica3
//
//  Created by DISMOV on 06/04/22.
//

import Foundation
import CoreData


class DataManager:NSObject {
    
    
    lazy var managedObjectModel:NSManagedObjectModel? = {
        let modelURL = Bundle.main.url(forResource:"practica3", withExtension: "momd")
        var model = NSManagedObjectModel(contentsOf: modelURL!)
        return model
    }()
    
    lazy var persistentStore:NSPersistentStoreCoordinator? = {
        let model = self.managedObjectModel
        if model == nil {
            return nil
        }
        let persist = NSPersistentStoreCoordinator(managedObjectModel: model!)
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let urlDeLaBD = URL(fileURLWithPath:documents + "/" + "practica3" + ".sqlite")
        do {
            let opcionesDePersistencia = [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true]
            try persist.addPersistentStore(ofType: NSSQLiteStoreType, configurationName:nil, at:urlDeLaBD, options:opcionesDePersistencia)
        }
        catch {
            print ("no se puede abrir la base de datos")
            // abort() // es muy dramático...
            exit(666)
        }
        return persist
    }()
    
    
    lazy var managedObjectContext:NSManagedObjectContext? = {
        var moc: NSManagedObjectContext?
        /*if #available(iOS 10.0, *){
            // Si es iOS 10 o posterior, los objetos NSManagedObjectModel y NSPersistentStoreCoordinator no son instanciados. En su lugar se instancia el objeto NSPersistentContainer que tiene un NSManagedObjectContext integrado, en su propiedad viewContext
            moc = self.persistentContainer.viewContext
        }
        else{ */
            // Si es iOS 9 o anterior, se deben instanciar los objetos NSManagedObjectModel y NSPersistentStoreCoordinator
            let persistence = self.persistentStore
            if persistence == nil {
                return nil
            }
            moc = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
            moc?.persistentStoreCoordinator = persistence
        //}
        return moc
    }()
    
    static let instance = DataManager()
    var dictPlist = [[String:String]]()
    
    
    func guarda(_ name:String, _ ingredients: String, _ instruction: String,_ namedrink: String)-> Bool{
        if let entidad = NSEntityDescription.entity(forEntityName:"Bebidas", in:managedObjectContext!) {
            let unaBebida = NSManagedObject(entity: entidad, insertInto: managedObjectContext!) as! Bebidas
            // asignamos sus propiedades
            unaBebida.name = name
            unaBebida.ingredients = ingredients
            unaBebida.directions = instruction
            unaBebida.image = namedrink
            // guardamos el objeto
            do {
                try managedObjectContext?.save()
                return true
            }
            catch {
                print ("No se puede guardar a la BD \(error.localizedDescription)")
            }
        }
        return false
    }
    
    // se sobreescribe el constructor como privado, para evitar la instanciacion
    private override init() {
        super.init()
        let ud = UserDefaults.standard
        let bandera = (ud.value(forKey: "infoOK") as? Bool) ?? false
        if !bandera {
            cargaArchivos()
        }
    }
    
    
    
    func cargaArchivos()
    {
        let ud = UserDefaults.standard
        let bandera = (ud.value(forKey: "infoOK") as? Bool) ?? false
        if !bandera {
            if let archivo = Bundle.main.url(forResource: "Drinks", withExtension:  "plist"){
                do{
                    let bytes = try Data.init(contentsOf: archivo)
                    let tmp = try PropertyListSerialization.propertyList(from: bytes,options: .mutableContainers, format: nil)
                    dictPlist = tmp as! [[String:String]]
                    llenabd(dictPlist)
                    ud.set(true, forKey: "infoOK")
                    ud.synchronize()
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func llenabd(_ lista: [[String:String]]){
        guard let entityDesc = NSEntityDescription.entity(forEntityName: "Bebidas", in: managedObjectContext!)
        else{
            return
        }
        
        for bebida in lista {
            let b = NSManagedObject(entity: entityDesc, insertInto: managedObjectContext) as! Bebidas
            b.inicializaCon(bebida)
            do {
                try managedObjectContext?.save()
            }
            catch{
                print ("No se puede guardar a la BD \(error.localizedDescription)")
            }
            
        }
    }
    
    func obtenerDatos() -> [Bebidas] {
        var resul = [Bebidas]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bebidas")
        do{
            let tmp = try managedObjectContext!.fetch(request)
            resul = tmp as! [Bebidas]
        }
        catch{
            print ("fallo el request \(error.localizedDescription)")
        }
        return resul
    }
    
    func Eliminar(_ bebida: Bebidas){
        var result = [Bebidas]()
        //print(bebida)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bebidas")
        let filtro = NSPredicate(format: "name == %@",bebida.name!)
        request.predicate = filtro
        do{
            let tmp = try managedObjectContext!.fetch(request)
            result = tmp as! [Bebidas]
            try managedObjectContext?.delete(result[0])
            try managedObjectContext?.save()
        }
        catch{
            print ("Algo fallo \(error.localizedDescription)")
        }
    }
    
    
}
