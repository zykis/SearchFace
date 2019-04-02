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
        if let url: URL = URL(string: urlString) {
            if let cached: UIImage = imageCache.object(forKey: NSString(string: urlString)) {
                DispatchQueue.main.async {
//                    self.image = cached
                    completionHandler?(cached)
                }
                return
            }
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
                            imageCache.setObject(image, forKey: NSString(string: urlString))
//                            self.image = image
                            completionHandler?(image)
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
