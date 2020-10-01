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
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: dataSourceCellProvider(collectionView:indexPath:product:))
    let viewModel = ProductSearchViewModel()
    
    // MARK: Factory
    static func initiate(for searchQuery: String) -> ProductSearchViewController {
        let viewController = ProductSearchViewController(collectionViewLayout: .init())
        viewController.title = searchQuery
        return viewController
    }
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchFilterBatButton()
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.delegate = self
        guard let productName = title else { return }
        viewModel.productsSearch(productName: productName)
    }
    
    // MARK:- UI Actions
    @objc
    func handleFilterAction() {
        
    }
    
    // MARK:- UI setup methods
    func setupCollectionView() {
        collectionView.backgroundColor = .systemGray6
        
        collectionView.dataSource = dataSource
        let productCellNib = UINib(name: "ProductCollectionViewCell")
        collectionView.register(productCellNib, forCellWithReuseIdentifier: cellId)
        
        collectionView.setCollectionViewLayout(getCollectionViewLayout(), animated: false)
    }
    
    func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let estimatedSize = collectionView.frame.size
        let layoutSpace: CGFloat = 16.0
        let productItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0)) )
        
        let productGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(estimatedSize.height)), subitem: productItem, count: 2)
        productGroup.interItemSpacing = .fixed(layoutSpace)
        productGroup.contentInsets = .init(top: 0, leading: layoutSpace, bottom: 0, trailing: layoutSpace)
        
        
        let section = NSCollectionLayoutSection(group: productGroup)
        section.contentInsets = .init(top: layoutSpace, leading: 0, bottom: layoutSpace, trailing: 0)
        section.interGroupSpacing = layoutSpace
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setupSearchFilterBatButton() {
        navigationItem.rightBarButtonItem = .init(title: "Filter", style: .plain, target: self, action: #selector(handleFilterAction) )
    }
    
    func dataSourceCellProvider(collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ProductCollectionViewCell
        cell?.nameLabel.text = product.name
        cell?.priceLabel.text = "\(product.priceAfterDiscount)"
        cell?.discountLabel.text = "\(product.price)"
        return cell
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.productsList?.products ?? [], toSection: .main)
        dataSource.apply(snapshot)
    }
}

// MARK:- ViewModel Delegate Implementation
extension ProductSearchViewController: ProductSearchViewModelDelegate {
    func searchRequestFailed(message: String) {
        let alertController = UIAlertController.makeAlert(message, title: "Error")
        present(alertController, animated: true)
    }
    
    func searchRequestSuccess() {
        updateDataSource()
    }
    
    
}


// MARK:- CollectionView Delegate Implementation
extension ProductSearchViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK:- Models
extension ProductSearchViewController {
    enum Section {
        case main
    }
}


protocol ProductSearchViewModelDelegate: class {
    func searchRequestFailed(message: String)
    func searchRequestSuccess()
}

class ProductSearchViewModel {
    
    let searchingService: ProductsSearchingServiceProtocol
    weak var delegate: ProductSearchViewModelDelegate?
    private(set) var productsList : ProductsList? = ProductsList(products: [], pagination: ListPagination.emptyListPagination())
    
    init(searchingService: ProductsSearchingServiceProtocol = ProductsSearchingService(authToken: UserAuthService.token ?? "")) {
        self.searchingService = searchingService
    }
    
    func productsSearch(productName: String) {
        searchingService.productSearch(query: productName) { (serviceError, productsList) in
            if let error = serviceError {
                self.delegate?.searchRequestFailed(message: error.localizedDescription)
                return
            }
            // set product list here
            self.productsList = productsList
            self.delegate?.searchRequestSuccess()
        }
    }
    
}
