//
//  PhoneCodePickerController.swift
//  CliqCard
//
//  Created by Sam Ober on 7/7/18.
//  Copyright © 2018 Sam Ober. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhoneCodePickerController: UITableViewController {
    
    struct CountryData {
        let name: String
        let shortName: String
        let code: String
    }
    
    var callback: (CountryData?) -> Void
    
    var countries: [CountryData] = []
    
    init(callback: @escaping (CountryData?) -> Void) {
        self.callback = callback
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(CountryCodeCell.self, forCellReuseIdentifier: "CountryCodeCell")
        self.tableView.separatorStyle = .none
        
        self.view.backgroundColor = Colors.lightestGray

        self.title = "Choose Country"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        
        self.loadCountries()
    }
    
    func loadCountries() {
        // load the path to the country list
        guard let path = Bundle.main.path(forResource: "phoneCodes", ofType: "json") else { return }
        // load the data from the file
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else { return }
        // parse json
        guard let json = try? JSON(data: data) else { return }
        // loop through and create the countries list
        self.countries = json.map({ (key, value) -> CountryData in
            return CountryData(name: value["name"].stringValue, shortName: value["code"].stringValue, code: value["dial_code"].stringValue)
        })
        // reload the table view
        self.tableView.reloadData()
    }

    @objc func close() {
        // call the callback with no data
        self.callback(nil)
        // close the modal
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell

        let countryData = self.countries[indexPath.row]
        cell.country = countryData.name
        cell.code = countryData.code

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let countryData = self.countries[indexPath.row]
        self.callback(countryData)
        self.dismiss(animated: true, completion: nil)
    }

}
