//  WorkoutPlanVCTableViewCell.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/18/20.
//  Copyright © 2020 App City. All rights reserved.

import UIKit
import SwipeCellKit

class WorkoutPlanVCTableViewCell: UITableViewCell
{
    @IBOutlet weak var weekLabel: UILabel!
    
    override func awakeFromNib()
    { super.awakeFromNib() }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    { super.setSelected(selected, animated: animated) }
}
