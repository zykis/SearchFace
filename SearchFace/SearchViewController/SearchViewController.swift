//
//  ViewController.swift
//  SearchFace
//
//  Created by Артём Зайцев on 26/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                            UITableViewDataSource, UITableViewDelegate, BorderViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var borderView: BorderView!
    
    var results: [SearchFaceResult] = []
    let picker: UIImagePickerController = UIImagePickerController()
    let api: SearchFaceAPI = SearchFaceAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.delegate = self
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SearchFace 2")

        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        let nib = UINib(nibName: "ResultCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
        imageView.image = chosenImage
        
        self.results = []
        self.tableView.reloadData()
        self.tableView.isHidden = true
        dismiss(animated: true, completion: {
            self.api.performSearch(image: chosenImage, completionHandler: {results in
                DispatchQueue.main.async {
                    self.results = results
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            })
        })
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
        
        let scrollView: UIScrollView = cell.viewWithTag(101) as! UIScrollView
        // we can get less, then 5 photos, so better clean this up
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        for (index, thumbnail) in result.thumbnails.enumerated() {
            // image view initialization
            let imageView: UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: CGFloat(index) * scrollView.frame.height + CGFloat(4 * index),
                                                                                   y: 0),
                                                                   size: CGSize(width: scrollView.frame.height,
                                                                                height: scrollView.frame.height)))
            imageView.backgroundColor = UIColor.red
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            // creating ellipse mask
            let bounds = imageView.bounds
            let mask = CAShapeLayer()
            mask.path = CGPath(ellipseIn: imageView.bounds, transform: .none)
            imageView.layer.mask = mask
            
            // creating outline for ellipse
            let outline = CAShapeLayer()
            outline.path = CGPath(ellipseIn: bounds, transform: .none)
            outline.fillColor = nil
            outline.lineWidth = 2.0
            outline.borderColor = UIColor.black.cgColor
            outline.strokeColor = UIColor(white: 0.0, alpha: 0.2).cgColor
            imageView.layer.addSublayer(outline)
            
            // adding to scrollView
            scrollView.addSubview(imageView)
            scrollView.contentSize = CGSize(width: Int(scrollView.frame.height) * (index + 1) + (index * 4),
                                            height: Int(scrollView.frame.height))
            
            // loading an image from url
            imageView.imageFromURL(urlString: thumbnail.url, placeholder: nil, completionHandler: { (image: UIImage) -> Void in
                
                // setting up image
                imageView.image = image
                
                // centering face in image
                let faceRect = CGRect(x: thumbnail.center.x - thumbnail.radius,
                                      y: thumbnail.center.y - thumbnail.radius,
                                      width: thumbnail.radius * 2,
                                      height: thumbnail.radius * 2)
                let contentRect = CGRect(x: faceRect.origin.x / image.size.width,
                                         y: faceRect.origin.y / image.size.height,
                                         width: faceRect.size.width / image.size.width,
                                         height: faceRect.size.height / image.size.height)
                imageView.layer.contentsRect = contentRect
                imageView.layer.contentsGravity = .resizeAspectFill
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6.0
    }
    
    // Border view delegate
    func borderViewTapped() {
        self.present(picker, animated: true, completion: nil)
    }
}

