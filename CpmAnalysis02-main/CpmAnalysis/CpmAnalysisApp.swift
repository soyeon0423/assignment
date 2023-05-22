//
//  CpmAnalysisApp.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/22.
//

import SwiftUI

@main
struct CpmAnalysisApp: App {
    @StateObject var vm = CpmViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
