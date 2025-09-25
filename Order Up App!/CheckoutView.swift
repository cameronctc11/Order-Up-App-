//
//  CheckoutView.swift
//  Order Up App!
//
//  Created by McKenzie, Cameron - Student on 9/22/25.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cart: Cart
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var phone = ""
    @State private var delivery = false
    @State private var address = ""
    
    let tipOptions = [0, 10, 15, 20, 25]
    @State private var selectedTip = 0
    
    let paymentOptions = ["Apple Pay", "Pay at Store"]
    @State private var paymentMethod = "Pay at Store"
    
    @State private var showAlert = false
    
    let taxRate = 0.0805
    let deliveryRate = 0.10
    
    var tipAmount: Double {
        let base = cart.subtotal() + cart.subtotal() * taxRate + (delivery ? cart.subtotal() * deliveryRate : 0)
        return base * Double(selectedTip)/100
    }
    
    var totalPrice: Double {
        cart.subtotal() + cart.subtotal() * taxRate + (delivery ? cart.subtotal() * deliveryRate : 0) + tipAmount
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Checkout")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.cyan)
                    
//items in the cart
                    if cart.items.isEmpty {
                        Text("Your cart is empty")
                            .italic()
                            .foregroundColor(.gray)
                    } else {
                        ForEach(cart.items.keys.sorted { $0.name < $1.name }, id: \.self) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("x\(cart.items[item]!)")
                            }
                        }
                    }
                    
                    Divider()
                    
//where users put info

                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Phone Number", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
//delivery option
                    Toggle("Delivery (+10%)", isOn: $delivery)
                    if delivery {
                        TextField("Delivery Address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
//buttons to click custom tips
                    Picker("Tip", selection: $selectedTip) {
                        ForEach(tipOptions, id: \.self) { Text("\($0)%") }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    
                    
//to pick payment method
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(paymentOptions, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    
//credit card pictures
                    
                    HStack(spacing: 15) {
                        Image("applepay").resizable().scaledToFit().frame(width: 50, height: 30)
                        Image("mastercard").resizable().scaledToFit().frame(width: 50, height: 30)
                        Image("amex").resizable().scaledToFit().frame(width: 50, height: 30)
                        Image("visa").resizable().scaledToFit().frame(width: 50, height: 30)
                        Image("discover").resizable().scaledToFit().frame(width: 50, height: 30)
                        Image("paypal").resizable().scaledToFit().frame(width: 50, height: 30)
                        
                        Spacer()
                    }.padding(.vertical, 10)
                    
                    Divider()
                    
//order totals- taxing, payment, etc.
                    VStack(alignment: .leading) {
                        Text("Order Summary").font(.headline)
                        Text(String(format: "Subtotal: $%.2f", cart.subtotal()))
                        Text(String(format: "Tax (8.05%%): $%.2f", cart.subtotal() * taxRate))
                        if delivery { Text(String(format: "Delivery Fee (10%): $%.2f", cart.subtotal() * deliveryRate)) }
                        Text(String(format: "Tip (%d%%): $%.2f", selectedTip, tipAmount))
                        Text(String(format: "Total: $%.2f", totalPrice)).bold()
                        Text("Payment: \(paymentMethod)")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    let nameAndPhoneValid = !(name.isEmpty || phone.isEmpty)
                    let allValid = nameAndPhoneValid && delivery && !address.isEmpty
                    let validCheck = delivery ? allValid : nameAndPhoneValid
                    // Place Order Button
                    Button(action: {
                        cart.items.removeAll()
                        showAlert = true
                    }) {
                        Text("Place Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(!validCheck ? Color.gray : Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 5)
                    .disabled(name.isEmpty || phone.isEmpty)
                    .alert("Thank you! Your order has been placed.", isPresented: $showAlert) {
                        Button("OK") { dismiss() }
                    }
                    
                }.padding()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
