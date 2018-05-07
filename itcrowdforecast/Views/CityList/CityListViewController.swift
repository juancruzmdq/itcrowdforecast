//
//  CityListViewController.swift
//  itcrowdforecast
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit
import CoreData

class CityListViewController: UITableViewController {
    
    var viewModel: CityListViewModel?
    
    var presenter: CityListPresenterProtocol?
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        
        self.title = "My cities"
        self.definesPresentationContext = true
        
        self.viewModel?.delegate = self
        
        self.buildSearchController()
        
        self.buildRefreshControl()

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
        
        let citySearchResultsViewController = self.presenter?.buildCitySearchResultsViewController()
        citySearchResultsViewController?.delegate = self
        
        self.searchController = UISearchController(searchResultsController: citySearchResultsViewController)
        self.searchController?.searchResultsUpdater = citySearchResultsViewController
        self.searchController?.searchBar.placeholder = "Search new cities"
        
        self.navigationItem.searchController = self.searchController

    }
    
    func buildRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(type(of: self).refreshControl(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)

        self.tableView.refreshControl = refreshControl
    }

    @objc func refreshControl(_ sender: UIRefreshControl) {
        self.viewModel?.refreshAllCities()
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
                // Do the delete animation here instad of wait the NSFetchedResultsController.didChange, due the delete animation looks better if is executed after the user swipe the cell
                tableView.beginUpdates()
                self.viewModel?.delete(city)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
}

extension CityListViewController: CityListViewModelDelegate {
    
    func cityListViewModelWillChange(_ cityListViewModel: CityListViewModel) {
        tableView.beginUpdates()
    }
    
    func cityListViewModel(_ cityListViewModel: CityListViewModel, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath,
                  let cell = self.tableView.cellForRow(at: indexPath) as? CityTableViewCell,
                  let city = anObject as? LocalCity else { return }
            cell.viewModel = CityCellViewModel(for: city)
        default:
            break
        }
    
    }
        
    func cityListViewModelDidChange(_ cityListViewModel: CityListViewModel) {
        tableView.endUpdates()
    }
    
    func cityListViewModel(_ cityListViewModel: CityListViewModel, failLookupFor city: String) {
        
        let alert = UIAlertController(title: "ITCrow Forecast", message: "We are not able to provide the forecast for the city \"\(city)\"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

    func cityListViewModel(_ cityListViewModel: CityListViewModel, loading: Bool) {
        if !loading {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

}

extension CityListViewController: CitySearchResultsViewControllerDelegate {
    
    func citySearchResultsViewController(_ citySearchResultsViewController: CitySearchResultsViewController, didSelect prediction: Prediction) {
        guard let cityName = prediction.description else { return }
        
        // start a new city search
        self.viewModel?.lookupForCityWith(name: cityName)
        
        // Hide searchController
        self.searchController?.isActive = false
    }
    
}
