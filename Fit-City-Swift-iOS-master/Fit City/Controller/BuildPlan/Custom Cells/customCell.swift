//  customCell.swift
//  Fit City
//  Created by Santhosh Umapathi on 11/29/19.
//  Copyright © 2019 App City. All rights reserved.

import UIKit
import SwipeCellKit

class customCell: SwipeTableViewCell
{
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    
    override func awakeFromNib()
    { super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool)
    { super.setSelected(selected, animated: animated) }
    
}
