//
//  CitySearchResultsViewController.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

protocol CitySearchResultsViewControllerDelegate: class {
    func searchResult(_ citySearchResultsViewController: CitySearchResultsViewController, didSelect prediction: Prediction)
}

class CitySearchResultsViewController: UITableViewController {
    
    let viewModel = CitySearchResultsViewModel()
    
    weak var delegate: CitySearchResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        self.viewModel.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = self.viewModel.items[indexPath.row]
        cell.textLabel?.text = item.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchResult(self, didSelect: self.viewModel.items[indexPath.row])
    }
    
}

extension CitySearchResultsViewController: CitySearchResultsViewModelDelegate {
    
    func searchResultDidUpdate(_ citySearchResultsViewModel: CitySearchResultsViewModel) {
        self.tableView.reloadData()
    }

}

extension CitySearchResultsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.input = text
    }
    
}
