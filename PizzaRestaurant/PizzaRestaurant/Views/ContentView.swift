//
//  ContentView.swift
//  PizzaRestaurant
//
//  Created by Lucas Parreira on 26/06/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Order.entity(), sortDescriptors: [], predicate: NSPredicate(format: "status != %@",Status.completed.rawValue))
    var orders: FetchedResults<Order>
    @State var showOrderSheet = false
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                ZStack{
                    Image("menu")
                        .resizable()
                        .scaledToFill()
                        .frame(width:400,height:150)
                        .edgesIgnoringSafeArea(.all)
                    Text("My Orders").foregroundColor(.white).font(.system(size: 42))
                        .padding(.top,-175)
                        .padding(.leading,-175)
                }
                
            List{
                ForEach(orders){ order in
                    HStack{
                        VStack(alignment: .leading){
                            Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action:{
                            updateOrder(order: order)
                        }){
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                            
                        }
                    }
                    .frame(height: 50)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        moc.delete(orders[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button(action:{
                showOrderSheet = true
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showOrderSheet) {
                OrderSheet()
            }
            }
        }
    }
    
    func updateOrder(order: Order){
        let newStatus = order.orderStatus == .pending ? Status.preparing : .completed
        moc.performAndWait {
            order.orderStatus = newStatus
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
