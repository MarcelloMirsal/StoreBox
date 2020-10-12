//
//  TitledTableViewHeaderFooterView.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 04/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class TitledTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupSubViews() {
        contentView.addSubview(sectionLabel)
        NSLayoutConstraint.activate( [
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionLabel.topAnchor.constraint(equalTo: topAnchor)
        ] )
    }
}
