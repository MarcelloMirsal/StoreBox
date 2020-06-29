//
//  SearchFilteringViewController.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 15/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit

class SearchFilteringViewController: UIViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    @IBOutlet weak var tableView: UITableView!
    
    let filterDict : [ (String, [String]) ] = [
        ("Sort By" , [ "Most Recent" , "Ascending" , "Descending" ]) ,
        
        ("City" , [ "Al-Mukalla" , "Aden" , "San'a"] ) ,
        
        ("Pricing" , ["set a Range"])
    ]
    
    @IBOutlet weak var doneButton: UIRoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ShopTableViewHeaderSection.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.contentInset.bottom = doneButton.frame.height * 2
    }
    
    @IBAction func handleDone(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension SearchFilteringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        filterDict.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDict[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let queryText = filterDict[indexPath.section].1[indexPath.row]
        cell.textLabel?.font = UIFont(name: "AvenirNext-regular", size: UIFont.systemFontSize+2)
        cell.textLabel?.text = queryText
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ShopTableViewHeaderSection
        headerView?.sectionLabel.text = filterDict[section].0
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            for index in 0...filterDict[indexPath.section].1.count {
//                let cell = tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)  )
//                cell?.accessoryType = .none
//            }
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.accessoryType = .checkmark
//        } else if indexPath.section == 1 {
//            guard let cell = tableView.cellForRow(at: indexPath) else { return }
//            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
}
