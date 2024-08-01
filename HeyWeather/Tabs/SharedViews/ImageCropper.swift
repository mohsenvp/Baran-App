//
//  ImageCropper.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/8/23.
//

import SwiftUI
import UIKit
import CropViewController

struct ImageCropper: UIViewControllerRepresentable {
    
    @Binding var image: Data?
    @Binding var visible: Bool
    @Binding var family: WidgetSize

    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let img = self.image?.toImage()
        let cropViewController = CropViewController(image: img ?? UIImage())
        cropViewController.delegate = context.coordinator
        
        switch family {
        case .small:
            cropViewController.customAspectRatio = CGSize(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
        case .medium:
            cropViewController.customAspectRatio = CGSize(width: Constants.mediumWidgetSize.width, height: Constants.mediumWidgetSize.height)
        default:
            cropViewController.customAspectRatio = CGSize(width: Constants.largeWidgetSize.width, height: Constants.largeWidgetSize.height)
        }
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetButtonHidden = true
        cropViewController.aspectRatioPickerButtonHidden = true
        return cropViewController
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        
        let parent: ImageCropper
        
        init(_ parent: ImageCropper){
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            
            parent.image = image.resized(toWidth: Constants.mediumWidgetSize.width * 3)!.jpegData(compressionQuality: 60)

            withAnimation{
                parent.visible = false
            }
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.image = nil
            withAnimation{
                parent.visible = false
            }
        }
    }
}

