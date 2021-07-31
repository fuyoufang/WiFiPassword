//
//  SizePreferenceKey.swift
//  WiFiPassword
//
//  Created by fuyoufang on 2021/7/31.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
