//
//  PlanRApp.swift
//  PlanR
//
//  Created by James Yackanich on 11/24/24.
//

import SwiftUI
import FirebaseCore

@main
struct PlanRApp: App {

    @State private var authManager: AuthManager // <-- Create a state-managed authManager property
    @State private var isSplashScreenActive = true // <-- Add a state to track splash screen visibility

    init() {
        FirebaseApp.configure()
        authManager = AuthManager() // <-- Initialize the authManager property (after FirebaseApp.configure())
    }

    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .onAppear {
                        // Show the splash screen for 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isSplashScreenActive = false
                            }
                        }
                    }
            } else {
                // Normal behavior: show TaskView or LoginView based on auth state
                if authManager.user != nil { // Check if a user is logged in
                    TaskView()
                        .environment(authManager)
                } else {
                    LoginView()
                        .environment(authManager)
                }
            }
        }
    }
}
