//
//  UIImage+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 1/22/22.
//

import Foundation
import UIKit.UIImage
import SwiftUI

fileprivate let imageCache = NSCache<NSURL, UIImage>()
extension UIImage {
    static func download(from url: String?, sampleImageName: String, completion: @escaping (UIImage) -> ()) {
        guard let url = url else {
            let sampleImage: UIImage = .init(named: sampleImageName)!
            completion(sampleImage)
            return
        }
        if let url = URL.init(string: url) {
            if let cachedImage = imageCache.object(forKey: url as NSURL) {
                completion(cachedImage)
                return
            }
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let data = data,
                    error == nil,
                    let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: url as NSURL)
                    completion(image)
                }
            }.resume()
        }
    }
    
    func toData()-> Data {
        return self.jpegData(compressionQuality: 1)!
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        if (self.size.width <= width) {
            return self
        }
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func setParameters(blur: CGFloat, contrast: CGFloat, saturation: CGFloat, brightness: CGFloat) -> UIImage? {
       guard let ciImg = CIImage(image: self) else { return nil }
       let blurredImage = ciImg.clampedToExtent()
                               .applyingFilter(
                                 "CIGaussianBlur",
                                 parameters: [
                                   kCIInputRadiusKey: blur
                                 ]
                               )
                               .applyingFilter("CIColorControls", parameters: [
                                kCIInputSaturationKey : saturation,
                                kCIInputBrightnessKey : brightness,
                                kCIInputContrastKey : contrast
                               ])
                               .cropped(to: ciImg.extent)
        let context = CIContext(options: nil)
       if let outputImage = context.createCGImage(blurredImage, from:  blurredImage.extent) {
           
          return UIImage(cgImage: outputImage)
       }
       return nil
     }
    
    
    func overlayColor() throws -> Color? {
        let averageColor: UIColor = self.averageColor ?? UIColor.black
        return averageColor.isDark() ? Color.white : Color.black
    }
    
    
    var averageColor: UIColor? {
        // Shrink down a bit first
            let aspectRatio = self.size.width / self.size.height
            let resizeSize = CGSize(width: 40.0, height: 40.0 / aspectRatio)
            let renderer = UIGraphicsImageRenderer(size: resizeSize)
            let baseImage = self
            
            let resizedImage = renderer.image { (context) in
                baseImage.draw(in: CGRect(origin: .zero, size: resizeSize))
            }

            // Core Image land!
            guard let inputImage = CIImage(image: resizedImage) else { return nil }
            let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

            guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
            guard let outputImage = filter.outputImage else { return nil }

            var bitmap = [UInt8](repeating: 0, count: 4)
            let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

            return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)

       }
    
}
