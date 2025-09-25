//
//  ContentView.swift
//  Order Up App!
//
//  Created by McKenzie, Cameron - Student on 9/22/25.
//
import SwiftUI
struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
}

// how the cart works

class Cart: ObservableObject {
    @Published var items: [MenuItem: Int] = [:]
    
    var totalItems: Int { items.values.reduce(0, +) }
    
    func add(_ item: MenuItem) { items[item, default: 0] += 1 }
    func remove(_ item: MenuItem) {
        if let count = items[item], count > 1 { items[item] = count - 1 }
        else { items[item] = nil }
    }
    
    func subtotal() -> Double { items.reduce(0) { $0 + $1.key.price * Double($1.value) } }
}

// this is menu on screen

let sampleMenu: [MenuItem] = [
    MenuItem(name: "Teriyaki Bowl", price: 9.99, imageName: "teriyaki_bowl"),
    MenuItem(name: "Steak Bowl", price: 10.49, imageName: "steak_bowl"),
    MenuItem(name: "Orange Chicken", price: 9.49, imageName: "orange_chicken"),
    MenuItem(name: "Spring Rolls", price: 4.49, imageName: "spring_rolls"),
    MenuItem(name: "Edamame", price: 3.99, imageName: "edamame")
]

// this is viewing the menu


struct MenuView: View {
    @StateObject var cart = Cart()
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            VStack {
                
//restraunt title at top
                
                HStack {
                    Image("bowl") //use bowl logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    Text("Simply Bowls")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.cyan)
                    Spacer()
                }
                .padding()
                
                
//menu list
                List {
                    ForEach(sampleMenu) { item in
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(String(format: "$%.2f", item.price)).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(cart.items[item] ?? 0)")
                            Stepper(value: Binding(
                                get: { cart.items[item, default: 0] },
                                set: { newValue in
                                    if newValue > (cart.items[item] ?? 0) { cart.add(item) }
                                    else { cart.remove(item) }
                                }
                            ), in: 0...10) {
                                Text("\(cart.items[item, default: 0])").frame(width: 20)
                            }
                            .labelsHidden()
                        }
                    }
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: { showingCheckout = true }) {
                HStack {
                    Image(systemName: "cart")
                    if cart.totalItems > 0 {
                        Text("\(cart.totalItems)")
                            .font(.caption)
                            .bold()
                            .padding(6)
                            .background(Circle().fill(Color.green))
                            .foregroundColor(.white)
                    }
                }
            }
            )
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
                    .environmentObject(cart)
                    .frame(minWidth: 300, minHeight: 600)
            }
        }
    }
}
