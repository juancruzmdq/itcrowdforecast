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
    
    var presenter: CityListPresenter?

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities?.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCellReuseIdentifier", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        if let city = viewModel?.cities?[indexPath.row] {
            let cityCellViewModel = CityCellViewModel()
            cityCellViewModel.city = city
            cell.viewModel = cityCellViewModel
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let city = viewModel?.cities?[indexPath.row],
           let navigationController = self.navigationController {
            presenter?.cityDetail(for: city, in: navigationController)
        }
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
