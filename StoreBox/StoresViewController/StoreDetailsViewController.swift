//
//  StoreDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 06/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class StoreDetailsViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var storeImageView: StoreImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "@DemoStore"
        navigationItem.rightBarButtonItem = .init(title: "Contact", style: .done, target: nil, action: nil)
        setupTableView()
        setupHeaderView()
        setupStoreImageViewGradientLayer()
        storeImageView.setupTapGesture(target: self, action: #selector( handleStoreImagePresentation))
        
    }
    
    @objc
    func handleStoreImagePresentation(){
        storeImageView.presentFullScreenController(from: self)
    }
    
    func setupHeaderView() {
        let tableViewSize = tableView.frame.size
        let imageHeight = AspectRatioCalculator(width: tableViewSize.width).get(aspectWidth: 3, aspectHeight: 2).height
        let descriptionTextHeight = descriptionTextView.text.height(withConstrainedWidth: tableViewSize.width, font: descriptionTextView.font!)
        headerView.frame.size.height = imageHeight + descriptionTextHeight + 32
    }
    
    func setupTableView() {
        let cellNib = UINib(name: "ProductTableViewCell")
        tableView.register(cellNib, forCellReuseIdentifier: cellId)
        tableView.register(CategoriesTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    func setupStoreImageViewGradientLayer() {
        let imageViewSize = storeImageView.frame.size
        let storeNameLabelHeight = storeNameLabel.frame.height
        let shiftBetweenLabels: CGFloat = 24
        let labelsCoverPercent = (storeNameLabelHeight + shiftBetweenLabels) / imageViewSize.height
        storeImageView.gradientCoverPercent = labelsCoverPercent
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductTableViewCell
        cell.sellerNameLabel.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CategoriesTableSectionHeader
        let indexPath = IndexPath(row: 0, section: 0)
        headerView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        headerView.contentView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
}
