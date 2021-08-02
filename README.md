# WiFiPassword

WiFiPassword 是一款 Mac 软件，有如下功能：

1. 忘记 mac 的 wifi 密码之后，可以查看 wifi 密码
2. mac 连接 WiFi 之后，可以生成二维码给手机扫描加入
3. 可以保存 WiFi 信息成图片，UI 还过得去

> 发现一个bug，生成的 WiFi 信息的截图的背景是透明的，但是现在我不知道 Window 的默认背景色是什么，怎么才能给 some view 设置成和 window 一样的背景色，并且能随着系统的外观（深色或者浅色）进行变化。

## 软件信息

1. 开发语言：Swift 5
1. UI：SwiftUI
1. 运行环境：Mac 10.15+

## 运行 UI 截图

| 界面 | 截图 |
| :---: | :---: |
| UI 主界面 | ![](Images/main.jpg) | 
| 保存的 WiFi 信息图片 | ![](Images/wifi_info.jpg) |

## 参考资料

1. 获取 WiFi 密码的思路来源于 [wifi-password](https://github.com/sdushantha/wifi-password)
2. WiFi 信息的 UI 参考了 [wifi-card](https://github.com/bndw/wifi-card)
3. 生成二维码的代码来源于 [QRCode]( https://github.com/aschuch/QRCode)
1. 其他资料 [resize-ciimage-to-an-exact-size](https://stackoverflow.com/questions/61589783/resize-ciimage-to-an-exact-size), [image-resizing](https://nshipster.com/image-resizing/) 等。
 
