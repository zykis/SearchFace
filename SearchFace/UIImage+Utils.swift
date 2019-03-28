//
//  UIImage+Utils.swift
//  SearchFace
//
//  Created by Артём Зайцев on 28/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageFromURL(urlString: String, placeholder: UIImage?) {
        if let url: URL = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let response = data, error == nil else {
                    print(error?.localizedDescription ?? "Error fetching image: \(urlString))")
                    DispatchQueue.main.async {
                        if placeholder != nil {
                            self.image = placeholder
                        }
                    }
                    return }
                do {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: response) {
                            self.image = image
                        } else if placeholder != nil {
                            self.image = placeholder
                        }
                    }
                }
            }
            task.resume()
        }
    }
}