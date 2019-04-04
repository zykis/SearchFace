//
//  UIImage+Utils.swift
//  SearchFace
//
//  Created by Артём Зайцев on 28/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func imageFromURL(urlString: String, placeholder: UIImage?, completionHandler: ((UIImage) -> Void)?) {
        DispatchQueue.main.async {
            self.image = placeholder
        }
        if let url: URL = URL(string: urlString) {
            if let cached: UIImage = imageCache.object(forKey: NSString(string: urlString)) {
                DispatchQueue.main.async {
                    completionHandler?(cached)
                }
                return
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let response = data, error == nil else {
                    print(error?.localizedDescription ?? "Error fetching image: \(urlString))")
                    return }
                do {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: response) {
                            imageCache.setObject(image, forKey: NSString(string: urlString))
                            completionHandler?(image)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
