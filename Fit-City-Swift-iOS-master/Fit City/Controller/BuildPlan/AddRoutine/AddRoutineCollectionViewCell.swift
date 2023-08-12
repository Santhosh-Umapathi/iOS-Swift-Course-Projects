//
//  AddRoutineCollectionViewCell.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 2/24/20.
//  Copyright © 2020 App City. All rights reserved.
//

import UIKit

class AddRoutineCollectionViewCell: UICollectionViewCell
{

    override func awakeFromNib()
    {
        super.awakeFromNib()
        collectionCellSettings(collectionCell: self)
        // Initialization code
    }
    
    
    @IBOutlet weak var routineName: UILabel!
    
    
    
    func collectionCellSettings(collectionCell: UICollectionViewCell)
    {
        collectionCell.backgroundColor = .white
        collectionCell.layer.borderColor = UIColor(hexString: "C6E6FF").cgColor//UIColor.systemYellow.cgColor
        collectionCell.layer.borderWidth = 1
        collectionCell.layer.cornerRadius = 10
        
//        startWokroutTapped.backgroundColor = UIColor(hexString: "C6E6FF")
//        startWokroutTapped.setTitleColor(UIColor(hexString: "2F84FF"), for: .normal)
//        startWokroutTapped.layer.cornerRadius = 10
//
//        deleteButtonTapped.setImage(UIImage(named: "Routine Delete Icon 2"), for: .highlighted)
//
    }
}
