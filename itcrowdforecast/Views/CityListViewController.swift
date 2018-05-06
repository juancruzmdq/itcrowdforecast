//
//  CityListViewController.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

class CityListViewController: UITableViewController {
    
    var viewModel: CityListViewModel?
    
    var presenter: CityListPresenter?
    
    var searchController: UISearchController?

    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        
        self.title = "My cities"
        self.definesPresentationContext = true
        
        self.viewModel?.delegate = self
        
        self.buildSearchController()
        
        self.buildActivityIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}

private extension CityListViewController {
    
    func buildSearchController() {
        
        let citySearchResultsViewController = CitySearchResultsViewController()
        citySearchResultsViewController.delegate = self
        
        self.searchController = UISearchController(searchResultsController: citySearchResultsViewController)
        self.searchController?.searchResultsUpdater = citySearchResultsViewController
        self.searchController?.searchBar.placeholder = "Search new cities"
        
        self.navigationItem.searchController = self.searchController

    }
    
    func buildActivityIndicator() {

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        self.activityIndicator = activityIndicator

    }
    
}

extension CityListViewController {

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.cities?.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCellReuseIdentifier", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        if let city = viewModel?.cities?[indexPath.row] {
            cell.viewModel = CityCellViewModel(for: city)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let city = self.viewModel?.cities?[indexPath.row],
           let navigationController = self.navigationController {
            self.presenter?.cityDetail(for: city, in: navigationController)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let city = self.viewModel?.cities?[indexPath.row] {
                tableView.beginUpdates()
                self.viewModel?.delete(city)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
}

extension CityListViewController: CityListViewModelDelegate {
    
    func cityListViewModelDidChange(_ cityListViewModel: CityListViewModel) {
        self.tableView.reloadData()
    }
    
    func cityListViewModel(_ cityListViewModel: CityListViewModel, failLookupFor city: String) {
        
        let alert = UIAlertController(title: "ITCrow Forecast", message: "We are not able to provide the forecast for the city \"\(city)\"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

    func cityListViewModel(_ cityListViewModel: CityListViewModel, loading: Bool) {
        if loading {
            self.activityIndicator?.startAnimating()
        } else {
            self.activityIndicator?.stopAnimating()
        }
    }

}

extension CityListViewController: CitySearchResultsViewControllerDelegate {
    
    func citySearchResultsViewController(_ citySearchResultsViewController: CitySearchResultsViewController, didSelect prediction: Prediction) {
        guard let cityName = prediction.description else { return }
        self.viewModel?.lookupForCityWith(name: cityName)
        self.searchController?.isActive = false
    }
    
}
