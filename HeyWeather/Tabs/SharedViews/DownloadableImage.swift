//
//  DownloadableImage.swift
//  HeyWeather
//
//  Created by Kamyar on 1/22/22.
//

import SwiftUI

struct DownloadableImage: View {
    let urlString: String?
    let sampleImageName: String
    @State var image = UIImage()
    @State var isRedacted = true
    var body: some View {
            Image(uiImage: image)
                .resizable()
                .onAppear {
                    UIImage.download(from: urlString, sampleImageName: sampleImageName) { image in
                        self.image = image
                        isRedacted = false
                    }
                }
                .redacted(reason: isRedacted ? .placeholder : [])
    }
}
