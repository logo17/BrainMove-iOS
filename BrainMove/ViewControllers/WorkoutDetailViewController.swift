//
//  WorkoutDetailViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/27/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit

class WorkoutDetailViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var workoutsCollectionView: UICollectionView!
    @IBOutlet weak var blockImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationUnitLabel: UILabel!
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
    left: 10.0,
    bottom: 10.0,
    right: 10.0)
    
    var block = Block(data: [String:Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = block?.name
        self.durationLabel.text = "\(block?.duration ?? 0)"
        self.durationUnitLabel.text = block?.unit.uppercased()
        if let parseURL = URL.init(string: block?.imageUrl ?? "") {
            blockImageView.load(url: parseURL)
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.block?.exercises.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "WorkoutTableViewCell"
        
        guard let cell = workoutsCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? WorkoutCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutCell.")
        }
        
        if let workout = self.block?.exercises[indexPath.row] {
            cell.workoutName.text = workout.name
            cell.workoutQuantity.text = workout.quantity
            cell.inflateImageView(url: workout.backgroundImageUrl)
        }
        
        return cell
    }
    
    //1
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
       //2
       let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
       let availableWidth = view.frame.width - paddingSpace
       let widthPerItem = availableWidth / itemsPerRow
       
       return CGSize(width: widthPerItem, height: widthPerItem)
     }
     
     //3
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets {
       return sectionInsets
     }
     
     // 4
     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return sectionInsets.left
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showExplanations", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showExplanations") {
            let indexPath = self.workoutsCollectionView.indexPathsForSelectedItems?.first
            let exercise = self.block?.exercises[indexPath?.row ?? 0]
            let destinationVC = segue.destination as! ExerciseExplanationViewController
            destinationVC.workout = exercise
        }
    }
}
