
//
//  _43_ChordableApp.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//

// _43_ChordableApp.swift
// _43_ChordableApp.swift

import SwiftUI
import SpotifyWebAPI

@main
struct _43_ChordableApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var onboardingState = OnboardingState()
    @StateObject var spotify = Spotify()
    @State private var isAuthorized = false
    @StateObject var homeModel: HomeModel

    init() {
        SpotifyAPILogHandler.bootstrap()
        // ADDING THE BELOW two lines because we want to add a context to the home model for testing purposes
        let context = persistenceController.container.viewContext

        _homeModel = StateObject(wrappedValue: HomeModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            if onboardingState.hasCompletedOnboarding {
                MainTabView(isAuthorized: $isAuthorized)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(spotify)
                    .environmentObject(homeModel)
                    .onAppear(perform: {
                        homeModel.appOpened()
                    })
            } else {
                WelcomeView(isAuthorized: $isAuthorized)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(onboardingState)
                    .environmentObject(spotify)
                    .environmentObject(homeModel)
                    .onAppear(perform: {
                        homeModel.appOpened()
                    })
            }
        }
    }
}


class OnboardingState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
    }
}
