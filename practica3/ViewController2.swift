//
//  ViewController2.swift
//  practica3
//
//  Created by DISMOV on 07/04/22.
//

import UIKit
import AVFoundation

class ViewController2: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ingredients: UITextField!
    @IBOutlet weak var directions: UITextField!
    @IBOutlet weak var ivFoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent("Private")
        do{
            try FileManager.default.createDirectory(atPath: urlAlArchivo.path, withIntermediateDirectories: false)
        }
        catch{
            print("Algo salio mal")
        }
    }
    

    @IBAction func Guardar(_ sender: Any) {
        let bandera = DataManager.instance.guarda(Name.text ?? "", ingredients.text ?? "", directions.text ?? "",Name.text ?? "")
        if(!bandera){
            let alert = UIAlertController(title: "Error", message: "Algo fallo al Guardar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = sb.instantiateViewController(withIdentifier: "Home")
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)

        
    }
    
    
    @IBAction func seleccionaImagen(_ sender: Any) {
        // variable local
        let ipc = UIImagePickerController()
        /* para trabajar con la galería
        ipc.sourceType = .photoLibrary
        */
        ipc.delegate = self
        // permitir edición
        ipc.allowsEditing = true
        // consultamos si la cámara esta disponible
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Se requiere la llave Privacy - Camer Usage Description en el archivo info.plist
            ipc.sourceType = .camera
            // Validar permiso de uso de la cámara
            let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized {
                self.present(ipc, animated: true,  completion: nil)
            }
            else {
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        if respuesta {
                            self.present(ipc, animated: true,  completion: nil)
                        }
                        else {
                            // cerrar la app?
                            // mostrar alert?
                            print ("no se que hacer  :(")
                        }
                    }
                }
                else {  // .denied
                    let alert = UIAlertController(title: "Error", message: "Debe autorizar el uso de la cámara desde el app de configuración. Quieres hacerlo ahora?", preferredStyle:.alert)
                    let btnSI = UIAlertAction(title: "Si, por favor", style: .default) { action in
                        // lanzar el app de settings:
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alert.addAction(btnSI)
                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true,  completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print ("seleccionó")
        if let imagen = info[.editedImage] as? UIImage {
            // Cambiar la resolución de la imagen
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), true, 0.75)
            imagen.draw(in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            let nuevaImagen = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            ivFoto.image = nuevaImagen
            let data = nuevaImagen!.pngData()
            self.guardaImagen(data!, Name.text ?? "")
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    func guardaImagen(_ bytes:Data, _ nombre: String){
        let urlAdocs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent("Private/\(nombre)")
        do{
            try bytes.write(to: urlAlArchivo)
        }
        catch {
            print("no se puede salvar la imagen\(error.localizedDescription)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("canceló")
        picker.dismiss(animated: true, completion: nil)
    }

}
