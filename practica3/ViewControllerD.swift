//
//  ViewControllerD.swift
//  practica3
//
//  Created by DISMOV on 29/03/22.
//

import UIKit


class ViewControllerD: UIViewController {
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Ingredients: UITextView!
    @IBOutlet weak var Instructions: UITextView!
    @IBOutlet weak var scroll: UIScrollView!
    
    var bebida = Bebidas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Ingredients.isEditable = false
        Instructions.isEditable = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Name.text = bebida.name
        Ingredients.text = bebida.ingredients
        Instructions.text = bebida.directions
        if(bebida.image?.count ?? 0 < 7){
            Image.image = UIImage(named: bebida.image ?? "")
        }
        else{
            cargaImagenLocal(bebida.image ?? "")
        }
    }
    
    
    
    
    func cargaImagenLocal (_ nombre: String){
        //obtener ruta del documento
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent("Private/\(nombre)")
        //comprobar si el archivo existe
        if(FileManager.default.fileExists(atPath: urlAlArchivo.path)){
            do{
                let bytes = try Data(contentsOf: urlAlArchivo)
                let image = UIImage(data: bytes)
                Image.image = image
            }
            catch{
                print("Algo salio mal\(error.localizedDescription)")
            }
            
        }
        else{
            
        }
    }
    
    /*override func viewWillLayoutSubviews() {
        scroll.contentLayoutGuide.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: 0).isActive = true
        scroll.contentLayoutGuide.heightAnchor.constraint(equalTo:scroll.frameLayoutGuide.heightAnchor, constant: 20).isActive = true
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Eliminar(_ sender: UIButton) {
        DataManager.instance.Eliminar(bebida)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let mainController = presentingViewController as? ViewController {
            DispatchQueue.main.async {
                mainController.datos = DataManager.instance.obtenerDatos()
                mainController.tableView.reloadData()
                
                //DataManager.instance.obtenerDatos()
                //mainController.viewWillAppear(true)
            }
        }
    }
}
