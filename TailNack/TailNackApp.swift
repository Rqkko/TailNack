//
//  TailNackApp.swift
//  TailNack
//
//  Created by Wongsathorn Chengcharoen on 7/6/2568 BE.
//

import SwiftUI
import SwiftData

@main
struct TailNackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FingerNail.self)
    }
}

