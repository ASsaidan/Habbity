//
//  ViewController.swift
//  Habbity
//
//  Created by A.S on 2024-05-01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addNewHabit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String] =
    ["one", "two", "three"]
    
    var titleLbl: [String] =
    ["Read book for 10 minutes", "Pray to god", "Go to the gym"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
    Int {
        return titleLbl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as! CollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 23
        cell.imageView.layer.cornerRadius = 23
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.pTitle.text = titleLbl[indexPath.row]
        cell.imageView.image = UIImage(named: images [indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize (width: size, height: size)
        
    }
}


