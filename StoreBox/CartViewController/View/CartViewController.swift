//
//  CartViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 01/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
//    let cellId = "cellId"
//    var items = 6
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkoutButton: UIRoundButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//    }
//
//    func setupTableView() {
//        let cellNib = UINib(name: "ProductTableViewCell")
//        tableView.register(cellNib, forCellReuseIdentifier: cellId)
//        tableView.contentInset.bottom = 64
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    func handleRowDelete(action: UITableViewRowAction, at indexPath: IndexPath) {
//        tableView.beginUpdates()
//        items -= 1
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//    }
}
//
//extension CartViewController: UITableViewDelegate, UITableViewDataSource {
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductTableViewCell
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 144
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let productDetails = UIStoryboard(name: "ProductDetailsViewController").getInitialViewController(of: ProductDetailsViewController.self)
//        navigationController?.pushViewController(productDetails, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove", handler: handleRowDelete(action:at:))
//        return [deleteAction]
//    }
//}
