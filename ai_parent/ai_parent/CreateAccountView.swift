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
    let pastelGreen = Color(red: 88 / 255, green: 204 / 255, blue: 2 / 255)
    let secondaryColor = Color(red: 28 / 255, green: 176 / 255, blue: 246 / 255) // Define the secondary color as blue.
    let backgroundColor = Color.white // Define the background color as white.

    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .background(
                    Image("background") // Your background image
                        .resizable()
                        .scaledToFill() // Fill the screen while maintaining aspect ratio
                        .edgesIgnoringSafeArea(.all) // Allow the image to extend to the edges of the screen
                )
            VStack {
                Image("coe")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 180)
                    .padding()
                Spacer()
            }
            VStack(spacing: 20) {
                Spacer()
                title
                VStack {
                    nameInput
                    ageInput
                }
                .padding()

                .background(RoundedRectangle(cornerRadius: 20).fill(backgroundColor).shadow(radius: 3.5)).opacity(0.8)
                createAccountButton
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $isAccountCreated) {
                GuidanceHomeView() // Assuming this view is defined elsewhere.
            }
        }
    }

    var title: some View {
        Text("Create Account")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding(.bottom, 20)
    }

    var nameInput: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(secondaryColor)
                .padding(.leading)
            TextField("Name", text: $name)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.7)))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(secondaryColor, lineWidth: 1)
        )
        .padding(.horizontal)
        .scaleEffect(name.isEmpty ? 1 : 1.1)
        .animation(.easeInOut(duration: 0.2))
    }

    var ageInput: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(secondaryColor)
                .padding(.leading)
            TextField("Age", text: $age)
                .keyboardType(.numberPad)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.7)))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(secondaryColor, lineWidth: 1)
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
