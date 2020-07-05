//
//  StoresViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 05/07/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class StoresViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var items = [
        ("Electronics" , [ "One Store" , "Second Store" , "Last Store" ]) ,
        
        ("Cloths" , [ "One Store" , "Last Store" ] ) ,
        
        ("Shoes" , ["1 Store"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(DetailsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StoreTableViewCell
        cell.textLabel?.text = items[indexPath.section].1[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            headerId) as! DetailsTableViewHeader
        headerView.contentView.backgroundColor = tableView.backgroundColor
        headerView.sectionLabel.text = items[section].0
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
}



