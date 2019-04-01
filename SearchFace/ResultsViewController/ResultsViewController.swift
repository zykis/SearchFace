//
//  ResultsViewController.swift
//  SearchFace
//
//  Created by Артём Зайцев on 27/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var results: [SearchFaceResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.section]

        let cell: ResultCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultCell
        cell.scoreLabel.text = "\(Int(result.score * 100))%"
        // in case cell will be reused
        cell.thumbnail1.image = nil
        cell.thumbnail2.image = nil
        cell.thumbnail3.image = nil
        
        if result.thumbnails.count > 0 {
          cell.thumbnail1.imageFromURL(urlString: result.thumbnails[0].url, placeholder: nil)
        }
        if result.thumbnails.count > 1 {
            cell.thumbnail2.imageFromURL(urlString: result.thumbnails[1].url, placeholder: nil)
        }
        if result.thumbnails.count > 2 {
            cell.thumbnail3.imageFromURL(urlString: result.thumbnails[2].url, placeholder: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6.0
    }
}
