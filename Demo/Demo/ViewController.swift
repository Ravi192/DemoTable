//
//  ViewController.swift
//  Demo
//
//  Created by RAVIKANT KUMAR on 18/07/20.
//  Copyright © 2020 Societe Generale. All rights reserved.
//

import UIKit

import UIKit
import WebKit

class ViewController: UIViewController {
let countryTableView = UITableView()
private var serverClient: ServerClient?
var countaryValue: [Rows] = []
var indicator = UIActivityIndicatorView()
var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupConstraints()
        countryTableView.isHidden = true
        activityIndicator()
        indicator.startAnimating()
        dataFetch()
    }
    
    // MARK: - setUPUIComponents
    private func setupComponents () {
      view.backgroundColor = .white
      view.addSubview(countryTableView)
      countryTableView.dataSource = self
      countryTableView.delegate = self
      countryTableView.estimatedRowHeight = 100
      countryTableView.rowHeight = UITableView.automaticDimension
      countryTableView.tableFooterView = UIView(frame: CGRect.zero)
      countryTableView.register(countryCell.self, forCellReuseIdentifier: "countryCell")
      refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
      refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
      countryTableView.addSubview(refreshControl)
    }
    
    // MARK: - setUPUIConstraints
    private func setupConstraints() {
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        countryTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        countryTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        countryTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        countryTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - refreshTableView On Pull Down
    @objc func refresh(_ sender: AnyObject) {
        self.countaryValue.removeAll()
        dataFetch()
        self.countryTableView.isHidden = false
        self.countryTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
     // MARK: - Activity Indicator while loading data
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
     // MARK: - API Call
    func dataFetch () {
        serverClient = ServerClient()
        serverClient?.getCountaryData(completionHandler: { (countaryData, http, error) in
            if http == 200 {
                let data = countaryData
                DispatchQueue.main.async {
                self.navigationItem.title = data.title
                }
                for countaryData in data.rows {
                self.countaryValue.append(countaryData)
                }
                self.countaryValue = self.countaryValue.filter { $0.title != nil || $0.description != nil || $0.imageHref != nil
                }
                print(self.countaryValue.count)
                DispatchQueue.main.async {
                self.countryTableView.isHidden = false
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.countryTableView.reloadData()
                }
            }
        })
        
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countaryValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! countryCell
        cell.country = countaryValue[indexPath.row]
        return cell
    }
    
    // On click of table cell , Selected cell image will download
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? countryCell
        cell?.cacheImageDownload(withData: countaryValue[indexPath.row])
    }
    
}
