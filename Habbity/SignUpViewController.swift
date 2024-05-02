//
//  SignUpViewController.swift
//  Habbity
//
//  Created by A.S on 2024-05-02.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    @IBAction func signUpClicked(_ sender: UIButton) {
    
    guard let email = usernameTextField.text else { return }
    guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
        if let e = error {
                print("error")
            }
            else {
                // Go to our home screen
                self.performSegue (withIdentifier: "goToNext", sender: self)
            }
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

}
