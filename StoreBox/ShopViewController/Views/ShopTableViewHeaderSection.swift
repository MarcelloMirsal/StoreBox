//
//  ShopTableViewHeaderSection.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 03/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


class ShopTableViewHeaderSection: UITableViewHeaderFooterView {
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: UIFont.buttonFontSize + 4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentView.addSubview(sectionLabel)
        NSLayoutConstraint.activate( [
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionLabel.topAnchor.constraint(equalTo: topAnchor)
        ] )
    }
}

