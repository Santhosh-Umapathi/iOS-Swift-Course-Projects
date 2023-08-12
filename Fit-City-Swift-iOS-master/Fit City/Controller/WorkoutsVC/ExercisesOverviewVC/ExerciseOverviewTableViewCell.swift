//  ExerciseOverviewTableViewCell.swift
//  Fit City
//  Created by Santhosh Umapathi on 1/22/20.
//  Copyright © 2020 App City. All rights reserved.

import UIKit

class ExerciseOverviewTableViewCell: UITableViewCell
{
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var bodyPartName: UILabel!
    
    override func awakeFromNib()
    { super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool)
    { super.setSelected(selected, animated: animated) }
}
