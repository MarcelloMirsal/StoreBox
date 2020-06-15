//
//  DetailsCollectionViewHeader.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 14/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class DetailsCollectionViewHeader: UICollectionReusableView {
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: UIFont.labelFontSize+4 )
        return label
    }()
    
    let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: UIFont.labelFontSize )
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let stackView = UIStackView(arrangedSubviews: [ sectionTitle, detailsButton ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func set(sectionTitle title: String, buttonTitle btnTitle: String) {
        sectionTitle.text = title
        detailsButton.setTitle(btnTitle, for: .normal)
    }
    
    
    
}
