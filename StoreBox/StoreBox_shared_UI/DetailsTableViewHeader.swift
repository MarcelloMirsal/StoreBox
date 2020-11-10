//
//  DetailsTableViewHeader.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class DetailsTableViewHeader: UITableViewHeaderFooterView {
    
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("More", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: UIFont.labelFontSize )
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
}
