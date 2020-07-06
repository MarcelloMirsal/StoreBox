//
//  StoreSearchDetailsViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class StoreSearchDetailsViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(DetailsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StoreTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            headerId) as! DetailsTableViewHeader
        headerView.button.isHidden = true
        headerView.contentView.backgroundColor = tableView.backgroundColor
        headerView.sectionLabel.text = "4 Results"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
}
