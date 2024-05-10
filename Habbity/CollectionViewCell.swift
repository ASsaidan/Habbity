//  CollectionViewCell.swift
//  Habbity
//
//  Created by A.S on 2024-05-01.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var streakTitle: UILabel!
    @IBOutlet weak var statusSwitcher: UISwitch!
    
    let goodJobLabel: UILabel = {
        let label = UILabel()
        label.text = "Good Job"
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.systemMint
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var habit: Habit?
    let db = Firestore.firestore()
    var streakCount: Int = 0 {
        didSet {
            updateStreakTitle()
        }
    }
    var collectionView: UICollectionView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusSwitcher.isOn = false
        
        contentView.addSubview(goodJobLabel)
        NSLayoutConstraint.activate([
            goodJobLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            goodJobLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        statusSwitcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    func configureCell(with habit: Habit, collectionView: UICollectionView) {
        guard !habit.documentID.isEmpty else {
            print("Error: habit document ID is empty")
            return
        }
        
        pTitle.text = habit.title
        imageView.sd_setImage(with: URL(string: habit.imageURL))
        statusSwitcher.isOn = habit.status
        streakTitle.text = "Day \(streakCount)/7"
        self.habit = habit
        self.collectionView = collectionView
    }
    
    func updateStreakTitle() {
        if streakCount == 0 {
            streakTitle.text = "Start Streak"
        } else {
            streakTitle.text = "Day \(streakCount)/7"
        }
    }
    
    @objc func switchValueChanged() {
        guard let habit = self.habit, !habit.documentID.isEmpty else {
            print("Error: Habit is nil or ID is empty")
            return
        }
        
        let habitRef = db.collection("habits").document(habit.documentID)
        
        if statusSwitcher.isOn {
            streakCount += 1  
        } else {
            streakCount = 0
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.goodJobLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                self.goodJobLabel.alpha = 0
            }, completion: { _ in
                self.statusSwitcher.isOn = false
            })
        }
        
        let updatedData: [String: Any] = [
            "status": statusSwitcher.isOn,
            "streakCount": streakCount
        ]
        
        habitRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating habit: \(error.localizedDescription)")
            } else {
                self.habit?.status = self.statusSwitcher.isOn
                self.habit?.streakCount = self.streakCount
                self.updateStreakTitle()
                
                if self.streakCount == 2 {
                    habitRef.delete() { error in
                        if let error = error {
                            print("Error deleting habit: \(error.localizedDescription)")
                        } else {
                            DispatchQueue.main.async {
                                if let indexPath = self.collectionView?.indexPath(for: self) {
                                    UIView.animate(withDuration: 1.0, animations: {
                                        self.contentView.alpha = 0
                                    }) { _ in
                                        self.collectionView?.performBatchUpdates({
                                            self.collectionView?.deleteItems(at: [indexPath])
                                        }, completion: nil)
                                    }
                                }
                            }
                        }
                    }
        }
    }
}
}
}
