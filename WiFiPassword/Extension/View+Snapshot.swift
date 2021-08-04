//
//  View+Snapshot.swift
//  WiFiPassword
//
//  Created by fuyoufang on 2021/8/4.
//

import SwiftUI

extension View {
    
    /// 获取 view 的截图
    /// https://stackoverflow.com/questions/58745000/how-to-convert-a-swift-ui-view-to-a-nsimage
    /// - Parameter size: 图片尺寸
    /// - Returns: 图片
    func snapshot(size: CGSize) -> NSImage? {
        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let newWindow = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        newWindow.contentView = NSHostingView(rootView: self)
        
        guard let bitMapRep = newWindow.contentView!.bitmapImageRepForCachingDisplay(in: contentRect) else {
            return nil
        }
        
        newWindow.contentView!.cacheDisplay(in: contentRect, to: bitMapRep)
        let image = NSImage(size: bitMapRep.size)
        image.addRepresentation(bitMapRep)
        return image

    }
}
