//
//  PizzaRestaurantApp.swift
//  PizzaRestaurant
//
//  Created by Lucas Parreira on 26/06/21.
//

import SwiftUI

@main
struct PizzaRestaurantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
