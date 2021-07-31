//
//  WiFiInfoView.swift
//  WiFiPassword
//
//  Created by fuyoufang on 2021/7/31.
//

import SwiftUI

struct WiFiInfoView: View {
    
    @State var name: String
    @State var password: String
    
    var body: some View {
        VStack {
            Text("WiFi 登陆（WiFi Login）")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                if let image = QRCode(WiFiHelper.getQRCodeText(ssid: name, password: password))?.image {
                    Image(nsImage: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("名称（Network name）")
                            .font(Font.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(name)
                            .font(Font.system(size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("密码（Password）")
                            .font(Font.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(password)
                            .font(Font.system(size: 40))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            VStack {
                Text("📸📱打开相机扫描二维码，自动加入")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                Text("📸📱Point your phone's camera at the QR Code to connect automatically")
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, dash: [10]))
        )
        .padding()
        .frame(minWidth: 500, idealWidth: 500, minHeight: 380, maxHeight: 380, alignment: .center)
    }
    
}

extension View {
    
    /// 获取 view 的截图
    /// https://stackoverflow.com/questions/58745000/how-to-convert-a-swift-ui-view-to-a-nsimage
    /// - Parameter size: 图片尺寸
    /// - Returns: 图片
    func snapshot(size: CGSize) -> NSImage {
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let newWindow = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        newWindow.contentView = NSHostingView(rootView: self)
        
        let bitMapRep = newWindow.contentView!.bitmapImageRepForCachingDisplay(in: contentRect)!
        
        newWindow.contentView!.cacheDisplay(in: contentRect, to: bitMapRep)
        let image = NSImage(size: bitMapRep.size)
        image.addRepresentation(bitMapRep)
        return image

    }
}
