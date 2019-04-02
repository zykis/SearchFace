//
//  SearchFaceResults.swift
//  SearchFace
//
//  Created by Артём Зайцев on 27/03/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation

class SearchFaceResult: NSObject {
    var score: Float = 0.0
    var thumbnails: [Thumbnail] = []
    
    init(json: [Any]) {
        if let number = json[0] as? NSNumber {
            score = number.floatValue
        }
        var i = 1
        let thumbnailsJSON: [Any] = json[1] as! [Any]
        for thumbnailJSON in thumbnailsJSON {
            let thumbnail = Thumbnail(json: thumbnailJSON as! [Any])
            thumbnails.append(thumbnail)
            i+=1
        }
    }
}

class Thumbnail: NSObject {
    var url: String
    var center: (x: Int, y: Int) = (x: 0, y: 0)
    var radius: Int = 0
    
    init(json: [Any]) {
        url = json[0] as! String
        if let x = json[1] as? NSNumber, let y = json[2] as? NSNumber {
            center.x = x.intValue
            center.y = y.intValue
        }
        if let r = json[3] as? NSNumber {
            radius = r.intValue
        }
    }
}
