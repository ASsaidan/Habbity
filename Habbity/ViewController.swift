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
    var selectedCell: CollectionViewCell?
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Habits list is empty"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        db.collection("habits").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.habits = documents.map { (queryDocumentSnapshot) -> Habit in
                let data = queryDocumentSnapshot.data()
                print("Fetched habit data: \(data)")
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
        let count = habits.count
        emptyLabel.isHidden = count != 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let habit = habits[indexPath.row]
        cell.configureCell(with: habit, collectionView: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
    
    func updateStreakCount(for habit: Habit, streakCount: Int) {
        let db = Firestore.firestore()
        
        let habitRef = db.collection("habits").document(habit.documentID)
        
        habitRef.updateData([
            "streakCount": streakCount
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
