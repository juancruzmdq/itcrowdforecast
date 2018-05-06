//
//  CityListViewController.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

class CityListViewController: UITableViewController {
    
    var searchController: UISearchController?
    
    var viewModel: CityListViewModel?

    override func viewDidLoad() {
        self.title = "My cities"
        self.definesPresentationContext = true
        
        let citySearchResultsViewController = CitySearchResultsViewController()
        citySearchResultsViewController.delegate = self
        
        self.searchController = UISearchController(searchResultsController: citySearchResultsViewController)
        self.searchController?.searchResultsUpdater = citySearchResultsViewController
        self.searchController?.searchBar.placeholder = "Search new cities"
        
        navigationItem.searchController = self.searchController
        
        self.viewModel?.delegate = self
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities?.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCellReuseIdentifier", for: indexPath)
        
        if let city = viewModel?.cities?[indexPath.row] {
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = city.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let city = viewModel?.cities?[indexPath.row] {
                tableView.beginUpdates()
                self.viewModel?.delete(city)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
}

extension CityListViewController: CityListViewModelDelegate {
    
    func citiesDidChange(_ cityListViewModel: CityListViewModel) {
        self.tableView.reloadData()
    }
    
}

extension CityListViewController: CitySearchResultsViewControllerDelegate {
    
    func searchResult(_ citySearchResultsViewController: CitySearchResultsViewController, didSelect prediction: Prediction) {
        guard let cityName = prediction.description else { return }
        self.viewModel?.lookupForCityWith(name: cityName)
        self.searchController?.isActive = false
    }
    
}
