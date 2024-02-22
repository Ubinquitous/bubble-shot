//
//  curved_screenApp.swift
//  BubbleShot
//
//  Created by unboxers on 2/13/24.
//

import SwiftUI

@main
struct BubbleShotApp: App {
    @StateObject var counter = CounterModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counter)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environmentObject(counter)
        }
//        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
