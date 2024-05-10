//
//  AddNewHabitViewController.swift
//  Habbity
//
//  Created by A.S on 2024-05-02.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class AddNewHabitViewController: UIViewController {
    
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addNewHabitClicked(_ sender: UIButton) {
        guard let habitName = habitNameTextField.text, !habitName.isEmpty else {
            showAlert(title: "Error", message: "Please enter a habit name.")
            return
        }
        
        guard let habitImage = selectedImageView.image else {
            showAlert(title: "Error", message: "Please select an image for the habit.")
            return
        }
        
        let imageData = habitImage.pngData()!
        let imageName = UUID().uuidString + ".png"
        let storageRef = Storage.storage().reference().child("habit_images/\(imageName)")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {
                    return
                }
                
                let newDocumentID = self.db.collection("habits").document().documentID
                
                
                let newHabit: [String: Any] = [
                    "id": newDocumentID,
                    "title": habitName,
                    "imageURL": imageUrl,
                    "status": false,
                    "streakCount": 0
                ]
                
                self.db.collection("habits").document(newDocumentID).setData(newHabit) { (error) in
                    if let error = error {
                        print("Error saving habit: \(error.localizedDescription)")
                    } else {
                        print("Habit saved successfully")
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func uploadImageClicked(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddNewHabitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView.image = pickedImage
            selectedImageView.layer.cornerRadius = selectedImageView.frame.size.width / 9
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
