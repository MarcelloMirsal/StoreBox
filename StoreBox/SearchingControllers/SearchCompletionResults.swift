//
//  SearchCompletionResults.swift
//  StoreBox
//
//  Created by Marcello Mirsal on 12/06/2020.
//  Copyright © 2020 Mohammed Ahmed. All rights reserved.
//

import UIKit


protocol SearchCompletionResultsDelegate: class {
    func searchCompletionResults(didSelectResult result: String)
}

final class SearchCompletionResults: UITableViewController {
    let cellId = "cellId"
    weak var delegate: SearchCompletionResultsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.contentView.backgroundColor = .systemOrange
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchCompletionResults(didSelectResult: "Playstation 5 1TB Euro")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
