import SwiftUI
import SanarKit

struct ContentView: View {
    @State private var isService: Bool = false
    @State private var isBooking: Bool = false
    @State private var sanar = SKManager()
    @State private var authToken: String?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    let clientData: [String: Any] = [
        "first_name": "John",
        "last_name": "Doe",
        "dob": "1990-01-01",
        "gender": "M",
        "nationality": "Saudi Arabia",
        "document_id": "2469433220",
        "mid": "MG2",
        "document_type": 1,
        "phone_code": "91",
        "phone_no": "81794771111",
        "maritalStatus": "0"
    ]
    
    private func connectToSanar() {
        Task {
            do {
                let success = try await SKManager.connect(
                    cid: "<client-id>",
                    bundleId: "com.example.demo",
                    clientInfo: clientData
                )
                print("Sanar Integration: \(success)")
            } catch {
                print("Sanar Integration Failed: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Example App")
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .bold()
                    .font(.title)
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                HStack {
                    Button(action: {
                        connectToSanar()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Reconnect")
                            .foregroundColor(.green)
                    }
                    .padding()
                    
                    Button(action: {
                        SKManager.disconnect()
                    }) {
                        
                            Image(systemName: "power")
                            Text("Disconnect")
                                .foregroundColor(.red)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                GeometryReader { geometry in
                    let width = (geometry.size.width / 2) - 20
                    let height: CGFloat = 100  // Set a fixed height for each card
                    
                    LazyVGrid(columns: [GridItem(.fixed(width)), GridItem(.fixed(width))], spacing: 16) {
                        
                        NavigationLink(
                            destination:
                                SanarKit.ServiceView(isNavigationActive: $isService),
                            isActive: $isService
                        ) {
                            VStack {
                                Image(systemName: "cart.fill")
                                Text("Book Service")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(width: width, height: height)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        
                        NavigationLink(
                            destination: SanarKit.BookingListView(isNavigationActive: $isBooking),
                            isActive: $isBooking
                        ) {
                            VStack {
                                Image(systemName: "list.bullet")
                                Text("Appointments")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(width: width, height: height)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .frame(height: 300)
            }
            .padding()
            .onAppear() {
                connectToSanar()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
