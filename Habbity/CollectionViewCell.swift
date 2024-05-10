//
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
    
    func configureCell(with habit: Habit) {
        pTitle.text = habit.title
        imageView.sd_setImage(with: URL(string: habit.imageURL))
        statusSwitcher.isOn = habit.status
        self.habit = habit
    }
    
    @objc func switchValueChanged() {
        guard let habit = habit else {
            return
        }
        
        let habitRef = db.collection("habits").document(habit.id)
        habitRef.updateData(["status": statusSwitcher.isOn]) { (error) in
            if let error = error {
                print("Error updating habit status: \(error.localizedDescription)")
            } else {
                // Update the habit status in the local data source
                self.habit?.status = self.statusSwitcher.isOn
                
                if self.statusSwitcher.isOn {
                    // Fade in the label, then fade it out after a delay
                    UIView.animate(withDuration: 1.0, animations: {
                        // Fade in
                        self.goodJobLabel.alpha = 1
                    }) { _ in
                        UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                            // Fade out after a delay
                            self.goodJobLabel.alpha = 0
                        }, completion: nil)
                    }
                } else {
                    // Animate the label to gradually disappear
                    UIView.animate(withDuration: 1.0) {
                        self.goodJobLabel.alpha = 0
                    }
                }
            }
        }
    }
}
