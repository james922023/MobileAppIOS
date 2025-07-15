//
//  LoginView.swift
//  PlanR
//
//  Created by James Yackanich on 11/24/24.
//
import SwiftUI
import FirebaseCore

struct LoginView: View {
    @Environment(AuthManager.self) var authManager // <-- Access the authManager from the environment
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("PlanR")
                    .font(.largeTitle)
                
                // Email + password fields
                VStack {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                    // Sign up + Login buttons
                    HStack {
                        
                        NavigationLink("Sign Up", destination: SignUpView())
                            .buttonStyle(.borderedProminent)
                        
                        Button("Login") {
                            print("Login user: \(email), \(password)")
                            
                            // TODO: Login user
                            authManager.signIn(email: email, password: password) // <-- Sign in user via authManager
                            
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .textFieldStyle(.roundedBorder) // <-- Style text fields (applies to both text fields within the VStack)
                .textInputAutocapitalization(.never) // <-- No auto capitalization (can be annoying for emails and passwords)
                .padding(40)
            }
        }
    }
}

struct SignUpView: View {
    @Environment(AuthManager.self) var authManager // <-- Access the authManager from the environment
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack{
            Text("Get Started Planning!")
                .font(.largeTitle)
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                HStack {
                    Button("Sign Up") {
                        print("Sign up user: \(email), \(password)")
                        
                        // TODO: Sign up user
                        authManager.signUp(email: email, password: password) // <-- Sign up user via authManager
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }.padding(40)
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager()) // <-- For the preview to work, pass an instance of AuthManager into the environment
}
