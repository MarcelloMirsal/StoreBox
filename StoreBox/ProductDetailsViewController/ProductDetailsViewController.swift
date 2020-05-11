//
//  ProductDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 11/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
    func updateDescriptionTextViewHeight() {
        let text = NSAttributedString(attributedString: descriptionTextView.attributedText)
        let size = text.boundingRect(with: view.frame.size, options: .usesLineFragmentOrigin, context: nil)
        descriptionTextViewHeightConstraint.constant = size.height + 32
        scrollView.layoutIfNeeded()
    }
    
    func setupScrollView() {
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDescriptionTextViewHeight()
        setupScrollView()
    }
    
}
