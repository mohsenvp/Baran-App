//
//  Data+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/11/21.
//

import UIKit.UIImage

extension Data {
    func toImage() -> UIImage {
        let image = UIImage(data: self)
        return image!
    }
}
