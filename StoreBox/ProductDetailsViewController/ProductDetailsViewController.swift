//
//  ProductDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 11/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var imageSliderView: ImageSliderView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    
    
    
    func updateDescriptionTextViewHeight() {
        let size = CGSize(width: view.frame.width, height: 0)
        let estimatedSize = descriptionTextView.sizeThatFits(size)
        descriptionHeightConstraint.constant = estimatedSize.height
        view.layoutIfNeeded()
    }
    
    func setupScrollView() {
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 54, right: 0)
    }
    
    func setupImageSliderView() {
        imageSliderView.setFullPresentation(target: self, action: #selector( handleImageSliderViewPresentation))
    }
    
    @objc
    func handleImageSliderViewPresentation() {
        imageSliderView.presentFullScreenController(from: self)
    }
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        updateDescriptionTextViewHeight()
        setupImageSliderView()
    }
    
}
