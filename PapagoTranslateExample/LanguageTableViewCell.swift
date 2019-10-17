//
//  LanguageTableViewCell.swift
//  PapagoTranslateExample
//
//  Created by 정재훈 on 11/10/2019.
//  Copyright © 2019 Jung. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLagnuage: UILabel!
    @IBOutlet weak var imageIsChecked: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageIsChecked.isHidden = true
        imageIsChecked.image = UIImage(systemName: "checkmark")
        imageIsChecked.tintColor = .systemGreen
        
        labelLagnuage.translatesAutoresizingMaskIntoConstraints = false
        imageIsChecked.translatesAutoresizingMaskIntoConstraints = false
        
        labelLagnuage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10.0).isActive = true
        labelLagnuage.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        
        imageIsChecked.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 10.0).isActive = true
        imageIsChecked.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
