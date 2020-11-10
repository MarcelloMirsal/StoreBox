//
//  DetailsCollectionViewHeader.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 14/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class DetailsCollectionViewHeader: UICollectionReusableView {
    static let id = "headerId"
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(sectionTitle)
        addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            detailsButton.firstBaselineAnchor.constraint(equalTo: sectionTitle.firstBaselineAnchor),
            sectionTitle.topAnchor.constraint(equalTo: topAnchor),
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            detailsButton.topAnchor.constraint(equalTo: topAnchor),
            detailsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func set(sectionTitle title: String, buttonTitle btnTitle: String) {
        sectionTitle.text = title
        detailsButton.setTitle(btnTitle, for: .normal)
    }
    
    
    
}
