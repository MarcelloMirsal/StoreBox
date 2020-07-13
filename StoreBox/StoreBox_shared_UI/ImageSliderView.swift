//
//  ImageSliderView.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import ImageSlideshow


class ImageSliderView: ImageSlideshow {
    
    let tapGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageSlideShow()
    }
    
    func setupTapGesture(target: Any, action: Selector) {
        tapGesture.addTarget(target, action: action)
        addGestureRecognizer(tapGesture)
    }
    
    func setupImageSlideShow() {
        zoomEnabled = false
        circular = false
        contentScaleMode = .scaleAspectFit
        
        let customPageIndicator = UIPageControl()
        customPageIndicator.currentPageIndicatorTintColor = UIColor.black
        customPageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator = customPageIndicator
        
        setImageInputs([
            ImageSource(image: #imageLiteral(resourceName: "ad")),
            ImageSource(image: #imageLiteral(resourceName: "bourkestreetbakery")),
            ImageSource(image: #imageLiteral(resourceName: "cafedeadend")),
            ImageSource(image: #imageLiteral(resourceName: "lap"))
        ])
        
    }
}

@IBDesignable
class PresentableImageView: ImageSlideshow {
    
    @IBInspectable var image: UIImage?
    var imageContentMode: UIViewContentMode = .scaleAspectFill
    
    let tapGesture = UITapGestureRecognizer()
    
    override func draw(_ rect: CGRect) {
        contentScaleMode = imageContentMode
        guard let presentableImage = image else { return }
        setImageInputs([ ImageSource(image: presentableImage) ])
    }
    
    func setupTapGesture(target: Any, action: Selector) {
        tapGesture.addTarget(target, action: action)
        addGestureRecognizer(tapGesture)
    }
    
}
