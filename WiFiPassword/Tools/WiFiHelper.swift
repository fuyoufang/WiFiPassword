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
        
        let command = "\(path) -I | awk '/ SSID/ {{print substr($0, index($0, $2))}}'"
        guard let ssid = shell(command) else {
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
