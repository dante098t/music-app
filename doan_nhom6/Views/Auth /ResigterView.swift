import SwiftUI
import Supabase

enum UserRole: String, Codable, CaseIterable {

    case user

    case premium

    case artist

    case admin

    

    var displayName: String {

        switch self {

        case .user:

            return "Free User"

        case .premium:

            return "Premium User"

        case .artist:

            return "Artist"

        case .admin:

            return "Admin"

        }

    }

}
struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    
    @State private var email = ""
    
    @State private var password = ""
    
    @State private var selectedRole: UserRole = .user
    
    @State private var errorMessage = ""
    
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                
                colors: [.black, .purple],
                
                startPoint: .topLeading,
                
                endPoint: .bottomTrailing
                
            )
            
            .ignoresSafeArea()
            
            VStack(spacing: 22) {
                
                Spacer()
                
                Text("Create Account")
                
                    .font(.largeTitle.bold())
                
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    
                    TextField("Username", text: $username)
                    
                        .textInputAutocapitalization(.never)
                    
                    TextField("Email", text: $email)
                    
                        .keyboardType(.emailAddress)
                    
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Password", text: $password)
                    
                }
                
                .padding()
                
                .background(Color.white.opacity(0.08))
                
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                .foregroundColor(.white)
                
                // ROLE PICKER
                
                Picker("Role", selection: $selectedRole) {
                    
                    ForEach(
                        
                        [
                            
                            UserRole.user,
                            
                            UserRole.premium,
                            
                            UserRole.artist
                            
                        ],
                        
                        id: \.self
                        
                    ) { role in
                        
                        Text(role.displayName)
                        
                            .tag(role)
                        
                    }
                    
                }
                
                .pickerStyle(.menu)
                
                .tint(.white)
                
                // BUTTON
                
                Button {
                    
                    Task {
                        
                        await register()
                        
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20)
                        
                            .fill(Color.white)
                        
                            .frame(height: 56)
                        
                        if isLoading {
                            
                            ProgressView()
                            
                        } else {
                            
                            Text("Create Account")
                            
                                .fontWeight(.bold)
                            
                                .foregroundColor(.black)
                            
                        }
                        
                    }
                    
                }
                
                .disabled(isLoading)
                
                if !errorMessage.isEmpty {
                    
                    Text(errorMessage)
                    
                        .foregroundColor(.red)
                    
                        .multilineTextAlignment(.center)
                    
                }
                
                Spacer()
                
            }
            
            .padding()
            
        }
        
    }
    
    // MARK: REGISTER
    
    func register() async {
        
        errorMessage = ""
        
        guard !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        
        do {
            try await AuthService.shared.register(
                email: email,
                password: password,
                username: username,
                role: selectedRole.rawValue
            )
            
            dismiss()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
