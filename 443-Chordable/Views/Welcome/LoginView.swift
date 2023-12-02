//
//  LoginView.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 11/21/23.
//  Login view from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Views/LoginView.swift

import SwiftUI
import Combine

/**
 A view that presents a button to login with Spotify.

 It is presented when `isAuthorized` is `false`.

 When the user taps the button, the authorization URL is opened in the browser,
 which prompts them to login with their Spotify account and authorize this
 application.

 After Spotify redirects back to this app and the access and refresh tokens have
 been retrieved, dismiss this view by setting `isAuthorized` to `true`.
 */
struct LoginView: ViewModifier {

    /// Always show this view for debugging purposes. Most importantly, this is
    /// useful for the preview provider.
    fileprivate static var debugAlwaysShowing = false
    
    /// The animation that should be used for presenting and dismissing this
    /// view.
    static let animation = Animation.spring()
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var spotify: Spotify

    /// After the app first launches, add a short delay before showing this view
    /// so that the animation can be seen.
    @State private var finishedViewLoadDelay = false
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(red: 0.467, green: 0.765, blue: 0.267),
                Color(red: 0.190, green: 0.832, blue: 0.437)
            ]
        ),
        startPoint: .leading, endPoint: .trailing
    )
    
    var spotifyLogo: ImageName {
        colorScheme == .dark ? .spotifyLogoWhite
                : .spotifyLogoBlack
    }
    
    func body(content: Content) -> some View {
        content
            .blur(
                radius: spotify.isAuthorized && !Self.debugAlwaysShowing ? 0 : 3
            )
            .overlay(
                ZStack {
                    if !spotify.isAuthorized || Self.debugAlwaysShowing {
                        Color.black.opacity(0.25)
                            .edgesIgnoringSafeArea(.all)
                        if self.finishedViewLoadDelay || Self.debugAlwaysShowing {
                            loginView
                        }
                    }
                }
            )
            .onAppear {
                // After the app first launches, add a short delay before
                // showing this view so that the animation can be seen.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(LoginView.animation) {
                        self.finishedViewLoadDelay = true
                    }
                }
            }
    }
    
    var loginView: some View {
        spotifyButton
            .overlay(retrievingTokensView)
//            .transition(
//                AnyTransition.scale(scale: 1.2)
//                    .combined(with: .opacity)
//            )
    }
    
    var spotifyButton: some View {

        Button(action: spotify.authorize) {
            HStack {
                Text("Connect with Spotify")
                .font(.custom("Barlow-Medium", size: 20))
                .padding(.horizontal, 25)
            }
            .padding()
            .background(.white)
            .clipShape(Capsule())
            .shadow(radius: 5)
        }
        .accessibility(identifier: "Connect with Spotify Identifier")
        .buttonStyle(PlainButtonStyle())
        // Prevent the user from trying to login again
        // if a request to retrieve the access and refresh
        // tokens is currently in progress.
        .allowsHitTesting(!spotify.isRetrievingTokens)
        .padding(.bottom, 5)
        
    }
    
    var retrievingTokensView: some View {
        VStack {
            Spacer()
            if spotify.isRetrievingTokens {
                HStack {
                    ProgressView()
                        .padding()
                    Text("Authenticating")
                }
                .padding(.bottom, 20)
            }
        }
    }
    
}
