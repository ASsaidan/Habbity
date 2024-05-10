//
//  ViewController.swift
//  Habbity
//
//  Created by A.S on 2024-05-01.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage


class ViewController: UIViewController {
    
    @IBOutlet weak var addNewHabit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var habits: [Habit] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Observe the habits collection in Firestore
        db.collection("habits").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.habits = documents.map { (queryDocumentSnapshot) -> Habit in
                let data = queryDocumentSnapshot.data()
                let habit = Habit(dictionary: data)
                return habit
            }
            
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddNewHabit" {
            let addNewHabitVC = segue.destination as! AddNewHabitViewController
            addNewHabitVC.title = "Add New Habit"
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let habit = habits[indexPath.row]
        cell.pTitle.text = habit.title
        cell.imageView.sd_setImage(with: URL(string: habit.imageURL))
        cell.statusSwitcher.isOn = habit.status
        cell.habit = habit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
}
