//
//  CustomButton.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryColor
    }
}
