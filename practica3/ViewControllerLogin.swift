//
//  ViewControllerLogin.swift
//  practica3
//
//  Created by DISMOV on 08/06/22.
//

import UIKit

class ViewControllerLogin: UIViewController {

    @IBOutlet weak var Correo: UITextField!
    @IBOutlet weak var Contraseña: UITextField!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let login = defaults.bool(forKey: "Login")
        if(login){
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = sb.instantiateViewController(withIdentifier: "Home")
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func IniciarSesion(_ sender: Any) {
        var message = ""
        if let url = Bundle.main.url(forResource: "USER_DATA", withExtension: "json") {
               do {
                 let bytes = try Data.init(contentsOf: url)
                 let jsonArray = try JSONSerialization.jsonObject(with:bytes, options:.mutableContainers) as! [[String:Any]]
                 let filteredArray = jsonArray.filter{
                   dictionary in
                   return dictionary["user_name"] as! String == self.Correo.text!
                 }
                 if filteredArray.count == 0 {
                   message = "El usuario no existe"
                 }
                 else {
                   let userInfo = filteredArray.first!
                   if (userInfo["password"] as! String) != self.Contraseña.text! {
                     message = "El password no coincide"
                   }
                 }
               }
               catch {
                 
               }
         }
        if message == ""{
            defaults.set(true, forKey: "Login")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = sb.instantiateViewController(withIdentifier: "Home")
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
