//
//  HomeScreenViewController.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import UIKit
import AlamofireImage
class HomeScreenViewController: UIViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var eventsTableView: UITableView!
    
    var events: [Event]?
    var selectedId: Int?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        self.searchBar.delegate = self
        
        eventsTableView.register(UINib(nibName: "HomeScreenEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: HomeScreenEventTableViewCell.reuseIdentifier)
        
        //Get random set of events with favorites
        getEventList(search: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func getEventList(search: String) {
        GlobalData.shared.getEventList(search: search) { (events, errorMessage) in
            guard let events = events else { return }
            
            self.events = events
            
            self.eventsTableView.reloadData()
        }
    }
    
    private func event(at indexPath: IndexPath) -> Event? {
        if let events = events {
            guard (events.count > indexPath.row) else {
                return nil
            }
            
            return events[indexPath.row]
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventDetailViewController {
            destination.eventId = selectedId
            destination.delegate = self
        }
    }
}
extension HomeScreenViewController: EventDetailViewControllerDelegate {
    func favoriteButtonPressed(id: Int) {
        if var selected = GlobalData.shared.eventsDict[id] {
            selected.isFavorite = true
            GlobalData.shared.eventsDict.updateValue(selected, forKey: id)
            GlobalData.shared.reloadEventList()
            self.events = GlobalData.shared.eventsList
            self.eventsTableView.reloadData()
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenEventTableViewCell.reuseIdentifier, for: indexPath) as! HomeScreenEventTableViewCell
        
        guard let event = event(at: indexPath) else {
            return cell
        }
        
        if let performer = event.performers?.first, let imageUrl = performer.image {
            if let url = URL(string: imageUrl) {
                cell.eventImageView.af.setImage(withURL: url)
            }
        }
        
        cell.event = event
        cell.isFavorite = event.isFavorite
        cell.setData()
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = event(at: indexPath) else { return }
        selectedId = event.id
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "navigateToDetails", sender: self)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Only search when the user has pressed search to avoid multiple api calls
        if let searchText = searchBar.text {
            getEventList(search: searchText)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
}
