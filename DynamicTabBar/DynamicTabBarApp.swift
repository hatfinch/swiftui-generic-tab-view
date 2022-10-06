//
//  DynamicTabBarApp.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

@main
struct DynamicTabBarApp: App {

    static let home = DynamicTabItem("Home", systemName: "house.fill")
    static let messages = DynamicTabItem("Messages", systemName: "message.fill")
    static let favorites = DynamicTabItem("Favorites", systemName: "heart.fill")
    static let profile = DynamicTabItem("Profile", systemName: "person.fill")
    static let trash = DynamicTabItem("Trash", systemName: "trash.fill")
    static let trays = DynamicTabItem("Trays", systemName: "tray.fill")
    static let trophies = DynamicTabItem("Trophies", systemName: "trophy.fill")
    static let umbrellas = DynamicTabItem("Umbrellas", systemName: "umbrella.fill")
    static let flames = DynamicTabItem("Flames", systemName: "flame.fill")
    static let fleurons = DynamicTabItem("Fleurons", systemName: "fleuron.fill")
    static let carts = DynamicTabItem("Carts", systemName: "cart.fill")
    static let hammers = DynamicTabItem("Hammers", systemName: "hammer.fill")

    @State var selection: DynamicTabItem = home

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DynamicTabView(selection: $selection) {
                    Group {
                        DemoTab(text: "First")
                            .dynamicTabItem(DynamicTabBarApp.home)
                        DemoTab(text: "Second")
                            .dynamicTabItem(DynamicTabBarApp.messages)
                        DemoTab(text: "Third")
                            .dynamicTabItem(DynamicTabBarApp.favorites)
                        DemoTab(text: "Fourth")
                            .dynamicTabItem(DynamicTabBarApp.profile)
                        DemoTab(text: "Fifth")
                            .dynamicTabItem(DynamicTabBarApp.trash)
                    }
                    Group {
                        DemoTab(text: "Sixth")
                            .dynamicTabItem(DynamicTabBarApp.trays)
                        DemoTab(text: "Seventh")
                            .dynamicTabItem(DynamicTabBarApp.trophies)
                        DemoTab(text: "Eighth")
                            .dynamicTabItem(DynamicTabBarApp.umbrellas)
                        DemoTab(text: "Ninth")
                            .dynamicTabItem(DynamicTabBarApp.flames)
                        DemoTab(text: "Tenth")
                            .dynamicTabItem(DynamicTabBarApp.fleurons)
                    }
                    Group {
                        DemoTab(text: "Eleventh")
                            .dynamicTabItem(DynamicTabBarApp.carts)
                        DemoTab(text: "Twelfth")
                            .dynamicTabItem(DynamicTabBarApp.hammers)
                    }
                }
            }
        }
    }
}

struct DemoTab: View {

    let text: String

    init(text: String) {
        self.text = text
        print("init \(text)")
    }

    var body: some View {
        List(1..<21) { n in
            Text("\(text) \(n)")
        }
//        .navigationTitle(text)
//        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("onAppear \(text)")
        }
        .onDisappear {
            print("onDisappear \(text)")
        }
    }
}
