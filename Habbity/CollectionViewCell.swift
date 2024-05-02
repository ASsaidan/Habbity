//
//  CollectionViewCell.swift
//  Habbity
//
//  Created by A.S on 2024-05-01.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pTitle: UILabel!
    
    @IBOutlet weak var statusSwitcher: UISwitch!
    
      let goodJobLabel: UILabel = {
          let label = UILabel()
          label.text = "Good Job"
          label.alpha = 0 // Initially invisible
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      override func awakeFromNib() {
          super.awakeFromNib()
          
          // Add the label to the cell's content view and position it
          contentView.addSubview(goodJobLabel)
          NSLayoutConstraint.activate([
              goodJobLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
              goodJobLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
          ])
          
          // Add an action to the switch
          statusSwitcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
      }
      
      @objc func switchValueChanged() {
          if statusSwitcher.isOn {
              // Animate the label to gradually appear
              UIView.animate(withDuration: 1.0) {
                  self.goodJobLabel.alpha = 1
              }
          } else {
              // Animate the label to gradually disappear
              UIView.animate(withDuration: 1.0) {
                  self.goodJobLabel.alpha = 0
              }
          }
      }
}
