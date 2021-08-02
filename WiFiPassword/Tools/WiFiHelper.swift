//
//  WiFiHelper.swift
//  WiFiPassword
//
//  Created by fuyoufang on 2021/7/31.
//

import Foundation

struct WiFiHelper {
    static func getSsid() throws -> String {
        let path = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
        var isDirectory: ObjCBool = true
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        
        guard fileExists && !isDirectory.boolValue else {
            debugPrint("no WiFi")
            throw AppError.noWiFiInformation
        }

        /*
         
         let command = "\(path) -I | awk '/ SSID/ {{print substr($0, index($0, $2))}}'"
         
         awk '/ SSID/ {{print substr($0, index($0, $2))}}'
         解释：
         1. / SSID/: 为模式，标识包含 " SSID" 的行
         2. substr($0, index($0, $2))：为截取 $0 从 index($0, $2) 开始到最后的字符串，
            举例来说，加入字符串为："   SSID: 10-floor-5G"，
            则 $0 为 "   SSID: 10-floor-5G"，$1 为 "SSID:", $2 为 "10-floor-5G"，
         参考资料
         https://www.cnblogs.com/Berryxiong/p/4807640.html
         */
        //
        let command = "\(path) -I"
        
        guard let result = shell(command) else {
            throw AppError.noWiFiInformation
        }
        
        let ssidLine: String? = result.components(separatedBy: "\n")
            .first { (line: String) -> Bool in
                return line.contains(" SSID:")
            }
        
        guard let line = ssidLine, let range = line.range(of: "SSID:") else {
            throw AppError.noWiFiInformation
        }
        
        let ssid = line[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard ssid.count > 0 else {
            throw AppError.noWiFiInformation
        }
        return ssid

    }
    
    static func getPassword(ssid: String) -> String? {
        let command = "security find-generic-password -l \"\(ssid)\" -D 'AirPort network password' -w"
        guard let result = shell(command), !result.isEmpty else {
            return nil
        }
        return result
    }
    
    static func getQRCodeText(ssid: String, password: String) -> String {
        return "WIFI:T:WPA;S:\(ssid);P:\(password);;"
    }
    
}

func shell(_ command: String) -> String? {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)?
        .trimmingCharacters(in: .newlines)
    
    return output
}
