//
//  WhatsNewApp.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import SwiftUI

@main
struct WhatsNewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { ImageFetcher() }.scope(.shared)
  }
}
