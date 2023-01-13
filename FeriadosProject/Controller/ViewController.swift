//
//  ViewController.swift
//  FeriadosProject
//
//  Created by Diego Araújo Borges on 12/01/23.
//

import UIKit

class HolidayTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listOfHolidays = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let holiday = listOfHolidays[indexPath.row]
        
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        
        return cell
    }
    


}

extension HolidayTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        let holidayRequest =
        HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays {[weak self] result in
            switch result {
            case .failure(let error):
                print (error)
            case .success(let holidays):
                self?.listOfHolidays = holidays
                
            }
        }
        
    }
}
