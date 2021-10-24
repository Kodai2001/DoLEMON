//
//  ViewController.swift
//  LocationSearch
//
//  Created by Jeff Edmondson on 6/24/20.
//  Copyright © 2020 Jeff Edmondson. All rights reserved.
//

import UIKit
import MapKit
class searchPlaceViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    var lon: CLLocationDegrees = 0.0
    var lat: CLLocationDegrees = 0.0
    
    var titleLabel: String = ""
    var addressLabel: String = ""
    
    var nameHolder: String = ""
    
    var place1:String = ""
    var place2:String = ""
    var place3:String = ""
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("this is \(nameHolder)")
        //Set up the delgates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // Setting our searcResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }


}


// Setting up extensions for the table view
extension searchPlaceViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        
        return cell
    }
}


extension searchPlaceViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            guard let n = response?.mapItems[0].placemark.administrativeArea else {
                return
            }
            
            guard let l = response?.mapItems[0].placemark.locality else {
                return
            }
            
            guard let t = response?.mapItems[0].placemark.thoroughfare else {
                return
            }
            
            self.titleLabel = name
            
            self.place1 = t
            self.place2 = l
            self.place3 = n
            
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
            
            //test
            
            self.performSegue(withIdentifier: "toLeaveCommentsVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toLeaveCommentsVC" {
            let leaveCommentsVC = segue.destination as? LeaveCommentsViewController
            leaveCommentsVC?.placeName = self.titleLabel
            leaveCommentsVC?.address = ("\(self.place1),\(self.place2),\(self.place3)")
            leaveCommentsVC?.lonSearched = self.lon
            leaveCommentsVC?.latSearched = self.lat
            leaveCommentsVC?.pinTitle = self.titleLabel
            leaveCommentsVC?.nameHolder = self.nameHolder
        }
    }
}


