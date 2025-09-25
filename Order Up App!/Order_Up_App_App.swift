//
//  Order_Up_App_App.swift
//  Order Up App!
//
//  Created by McKenzie, Cameron - Student on 9/22/25.
//

import SwiftUI

@main
struct SimplyBowlsApp: App {
    @StateObject private var cart = Cart()
    
    var body: some Scene {
        WindowGroup {
            MenuView()   
                .environmentObject(cart)
        }
    }
}
