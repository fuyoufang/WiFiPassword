//
//  ContentView.swift
//  WiFiPassword
//
//  Created by fuyoufang on 2021/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State private var name: String?
    @State private var password: String?
    @State private var errorMsg: String?
    @State var frame: CGSize = .zero
    @State var infoViewSize: CGSize = CGSize(width: 500, height: 380)
    
    var body: some View {
        VStack {
            HStack {
                Button("获取 WiFi 信息") {
                    guard let r = getWifiPassword() else {
                        return
                    }
                    self.name = r.0
                    self.password = r.1
                }
                .padding()
                if name != nil, password != nil {
                    Button("保存为图片") {
                        guard let name = self.name, let password = self.password else {
                            return
                        }
                        let nsImage = WiFiInfoView(name: name, password: password)
                            .snapshot(size: infoViewSize)
                        saveNSImage(nsImage)
                    }
                }
            }
            .padding()
           
            if let errorMsg = errorMsg {
                Text(errorMsg)
                    .foregroundColor(Color.red)
            }
            
            if let name = self.name, let password = self.password {
                GeometryReader { (geometry) in
                    WiFiInfoView(name: name, password: password)
                        .preference(
                            key: SizePreferenceKey.self,
                            value: geometry.size
                        )
                        
                }
            }
        }
        .frame(minWidth: 600, idealWidth: 600, minHeight: 500, idealHeight: 500, alignment: .center)
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.infoViewSize = preferences
        }
    }
    
    func getWifiPassword() -> (String, String)? {
        let ssid: String
        self.errorMsg = nil
        do {
            ssid = try WiFiHelper.getSsid()
        } catch {
            self.errorMsg = "未获取到 WiFi"
            return nil
        }
       
        guard let password = WiFiHelper.getPassword(ssid: ssid) else {
            self.errorMsg = "未获取到 Password"
            return nil
        }
        debugPrint("wifi: \(ssid), password:\(password)")
        return (ssid, password)
    }
    
    /// 保存图片
    /// https://stackoverflow.com/questions/39925248/swift-on-macos-how-to-save-nsimage-to-disk
    func saveNSImage(_ nsImage: NSImage) {
        let panel = NSSavePanel()
        panel.title = "保存 WiFi 信息"
        panel.message = "将 WiFi 信息进行保存，便于下次使用"
        panel.allowedFileTypes = ["png", "jpg", "bmp"]
        panel.nameFieldStringValue = "WiFi-Password.png"
        panel.nameFieldLabel = "图片名称（Image Name）"
        panel.begin { (response) in
            switch response {
            case .OK:
                guard let file = panel.url?.path else {
                    return
                }
                let destinationURL = URL(fileURLWithPath: file)
                do {
                    try nsImage.pngWrite(to: destinationURL, options: .withoutOverwriting)
                } catch {
                    self.errorMsg = error.localizedDescription
                }
                
            case .cancel:
                debugPrint("cancel")
            default:
                break
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
