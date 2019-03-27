//
//  ViewController.swift
//  SearchFace
//
//  Created by Артём Зайцев on 26/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let picker: UIImagePickerController = UIImagePickerController()
    let api: SearchFaceAPI = SearchFaceAPI()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.sourceType = .photoLibrary
    }
    
    @IBAction func search(_ sender: Any) {
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: { () -> Void in
            self.api.performSearch(image: chosenImage, completionHandler: {results in
                print(results)
            })
        })
    }
}

