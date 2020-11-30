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
    let loadingIndicatorView = LoadingIndicatorView()
    var searchController: UISearchController!
    
    // MARK:- View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupLoadingIndicatorView()
        setupSearchController()
        setupCollectionView()
        setupCollectionLayouts()
        setupCollectionViewDataSource()
        loadShoppingPromotions()
    }
    
    // MARK:- ViewModel setup
    func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK:- setup LoadingIndicatorView
    private func setupLoadingIndicatorView() {
        let handleLoadingAgainSelector = #selector(handleLoadingAgaing)
        loadingIndicatorView.setLoadingButtonAction(selector: handleLoadingAgainSelector, for: self)
        
        view.addSubview(loadingIndicatorView)
        
        loadingIndicatorView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK:- SearchController setup
    private func setupSearchController() {
        let autocompleteSearchController = AutocompleteSearchViewController.initiate(mainNavigationController: navigationController)
        
        let searchController = UISearchController(searchResultsController: autocompleteSearchController)
        searchController.showsSearchResultsController = true
        searchController.searchBar.delegate = autocompleteSearchController
        searchController.searchBar.searchTextField.placeholder = "Search for products"
        navigationItem.searchController = searchController
    }
    
    // MARK:- Setup collectionView
    private func tableViewRegistration() {
        collectionView.register(BannerAdCollectionViewCell.self, forCellWithReuseIdentifier: BannerAdCollectionViewCell.id)
        
        collectionView.register(ProductAdCollectionViewCell.self, forCellWithReuseIdentifier: ProductAdCollectionViewCell.id)
        
        let productCellNib = UINib(name: "ProductCollectionViewCell")
        collectionView.register(productCellNib, forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
        collectionView.register(DetailsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailsCollectionViewHeader.id)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGray6
        collectionView.contentInset.bottom = 32
        tableViewRegistration()
    }
    
    // MARK:- Setup collectionView layouts
    private func setupCollectionLayouts() {
        let sectionConfiguartion = UICollectionViewCompositionalLayoutConfiguration()
        sectionConfiguartion.interSectionSpacing = 16
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (index, env) -> NSCollectionLayoutSection? in
            return self?.viewModel.layoutForSection(atIndex: index)
        }, configuration: sectionConfiguartion)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK:- Setup CollectionView DataSource
    private func setupCollectionViewDataSource() {
        let dataSource = ShopViewModel.ViewDataSource(collectionView: collectionView, cellProvider: dataSourceCellProvider)
        
        dataSource.supplementaryViewProvider = dataSourceSupplementaryViewProvider
        viewModel.set(collectionViewDataSource: dataSource)
    }
    
    private let bannerAdCellConfiguration = {  (collectionView: UICollectionView, indexPath: IndexPath, listItem: BannerAd) -> BannerAdCollectionViewCell? in
        return collectionView.dequeueReusableCell(withReuseIdentifier: BannerAdCollectionViewCell.id, for: indexPath) as? BannerAdCollectionViewCell
    }
    
    private let productAdCellConfiguration = {  (collectionView: UICollectionView, indexPath: IndexPath, listItem: ProductAd) -> ProductAdCollectionViewCell? in
        return collectionView.dequeueReusableCell(withReuseIdentifier: ProductAdCollectionViewCell.id, for: indexPath) as? ProductAdCollectionViewCell
    }
    
    private let categoryCellConfiguration = {  (collectionView: UICollectionView, indexPath: IndexPath, listItem: Category) -> CategoryCollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell
        cell?.nameLabel.text = listItem.name
        return cell
    }
    
    private let productCellConfiguration = {  (collectionView: UICollectionView, indexPath: IndexPath, listItem: Product) -> ProductCollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as? ProductCollectionViewCell
        return cell
    }
    
    lazy var dataSourceCellProvider: (UICollectionView, IndexPath, ListItem<Any>) -> UICollectionViewCell? = { [weak self] (collectionView, indexPath, listItem) in
        guard let section = self?.viewModel.section(atIndex: indexPath.section) else {
            return nil
        }
        switch section {
            case .bannerAds:
                return self?.bannerAdCellConfiguration(collectionView, indexPath, listItem.item as! BannerAd)
            case .productAds:
                return self?.productAdCellConfiguration(collectionView, indexPath, listItem.item as! ProductAd)
            case .categories:
                return self?.categoryCellConfiguration(collectionView, indexPath, listItem.item as! Category)
            case .productRecommendation(_):
                return self?.productCellConfiguration(collectionView, indexPath, listItem.item as! Product)
        }
    }
    
    lazy var dataSourceSupplementaryViewProvider: (UICollectionView, String, IndexPath) -> UICollectionReusableView? = { [weak self] (collectionView, elementKind, indexPath) in
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailsCollectionViewHeader.id, for: indexPath) as? DetailsCollectionViewHeader
        guard let section = self?.viewModel.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
        
        let description = section.title()
        headerView?.set(sectionTitle: description, buttonTitle: "" )
        return headerView
    }
    
    // MARK:- Handlers
    func loadShoppingPromotions() {
        viewModel.loadShoppingPromotions()
    }
    
    @objc
    func handleLoadingAgaing() {
        loadShoppingPromotions()
        loadingIndicatorView.toggleLoadingButton()
    }
}

// MARK:- ViewModel delegate
extension ShopViewController: ShopViewModelDelegate {
    func loadShoppingPromotionsDidSuccess() {
        loadingIndicatorView.isHidden = true
        // TODO: possible bug in iOS 13 -> orthogonal section cells not centered at first time
        collectionView.reloadData()
    }
    
    func loadShoppingPromotionsDidFailed() {
        loadingIndicatorView.toggleLoadingButton()
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
        contentView.layer.cornerRadius = 8
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
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
            
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


class BannerAdCollectionViewCell: UICollectionViewCell {
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

class LoadingIndicatorView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private let loadingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.setTitle("Tap here to load data again", for: .normal)
        button.setTitle("Loading...", for: .disabled)
        button.isEnabled = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    @discardableResult
    func toggleLoadingButton() -> Bool {
        loadingButton.isEnabled = loadingButton.isEnabled ? false : true
        if loadingButton.isEnabled {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        return loadingButton.isEnabled
    }
    
    private func setupViews() {
        addSubview(activityIndicator)
        addSubview(loadingButton)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    
        NSLayoutConstraint.activate([
            loadingButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 4),
            loadingButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func setLoadingButtonAction(selector: Selector, for target: Any) {
        loadingButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
