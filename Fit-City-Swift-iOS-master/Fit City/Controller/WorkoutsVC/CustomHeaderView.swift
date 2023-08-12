//
//  CustomHeaderView.swift
//  Fit City
//
//  Created by Santhosh Umapathi on 1/20/20.
//  Copyright © 2020 App City. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {

  
}

class CategoryHeaderView: UIView {
var imageView:UIImageView!
var colorView:UIView!
var bgColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
var titleLabel = UILabel()
var articleIcon:UIImageView!
    
init(frame:CGRect, title: String) {
     super.init(frame: frame)
    setUpView()

}
required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
}
    
    func setUpView() {
       self.backgroundColor = UIColor.white
       imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(imageView)
       colorView = UIView()
       colorView.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(colorView)
       let constraints:[NSLayoutConstraint] = [
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
       imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
       imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
       colorView.topAnchor.constraint(equalTo: topAnchor),
       colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
       colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
       colorView.bottomAnchor.constraint(equalTo: bottomAnchor)
       ]
       NSLayoutConstraint.activate(constraints)
       imageView.image = UIImage(named: "testBackground")
        imageView.contentMode = .scaleAspectFill
       colorView.backgroundColor = bgColor
       colorView.alpha = 0.6
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(titleLabel)
       let titlesConstraints:[NSLayoutConstraint] = [
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
       titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
       ]
       NSLayoutConstraint.activate(titlesConstraints)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
       articleIcon = UIImageView()
       articleIcon.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(articleIcon)
       let imageConstraints:[NSLayoutConstraint] = [
        articleIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
       articleIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
       articleIcon.widthAnchor.constraint(equalToConstant: 40),
       articleIcon.heightAnchor.constraint(equalToConstant: 40)
       ]
       NSLayoutConstraint.activate(imageConstraints)
       articleIcon.image = UIImage(named: "Get In Shape Fast")
       }
    
   
}
