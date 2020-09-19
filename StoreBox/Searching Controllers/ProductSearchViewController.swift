//
//  ProductSearchViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 15/09/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class ProductSearchViewController: UITableViewController {
    
    let cellId = "cellId"
    let searchServie: ProductsSearchingServiceProtocol = ProductsSearchingService(authToken: UserAuthService.token ?? "")
    var productsList: ProductsList?
    
    // MARK: Factory
    static func initiate(for searchQuery: String) -> ProductSearchViewController {
        let viewController = ProductSearchViewController()
        viewController.title = searchQuery
        return viewController
    }
    
    func setupTableView() {
        let cellNib = UINib(name: "ProductTableViewCell")
        tableView.register(cellNib, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 200
        tableView.estimatedRowHeight = 200
    }
    
    // MARK:- View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        guard let title = self.title else { return }
        searchServie.productSearch(query: title) { (error, productsList) in
            if let requestError = error {
                let x = UIAlertController.makeAlert(requestError.localizedDescription, title: "Error")
                self.present(x, animated: true)
                return
            }
            self.productsList = productsList
            self.tableView.reloadData()
        }
    }
}


// MARK:- TableView Delegate & DataSource Implementation
extension ProductSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.products.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductTableViewCell
        return cell
    }
    
}
