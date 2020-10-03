//
//  UICollectionViewLoadingFooter.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/10/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class UICollectionViewLoadingFooter: UICollectionReusableView {
    
    let loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingActivityIndicator)
        NSLayoutConstraint.activate( [
            loadingActivityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ] )
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

