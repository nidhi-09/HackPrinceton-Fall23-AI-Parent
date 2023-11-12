//
//  CreateAccountView.swift
//  ai_parent
//
//  Created by Adolfo Calderon on 11/12/23.
//

import SwiftUI


struct CreateAccountView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var isAccountCreated: Bool = false
    let pastelGreen = Color(#colorLiteral(red: 0.678, green: 1.0, blue: 0.784, alpha: 1))
    
    var body: some View {
        ZStack {
            pastelGreen.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Spacer()
                title
                VStack {
                    nameInput
                    ageInput
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 10))
                createAccountButton
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $isAccountCreated) {
                GuidanceHomeView()
            }
        }
    }

    var title: some View {
        Text("Create Account")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.bottom, 20)
    }

    var nameInput: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(pastelGreen)
                .padding(.leading)
            TextField("Name", text: $name)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.7)))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(pastelGreen, lineWidth: 1)
        )
        .padding(.horizontal)
        .scaleEffect(name.isEmpty ? 1 : 1.1)
        .animation(.easeInOut(duration: 0.2))
    }

    var ageInput: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(pastelGreen)
                .padding(.leading)
            TextField("Age", text: $age)
                .keyboardType(.numberPad)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.7)))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(pastelGreen, lineWidth: 1)
        )
        .padding(.horizontal)
        .scaleEffect(age.isEmpty ? 1 : 1.1)
        .animation(.easeInOut(duration: 0.2))
    }

    var createAccountButton: some View {
        Button(action: createAccount) {
            Text("Create Account")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(pastelGreen)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
        }
        .disabled(name.isEmpty || age.isEmpty)
        .scaleEffect(isButtonEnabled ? 1.1 : 1.0)
        .opacity(isButtonEnabled ? 1 : 0.6)
        .animation(.easeInOut(duration: 0.2))
    }

    private var isButtonEnabled: Bool {
        !name.isEmpty && !age.isEmpty
    }

    private func createAccount() {
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.set(age, forKey: "UserAge")
        withAnimation {
            isAccountCreated = true
        }
    }
}

#Preview {
    CreateAccountView()
}
