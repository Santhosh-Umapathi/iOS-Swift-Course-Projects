//
//  StartWorkoutVCCollectionViewCell.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 2/19/20.
//  Copyright © 2020 App City. All rights reserved.
//

import UIKit

class StartWorkoutVCCollectionViewCell: UICollectionViewCell
{


    @IBOutlet weak var routineName: UILabel!
    @IBOutlet weak var ex1: UILabel!
    @IBOutlet weak var ex2: UILabel!
    @IBOutlet weak var ex3: UILabel!
    @IBOutlet weak var ex4: UILabel!
    @IBOutlet weak var ex5: UILabel!
    @IBOutlet weak var startWokroutTapped: UIButton!
    @IBOutlet weak var deleteButtonTapped: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        collectionCellSettings(collectionCell: self)
    }
    
    func collectionCellSettings(collectionCell: UICollectionViewCell)
    {
        collectionCell.backgroundColor = .white
        collectionCell.layer.borderColor = UIColor(hexString: "C6E6FF").cgColor//UIColor.systemYellow.cgColor
        collectionCell.layer.borderWidth = 1
        collectionCell.layer.cornerRadius = 10
        
        startWokroutTapped.backgroundColor = UIColor(hexString: "C6E6FF")
        startWokroutTapped.setTitleColor(UIColor(hexString: "2F84FF"), for: .normal)
        startWokroutTapped.layer.cornerRadius = 10
        
        deleteButtonTapped.setImage(UIImage(named: "Routine Delete Icon 2"), for: .highlighted)
        
    }
    
    

 
    
    
    
}
