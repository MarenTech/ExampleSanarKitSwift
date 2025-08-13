import SwiftUI
import SanarKit

struct ContentView: View {
    @State private var isSKDashboard: Bool = false
    @State private var isService: Bool = false
    @State private var isBooking: Bool = false
    @State private var isInstantService: Bool = false
    @State private var isConsultation: Bool = false
    @State private var sanar = SKManager()
    @State private var authToken: String?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    let clientData: [String: Any] = [
        "first_name": "Aziz",
        "last_name": "Abdul",
        "dob": "1990-01-01",
        "gender": "M",
        "nationality": "Saudi Arabia",
        "document_id": "12345678",
        "document_type": 1,
        "mid": "BC1",
        "phone_code": "91",
        "phone_no": "7097951801",
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
        NavigationStack {
            ZStack {
                // Gradient Background with Cyan branding
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.cyan.opacity(0.1),
                        Color.cyan.opacity(0.05),
                        Color.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Section
                        VStack(spacing: 16) {
                            // App Title
                            VStack(spacing: 8) {
                                Image(systemName: "heart.text.square.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.cyan, .cyan.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("SanarKit Demo")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.cyan, .cyan.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Healthcare Services Platform")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 20)
                            
                            // Connection Status Card
                            VStack(spacing: 12) {
                                
                                HStack(spacing: 16) {
                                    Button(action: {
                                        connectToSanar()
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "arrow.clockwise")
                                                .font(.system(size: 14, weight: .semibold))
                                            Text("Connect")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(
                                                colors: [.cyan, .cyan.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        SKManager.disconnect()
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "power")
                                                .font(.system(size: 14, weight: .semibold))
                                            Text("Disconnect")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(
                                                colors: [.red, .red.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                        }
                        
                        // Dashboard Overview Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Dashboard View")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            ServiceCard(
                                icon: "square.grid.2x2.fill",
                                title: "Sanar Services",
                                subtitle: "View all services overview",
                                action: { isSKDashboard = true }
                            )
                        }
                        
                        // Services Grid
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Sanar Modules")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                
                                // Instant Service Card
                                ServiceCard(
                                    icon: "bolt.fill",
                                    title: "Instant Service",
                                    subtitle: "Quick consultations",
                                    action: { isInstantService = true }
                                )
                                
                                // Appointments Card
                                ServiceCard(
                                    icon: "calendar.badge.clock",
                                    title: "Appointments",
                                    subtitle: "Manage your bookings",
                                    action: { isBooking = true }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $isSKDashboard) {
                SanarKit.DashboardView(isNavigationActive: $isSKDashboard)
            }
            .navigationDestination(isPresented: $isService) {
                SanarKit.ServiceView(isNavigationActive: $isService)
            }
            .navigationDestination(isPresented: $isInstantService) {
                SanarKit.InstantConsultationView(isNavigationActive: $isInstantService)
            }
            .navigationDestination(isPresented: $isBooking) {
                SanarKit.BookingListView(isNavigationActive: $isBooking)
            }
            .navigationDestination(isPresented: $isConsultation) {
                SanarKit.ConsultationView(
                    isNavigationActive: $isConsultation,
                    consultationData: [ "dId": "doctor_id", "aId": "appointment_id"]
                )
            }
            .onAppear() {
                connectToSanar()
            }
        }
    }
}

// Custom Service Card Component with consistent height
struct ServiceCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Spacer()
                
                // Icon Container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .cyan.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: .cyan.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Text Content
                VStack(spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.cyan, .cyan.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
