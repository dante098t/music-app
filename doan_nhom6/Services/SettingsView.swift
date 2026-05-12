import SwiftUI
import Auth

struct SettingsView: View {
    
    @StateObject private var authManager = AuthManager.shared
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.white.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "gearshape.2.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.purple)
                        
                        Text("Settings")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 24) {
                        
                        settingsSection(title: "Account") {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.purple)
                                VStack(alignment: .leading) {
                                    Text(authManager.currentUser?.email ?? "No Email")
                                        .foregroundColor(.white)
                                    Text("Free Plan")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        settingsSection(title: "Preferences") {
                            VStack(spacing: 1) {
                                settingRow(icon: "bell.fill", title: "Notifications", value: "On")
                                Divider().overlay(Color.white.opacity(0.1))
                                settingRow(icon: "globe", title: "Language", value: "Tiếng Việt")
                                Divider().overlay(Color.white.opacity(0.1))
                                settingRow(icon: "paintpalette.fill", title: "Theme", value: "Dark")
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        settingsSection(title: "About") {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Music App v1.0")
                                    .foregroundColor(.white)
                                Text("Made with ❤️ for iOS")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Logout Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.red)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                }
            }
        }
        // ALERT - Cú pháp mới đúng
        .alert("Đăng xuất", isPresented: $showLogoutAlert) {
            Button("Hủy", role: .cancel) {}
            Button("Đăng xuất", role: .destructive) {
                AuthManager.shared.signOut()
            }
        } message: {
            Text("Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?")
        }
    }
    
    // MARK: - Helpers
    private func settingsSection(title: String, content: @escaping () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.horizontal)
            content()
        }
    }
    
    private func settingRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.purple)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
