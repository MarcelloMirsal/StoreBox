//
//  ProductSearchViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 15/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductSearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let sectionFooterId = "sectionFooterId"
    
    let loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    private(set) lazy var viewModel: ProductSearchViewModel = {
        let viewModel = ProductSearchViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    
    // MARK: Factory
    static func initiate(for searchQuery: String) -> ProductSearchViewController {
        let viewController = ProductSearchViewController(collectionViewLayout: .init())
        viewController.title = searchQuery
        return viewController
    }
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupSubViews()
        setupCollectionView()
        setupSearchFilterBarButton()
        requestProductSearch()
    }
    // MARK:- Actions
    @objc
    func handleFilterAction() {
        let productSearchFilterViewController = ProductSearchFiltersViewController.initiate()
        let nvController = UINavigationController(rootViewController: productSearchFilterViewController)
        present(nvController, animated: true)
    }
    
    func requestProductSearch() {
//        guard let productName = title else { return }
//        viewModel.productSearch(productName: productName)
    }
    
    // MARK:- UI setup
    private func setupCollectionViewRegistration() {
        let productCellNib = UINib(name: "ProductCollectionViewCell")
        collectionView.register(productCellNib, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: sectionFooterId)
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: dataSourceCellProvider(collectionView:indexPath:product:))
        dataSource.supplementaryViewProvider = dataSourceSupplementaryViewProvider(collectionView:kind:indexPath:)
        collectionView.dataSource = dataSource
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGray6
        setupCollectionViewRegistration()
        setupCollectionViewDataSource()
        collectionView.setCollectionViewLayout(getCollectionViewLayout(), animated: false)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let estimatedSize = collectionView.frame.size
        let layoutSpace: CGFloat = 16.0
        let productItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0)) )
        
        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedSize.height)), subitem: productItem, count: 2)
        productGroup.interItemSpacing = .fixed(layoutSpace)
        productGroup.contentInsets = .init(top: 0, leading: layoutSpace, bottom: 0, trailing: layoutSpace)
        
        
        let section = NSCollectionLayoutSection(group: productGroup)
        section.contentInsets = .init(top: layoutSpace, leading: 0, bottom: layoutSpace, trailing: 0)
        section.interGroupSpacing = layoutSpace
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45.0)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupSearchFilterBarButton() {
        navigationItem.rightBarButtonItem = .init(title: "Filter", style: .plain, target: self, action: #selector(handleFilterAction) )
    }
    
    private func setupSubViews() {
        collectionView.addSubview(loadingActivityIndicator)
        NSLayoutConstraint.activate([
            loadingActivityIndicator.topAnchor.constraint(equalTo: collectionView.topAnchor,constant: 16),
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    
    
    
}

// MARK:- CollectionView dataSource configuration
extension ProductSearchViewController {
    
    private func dataSourceCellProvider(collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ProductCollectionViewCell
        cell?.nameLabel.text = product.name
        cell?.purchasePriceLabel.text = "\(product.priceAfterDiscount)"
        cell?.basePriceLabel.text = "\(product.price)"
        return cell
    }
    
    private func dataSourceSupplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.sectionFooterId, for: indexPath) as? UICollectionViewLoadingFooter
        return footerView
    }
    
    @discardableResult
     func updateDataSourceSnapshot() -> NSDiffableDataSourceSnapshot<Section, Product>  {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.productsList.products, toSection: .main)
        dataSource.apply(snapshot)
        return snapshot
    }
    
}

// MARK:- CollectionView delegate implementation
extension ProductSearchViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let loadingFooterView = view as? UICollectionViewLoadingFooter
        loadingFooterView?.loadingActivityIndicator.isHidden = !viewModel.canLoadMoreData
        viewModel.loadMoreData(productName: title! )
        print("load More")
    }
    
}

// MARK:- ViewModel Delegate Implementation
extension ProductSearchViewController: ProductSearchViewModelDelegate {
    func searchRequestFailed(message: String) {
        let alertController = UIAlertController.makeAlert(message, title: "Error")
        present(alertController, animated: true)
        loadingActivityIndicator.stopAnimating()
    }
    
    func searchRequestSuccess() {
        updateDataSourceSnapshot()
        loadingActivityIndicator.stopAnimating()
    }
}

// MARK:- Models
extension ProductSearchViewController {
    enum Section {
        case main
    }
}
