//
//  ShopViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/05/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

final class ShopViewController: UICollectionViewController {
    
    let viewModel =  ShopViewModel()
    
    
    // MARK:- View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionLayouts()
        setupCollectionViewDataSource()
        
        let autocompleteSearchController = AutocompleteSearchViewController.initiate(mainNavigationController: navigationController)
        
        let searchController = UISearchController(searchResultsController: autocompleteSearchController)
        searchController.showsSearchResultsController = true
        searchController.searchBar.delegate = autocompleteSearchController
        searchController.searchBar.searchTextField.placeholder = "Search for products"
        navigationItem.searchController = searchController
    }
    
    // MARK:- Setup collectionView

    func setupCollectionView() {
        
        collectionView.backgroundColor = .systemGray6
        
        collectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: AdsCollectionViewCell.id)
        
        collectionView.register(ProductAdCollectionViewCell.self, forCellWithReuseIdentifier: ProductAdCollectionViewCell.id)
        
        let productCellNib = UINib(name: "ProductCollectionViewCell")
        collectionView.register(productCellNib, forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
        collectionView.register(DetailsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailsCollectionViewHeader.id)
    }
    
    // MARK:- Setup collectionView layouts
    func setupCollectionLayouts() {
        let sectionLayoutManager = ShopViewLayoutManager()
        
        let sectionConfiguartion = UICollectionViewCompositionalLayoutConfiguration()
        sectionConfiguartion.interSectionSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, env) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 { return sectionLayoutManager.bannerAdsLayout() }
            else if sectionIndex == 1 { return sectionLayoutManager.productsAds() }
            else if sectionIndex == 2 || sectionIndex == 3 { return sectionLayoutManager.productsRecommendation() }
            else if sectionIndex == 4 { return sectionLayoutManager.categoriesSection() }
            else { return nil }
        }, configuration: sectionConfiguartion)
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    
    // MARK:- Setup CollectionView DataSource
    func setupCollectionViewDataSource() {
        let dataSource = ShopViewModel.ViewDataSource(collectionView: collectionView, cellProvider: dataSourceCellProvider)
        dataSource.supplementaryViewProvider = dataSourceSupplementaryViewProvider
        viewModel.set(collectionViewDataSource: dataSource)
    }
    
    lazy var dataSourceCellProvider: (UICollectionView, IndexPath, ListItem<String>) -> UICollectionViewCell? = { (collectionView, indexPath, listItem) in
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.id, for: indexPath) as? AdsCollectionViewCell
        }
        else if indexPath.section == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProductAdCollectionViewCell.id, for: indexPath) as? ProductAdCollectionViewCell
        }
        else if  indexPath.section == 2 || indexPath.section == 3 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as? ProductCollectionViewCell
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell
            cell?.nameLabel.text = listItem.item
            return cell
        }
        else {return nil}
    }
    
    lazy var dataSourceSupplementaryViewProvider: (UICollectionView, String, IndexPath) -> UICollectionReusableView? = { (collectionView, elementKind, indexPath) in
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailsCollectionViewHeader.id, for: indexPath) as? DetailsCollectionViewHeader
        let section = self.viewModel.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
        let description = ShopViewModel.Section.description(for: section)
        headerView?.set(sectionTitle: description, buttonTitle: "" )
        return headerView
    }
}


class CategoryCollectionViewCell: UICollectionViewCell {
    static let id = "CategoryCollectionViewCellId"
    
    let imageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "bourkestreetbakery"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupLayer()
    }
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setupSubViews() {
        addSubview(nameLabel)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,   constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    func setupLayer() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
}


class ProductAdCollectionViewCell: UICollectionViewCell {
    static let id = "ProductAdCollectionViewCellId"
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "MacBook Pro 16 inch"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "Designed for those who defy limits and change the world, the new MacBook Pro is by far the most powerful."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "product ad"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setupLayers() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = .init(width: 0, height: 8)
        layer.shadowRadius = 5
    }
    
    func setupSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 8),
            imageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            
            
        ])
        
    }
}


class AdsCollectionViewCell: UICollectionViewCell {
    static let id = "AdsCollectionViewCellId"
    let bannerImageView: UIImageView = {
       let imgView = UIImageView(image: #imageLiteral(resourceName: "headerImage"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setupLayers() {
        bannerImageView.layer.cornerRadius = 8
        bannerImageView.layer.masksToBounds = true
    }
    
    func setupSubViews() {
        contentView.addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
}
