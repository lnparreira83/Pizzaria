//
//  OrderSheet.swift
//  PizzaRestaurant
//
//  Created by Lucas Parreira on 26/06/21.
//

import SwiftUI

struct OrderSheet: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode
    
    let pizzaTypes = ["Pizza Margherita","Greek Pizza", "Pizza Supreme","Pizza California","New York Pizza"]
    @State var selectedPizzaIndex = 1
    @State var numberOfSlices = 1
    @State var tableNumber = ""
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Pizza Details")){
                    Picker(selection: $selectedPizzaIndex, label: Text("Pizza Type")){
                        ForEach(0 ..< pizzaTypes.count){
                            Text(self.pizzaTypes[$0]).tag($0)
                        }
                    }
                    Stepper("\(numberOfSlices) Slices", value: $numberOfSlices, in: 1...12)
            }
                Section(header: Text("Table")){
                    TextField("Table Number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                VStack(alignment: .center){
                Button(action:{
                    guard self.tableNumber != "" else { return }
                    let newOrder = Order(context: moc)
                    newOrder.pizzaType = self.pizzaTypes[self.selectedPizzaIndex]
                    newOrder.orderStatus = .pending
                    newOrder.tableNumber = self.tableNumber
                    newOrder.numberOfSlices = Int16(self.numberOfSlices)
                    newOrder.id = UUID()
                    
                    do{
                        try moc.save()
                        print("Order saved")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }){
                        Text("Add Order")
                }
                
                Divider()
                    
                    Image("order")
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(12)
                    .frame(width:300,height:200)
                    .edgesIgnoringSafeArea(.all)
        }
            .navigationTitle("Add Order")
        }
        }
    }
}

struct OrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheet()
    }
}
