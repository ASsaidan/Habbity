//
//  AddNewHabitViewController.swift
//  Habbity
//
//  Created by A.S on 2024-05-02.
//

import UIKit

class AddNewHabitViewController: UIViewController {
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addNewHabitClicked(_ sender: UIButton) {
    }
    @IBAction func uploadImageClicked(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true, completion: nil)
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

extension AddNewHabitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImageView.image = pickedImage
            self.selectedImageView.layer.cornerRadius = self.selectedImageView.frame.size.width / 9
    }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
