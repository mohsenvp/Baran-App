//
//  SingleCustomize.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//

import SwiftUI

struct SingleCustomize: View {
    @EnvironmentObject var premium: Premium
    
    @StateObject var viewModel: SingleCustomizeViewModel
    @Binding var isPresented: Bool
    @State var isTutorialShown = false
    
    @State var availableSpace: CGFloat = 0.0
    @State var headerHeight: CGFloat = 12.0
    
    var navigationTitle: Text {
        switch viewModel.widgetFamily {
        case .small:
            return Text("Mini Style \(viewModel.widgetIndex + 1)", tableName: "WidgetTab")
        case .medium:
            return Text("Medium Style \(viewModel.widgetIndex + 1)", tableName: "WidgetTab")
        default:
            return Text("Detailed Style \(viewModel.widgetIndex + 1)", tableName: "WidgetTab")
            
        }
    }
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top){
                
                VStack(spacing: 0){
                    
                    Color.clear
                        .frame(height: headerHeight)
                    Color.clear
                        .frame(height: availableSpace)
                        .onChange(of: geo.size, perform: { size in
                            self.availableSpace = size.height * 0.39
                        })
                    
                    
                    VStack(spacing: 0){
                        
                        HStack(alignment: .center){
                            TabItem(title: Text("Background", tableName: "WidgetTutorials"), index: 0, viewModel: viewModel)
                            TabItem(title: Text("Icon Pack", tableName: "WidgetTutorials"), index: 1, viewModel: viewModel)
                            TabItem(title: Text("Font Style", tableName: "WidgetTutorials"), index: 2, viewModel: viewModel)
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                        TabView(selection: $viewModel.selectedTab) {
                            Backgrounds(viewModel: viewModel)
                                .tag(0)
                            
                            Icons(viewModel: viewModel)
                                .tag(1)
                            
                            Fonts(viewModel: viewModel)
                                .tag(2)
                        }
                        .frame(maxHeight: .infinity)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        
                        VStack {
                            Spacer(minLength: 0)
                            Button {
                                guard premium.isPremium || (viewModel.selectedBackgroundIndex < 3 && Int(viewModel.selectedIconPack)! < 4 && viewModel.imageData == nil) else {
                                    viewModel.isSubscriptionViewPresented.toggle()
                                    return
                                }
                                isTutorialShown.toggle()
                                viewModel.edittingTheme.shouldHideBG = false
                                if let data = viewModel.edittedImageData {
                                    viewModel.edittingTheme.backgroundImageName = "\(UUID().uuidString)"
                                    let image = data.toImage()
                                    FileManager.save(value: data, for: viewModel.edittingTheme.backgroundImageName!)
                                }
                                
                                viewModel.setPreferredTheme(viewModel.edittingTheme, isPremium: premium.isPremium)
                            } label: {
                                
                                HeyButton(title: Text("Save theme", tableName: "WidgetTab"))
                                    .padding(.horizontal)
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(height: geo.size.height * 0.1)
                        .buttonStyle(.plain)
                    }
                    .frame(height: geo.size.height * 0.6)
                    .background(Color.init(.systemBackground))
                    .clipShape(RoundedCorners(tl: Constants.widgetRadius, tr: Constants.widgetRadius))
                    .shadow(radius: 12, y: -2)
                    
                    
                }
                
                CustomizeTutorialView(
                    availableSpace: $availableSpace,
                    topPadding: headerHeight,
                    widgetFamily: viewModel.widgetFamily,
                    widgetIndex: viewModel.widgetIndex,
                    isShown: $isTutorialShown,
                    isParentShown: $isPresented
                ) {
                    CustomizableWidgetPreview(
                        theme: viewModel.edittingTheme,
                        widgetFamily: viewModel.widgetFamily,
                        widgetIndex: viewModel.widgetIndex,
                        weatherData: viewModel.weatherData
                    ) {
                        if let edittedImage = viewModel.edittedImageData?.toImage() {
                            Image(uiImage: edittedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                }
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
            .onChange(of: viewModel.selectedBackgroundIndex) { newValue in
                viewModel.setThemeBackgroundColor(index: newValue)
            }
            .onChange(of: viewModel.selectedIconPack) { newValue in
                viewModel.edittingTheme.iconSet = newValue
            }
            .onChange(of: viewModel.selectedFont) { newValue in
                viewModel.edittingTheme.font = newValue
            }
            .navigationTitle(navigationTitle)
            .background(Color(.secondarySystemBackground))
            .onAppear { viewModel.onAppear() }
            .sheet(isPresented: $viewModel.isSubscriptionViewPresented, content: {
                SubscriptionView(viewModel: .init(premium: premium), isPresented: $viewModel.isSubscriptionViewPresented)
            })
            .onReceive(Constants.premiumPurchaseWasSuccessfulPublisher) { _ in
                isPresented = false
            }
            .sheet(isPresented: $viewModel.isImagePickerPresented, onDismiss: {
                if viewModel.imageData != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.isImageCropperPresented = true
                    }
                }
            }, content: {
                ImagePicker(image: $viewModel.imageData)
            })
            .sheet(isPresented: $viewModel.isImageCropperPresented, onDismiss: {
                if (!premium.isPremium) {
                    viewModel.isSubscriptionViewPresented.toggle()
                }
                if let data = viewModel.imageData {
                    viewModel.edittingTheme.shouldHideBG = true
                    viewModel.edittedImageData = data
                    viewModel.edittingTheme.backgroundImageName = "\(UUID().uuidString)"
                    FileManager.save(value: data, for: viewModel.edittingTheme.backgroundImageName!)
                    viewModel.selectedBackgroundIndex = -1
                    do {
                        viewModel.edittingTheme.fontColorString = try UIImage(data: data)?.overlayColor()?.toHex() ?? "FFFFFF"
                    }catch{
                        
                    }
                }
            }, content: {
                ImageCropper(image: $viewModel.imageData, visible: $viewModel.isImageCropperPresented, family: $viewModel.widgetFamily)
                    .zIndex(10)
            })
        }
        
    }
    
    private struct TabItem: View {
        var title: Text
        var index: Int
        @ObservedObject var viewModel: SingleCustomizeViewModel
        
        var body: some View {
            Button {
                viewModel.selectedTab = index
            } label: {
                title
                    .fonted(.subheadline, weight: .semibold)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.widgetRadius, style: .continuous)
                            .fill(viewModel.selectedTab == index ? Color.accentColor.opacity(0.1) : Color(.secondarySystemBackground))
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.widgetRadius, style: .continuous)
                            .stroke(Color.accentColor, lineWidth: viewModel.selectedTab == index ? 1 : 0)
                    }
            }
            .tint(viewModel.selectedTab == index ? Color.accentColor : Color(.secondaryLabel))
        }
    }
    
    private struct Backgrounds: View {
        @EnvironmentObject var premium: Premium
        @ObservedObject var viewModel: SingleCustomizeViewModel
        
        var body: some View {
            if viewModel.imageData != nil, viewModel.edittedImageData != nil {
                ImageParamEditorView(viewModel: viewModel)
            }else{
                ScrollViewReader { proxy in
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(minimum: 65, maximum: 150)),
                            GridItem(.flexible(minimum: 65, maximum: 150)),
                            GridItem(.flexible(minimum: 65, maximum: 150)),
                            GridItem(.flexible(minimum: 65, maximum: 150))
                        ]) {
                            Button {
                                if premium.isPremium {
                                    viewModel.isImagePickerPresented = true
                                }else {
                                    viewModel.isSubscriptionViewPresented.toggle()
                                }
                            } label: {
                                Image(Constants.Icons.widgetBg)
                                    .frame(width: 65, height: 65)
                            }.overlay(
                                Circle()
                                    .stroke(viewModel.edittingTheme.backgroundImageName != nil ? Color.accentColor : Color(.secondarySystemBackground), lineWidth: 2)
                            )
                            
                            ForEach(0..<Constants.colorStyles.count, id: \.self) { i in
                                let colorStyle = Constants.colorStyles[i]
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [Color(colorStyle[0]), Color(colorStyle[1])],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 65, height: 65)
                                    .overlay(
                                        Circle()
                                            .stroke(i == viewModel.selectedBackgroundIndex ? Color.accentColor : Color(.secondarySystemBackground), lineWidth: 2)
                                    )
                                    .overlay(
                                        ZStack {
                                            if !premium.isPremium && i > 2 {
                                                Image(Constants.Icons.premium)
                                                    .fonted(.title3, weight: .semibold)
                                                    .foregroundColor(.white)
                                            }else if i == viewModel.selectedBackgroundIndex {
                                                Image(Constants.Icons.checked)
                                                    .fonted(.title3, weight: .semibold)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    )
                                    .onTapGesture { viewModel.selectedBackgroundIndex = i }
                            }
                        }
                        .padding(12)
                    }
                    .onAppear {
                        proxy.scrollTo(viewModel.selectedBackgroundIndex, anchor: .center)
                    }
                }
            }
        }
    }
    

    private struct ImageParamEditorView: View {
        @ObservedObject var viewModel: SingleCustomizeViewModel
        @State var activeParam: ImageEditorParam = .blur
        
        @State var blur: CGFloat = 0
        @State var contrast: CGFloat = 1.0
        @State var saturation: CGFloat = 1.0
        @State var brightness: CGFloat = 0.0

        var editorTitle: Text {
            switch activeParam {
            case .blur:
                Text("Blur", tableName: "WidgetTab")
            case .contrast:
                Text("Contrast", tableName: "WidgetTab")
            case .saturation:
                Text("Saturation", tableName: "WidgetTab")
            case .brightness:
                Text("Brightness", tableName: "WidgetTab")
            }
        }
        var body: some View {
            VStack(alignment: .leading){
                HStack {
                    Spacer()

                    Button {
                        viewModel.imageData = nil
                        viewModel.edittedImageData = nil
                        viewModel.edittingTheme.backgroundImageName = nil
                        viewModel.edittingTheme.shouldHideBG = false
                        viewModel.selectedBackgroundIndex = 0
                    } label: {
                        Image(systemName: Constants.SystemIcons.xmark)
                    }
                    .foregroundStyle(Color(.label))
                }
                Spacer()
                
                editorTitle
                
                switch activeParam {
                case .blur:
                    Slider(value: $blur, in: activeParam.min...activeParam.max)
                case .contrast:
                    Slider(value: $contrast, in: activeParam.min...activeParam.max)

                case .saturation:
                    Slider(value: $saturation, in: activeParam.min...activeParam.max)

                case .brightness:
                    Slider(value: $brightness, in: activeParam.min...activeParam.max)
                }

                CustomSegmentPicker(items: [
                    .init(title: Text("Blur", tableName: "WidgetTab"), image: "ic_\(ImageEditorParam.blur.rawValue)"),
                    .init(title: Text("Contrast", tableName: "WidgetTab"), image: "ic_\(ImageEditorParam.contrast.rawValue)"),
                    .init(title: Text("Saturation", tableName: "WidgetTab"), image: "ic_\(ImageEditorParam.saturation.rawValue)"),
                    .init(title: Text("Brightness", tableName: "WidgetTab"), image: "ic_\(ImageEditorParam.brightness.rawValue)"),
                ], selectedIndex: 0, background: Color(.secondarySystemBackground), selectedBackground: Color(.systemBackground)) { index in
                    switch index {
                    case 0:
                        activeParam = .blur
                    case 1:
                        activeParam = .contrast
                    case 2:
                        activeParam = .saturation
                    default:
                        activeParam = .brightness
                    }
                }
                .frame(height: 80)
                
                Spacer()

                
            }
            .background(
                Rectangle().fill(.clear).gesture(DragGesture())
            )
            .padding()
            .onChange(of: blur) { _ in
                if let data = viewModel.imageData {
                    let image = UIImage(data: data)?.setParameters(blur: blur, contrast: contrast, saturation: saturation, brightness: brightness)
                    viewModel.edittedImageData = image?.toData()
                    do {
                        viewModel.edittingTheme.fontColorString = try image?.overlayColor()?.toHex() ?? "FFFFFF"
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            .onChange(of: brightness) { _ in
                if let data = viewModel.imageData {
                    let image = UIImage(data: data)?.setParameters(blur: blur, contrast: contrast, saturation: saturation, brightness: brightness)
                    viewModel.edittedImageData = image?.toData()
                    do {
                        viewModel.edittingTheme.fontColorString = try image?.overlayColor()?.toHex() ?? "FFFFFF"
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            .onChange(of: contrast) { _ in
                if let data = viewModel.imageData {
                    let image = UIImage(data: data)?.setParameters(blur: blur, contrast: contrast, saturation: saturation, brightness: brightness)
                    viewModel.edittedImageData = image?.toData()
                    do {
                        viewModel.edittingTheme.fontColorString = try image?.overlayColor()?.toHex() ?? "FFFFFF"
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            .onChange(of: saturation) { _ in
                if let data = viewModel.imageData {
                    let image = UIImage(data: data)?.setParameters(blur: blur, contrast: contrast, saturation: saturation, brightness: brightness)
                    viewModel.edittedImageData = image?.toData()
                    do {
                        viewModel.edittingTheme.fontColorString = try image?.overlayColor()?.toHex() ?? "FFFFFF"
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private struct Icons: View {
        @EnvironmentObject var premium: Premium
        @ObservedObject var viewModel: SingleCustomizeViewModel
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 120, maximum: .infinity)),
                        GridItem(.flexible(minimum: 120, maximum: .infinity))
                    ]) {
                        ForEach(1..<31, id: \.self) { i in
                            ThemeIconsView(index: i, selectedPack: $viewModel.selectedIconPack, isLocked: (!premium.isPremium && i > 3))
                        }
                    }
                    .padding(.horizontal)
                }.onAppear {
                    let index = Int(self.viewModel.edittingTheme.iconSet) ?? 0
                    proxy.scrollTo(index == 0 ? 0 : index - 1, anchor: .center)
                }
            }
        }
        
        private struct ThemeIconsView : View {
            let index: Int
            @Binding var selectedPack: String
            var isLocked: Bool
            let conditions: [WeatherCondition] = [
                .init(type: .atmosphere, intensity: .normal , isDay: true),
                .init(type: .clouds, intensity: .normal , isDay: false),
                .init(type: .clear, intensity: .normal , isDay: false),
                .init(type: .snow, intensity: .heavy , isDay: true),
                .init(type: .storm, intensity: .normal , isDay: true),
                .init(type: .rain, intensity: .normal , isDay: true)
            ]
            var body : some View {
                let iconSet = (index < 10 ? "0" : "") + "\(index)"
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 24, maximum: 100)),
                    GridItem(.flexible(minimum: 24, maximum: 100)),
                    GridItem(.flexible(minimum: 24, maximum: 100)),
                ]) {
                    ForEach(0..<conditions.count, id: \.self) { i in
                        ConditionIcon(iconSet: iconSet, condition: conditions[i])
                            .frame(width: 20, height: 20)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground).cornerRadius(Constants.weatherTabRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                        .stroke(iconSet == selectedPack ? Constants.accentColor : .clear ,lineWidth: 2.5)
                        .padding(2)
                )
                .overlay(content: {
                    if (isLocked){
                        PremiumOverlay()
                    }
                })
                .onTapGesture { selectedPack = iconSet }
            }
        }
    }
    
    
    private struct Fonts: View {
        @EnvironmentObject var premium: Premium
        @ObservedObject var viewModel: SingleCustomizeViewModel
        
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 80, maximum: .infinity)),
                        GridItem(.flexible(minimum: 80, maximum: .infinity)),
                        GridItem(.flexible(minimum: 80, maximum: .infinity))
                    ]) {
                        ForEach(1..<Constants.fonts.count, id: \.self) { i in
                            ThemeFontView(index: i, font: Constants.fonts[i], selectedFont: $viewModel.selectedFont, isLocked: (!premium.isPremium && i > 3))
                        }
                    }
                    .padding(.horizontal)
                }.onAppear {
                    let index = Int(self.viewModel.edittingTheme.iconSet) ?? 0
                    proxy.scrollTo(index == 0 ? 0 : index - 1, anchor: .center)
                }
            }
        }
        
        private struct ThemeFontView : View {
            let index: Int
            var font: String
            @Binding var selectedFont: String?
            var isLocked: Bool
            
            var body : some View {
                
                Text(font)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .fonted(size: 14, weight: .bold, custom: font)
                    .padding()
                    .background(Color(.secondarySystemBackground).cornerRadius(Constants.weatherTabRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                            .stroke(font == selectedFont ? Constants.accentColor : .clear ,lineWidth: 2.5)
                    )
                    .overlay(content: {
                        if (isLocked){
                            PremiumOverlay()
                        }
                    })
                    .padding(.vertical, 2)
                    .onTapGesture { selectedFont = font }
            }
        }
        
    }
    
    
    private struct PremiumOverlay: View {
        var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                        .fill(RadialGradient(colors: [Color.accentColor, .clear], center: .center, startRadius: 0, endRadius: geo.size.width / 2))
                    
                    Image(Constants.Icons.premium)
                        .fonted(.title, weight: .semibold)
                        .foregroundColor(.white)

                }
            }
            
            
        }
    }
    
    
}
extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {

        guard let data = self.pngData() else {
            return ""
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return String(format: "%.2f", size)
    }
}
