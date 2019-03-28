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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]

        let cell: ResultCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultCell
        cell.scoreLabel.text = "score: \(result.score)"
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
        return 88.0
    }
}
