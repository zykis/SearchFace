//
//  SearchFaceAPI.swift
//  SearchFace
//
//  Created by Артём Зайцев on 26/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class SearchFaceAPI: NSObject {
    func performSearch(image: UIImage, completionHandler: @escaping ([SearchFaceResult]) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        let fileName = "file.jpg"
        let body: Data = generateMultipartBody(image: image, boundary: boundary, fileName: fileName)
        
        var request = URLRequest(url: URL(string: "http://searchface.ru/request/")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Accept-Encoding": "gzip, deflate",
            "Content-Length":"\(body.count)"]
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (body, response, error) in
            guard let dataResponse = body,
                error == nil else {
                    print(error?.localizedDescription ?? "Response error")
                    return }
            do {
                var results: [SearchFaceResult] = []
                
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [Any]
                for result in jsonResponse {
                    let objJSON = result as! [Any]
                    let obj = SearchFaceResult(json: objJSON)
                    results.append(obj)
                }
                
                completionHandler(results)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func generateMultipartBody(image: UIImage, boundary: String, fileName: String) -> Data {
        var data = Data()
        let photoData: Data = image.jpegData(compressionQuality: 1.0)!
        
        data.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
        data.append("Content-Disposition: form-data; name=\"upl\"; filename=\"\(fileName)\"\r\n)".data(using: .utf8, allowLossyConversion: false)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
        data.append(photoData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8, allowLossyConversion: false)!)
        
        return data
    }
}
