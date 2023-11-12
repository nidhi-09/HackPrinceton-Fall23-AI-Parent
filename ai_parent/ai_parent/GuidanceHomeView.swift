//
//  GuidanceHomeView.swift
//  ai_parent
//
//  Created by Adolfo Calderon on 11/10/23.
//

import SwiftUI

struct GuidanceHomeView: View {
    @State private var isAnimating = false // State for animation toggle
    @State private var shakes = 0 // State to control the number of shakes
    @State private var scale: CGFloat = 1.0
    
    @State private var showTutorial = true


    @StateObject private var viewModel = GuidanceViewModel()
    
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
                title
                apiResponse
                prompt
                promptButton
            }
            if showTutorial {
                    TutorialPopUpView(showTutorial: $showTutorial)
                }
        }
    }
    
    struct TutorialPopUpView: View {
        @Binding var showTutorial: Bool
        let pastelGreen = Color(red: 88 / 255, green: 204 / 255, blue: 2 / 255)
        let polar = Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255)
        let secondaryColor = Color(red: 28 / 255, green: 176 / 255, blue: 246 / 255) // Define the secondary color as blue.
        
        

        var body: some View {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showTutorial = false
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 12) {
                        Text("Welcome to Coe!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 10)

                        TutorialStepView(iconName: "message.fill", text: "Chat and share your thoughts.")
                        TutorialStepView(iconName: "hand.raised.fill", text: "Find support and guidance.")
                        TutorialStepView(iconName: "star.fill", text: "Celebrate your achievements!")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color(red: 67 / 255, green: 192 / 255, blue: 246 / 255) // Define the secondary color as blue.
, lineWidth: 4)
                    )
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(
                polar.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showTutorial = false
                        }
                    }
            )
            .transition(.scale)
        }
    }

    struct TutorialStepView: View {
        var iconName: String
        var text: String

        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color(red: 28 / 255, green: 176 / 255, blue: 246 / 255) // Define the secondary color as blue.
)
                    .font(.title3)
                    .frame(width: 30)
                Text(text)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .font(.body)
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    var title: some View {
        Group {
            Spacer()
            Spacer()
            Spacer()
            VStack {
                Text("Coe")
                    .font(.system(size: 70))// Large and easy to read
                    .fontWeight(.bold) // Make it bold
                    .foregroundColor(Color.green.opacity(0.65)) // Warm color for the text
                    .padding(.bottom, 5) // Space from the bottom
                
                Text("Co-Parent AI")
                    .font(.title3)
                    .italic()
                    .bold()
            }
            Spacer()
        }
    }
    
    var prompt: some View {
        TextField("Ask me anything...", text: $viewModel.userInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding() // Padding around the TextField
            .font(Font.system(size: 18, design: .rounded)) // Rounded, easy-on-the-eyes font
            .foregroundColor(Color.brown) // Warm color for the input text
            .background(Color.white) // White background for the TextField
            .cornerRadius(10) // Rounded corners for the TextField background
            .padding(.horizontal, 20) // Horizontal padding for the TextField
    }
    
    var promptButton: some View {
            Button(action: {
                // Animate the button to squeeze down
                withAnimation(.easeOut(duration: 0.1)) {
                    scale = 0.75
                }
                // After a short delay, animate it to expand out
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 1.4
                    }
                }
                // Finally, bring it back to the original size
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring()) {
                        scale = 1.0
                    }
                }
                viewModel.submitPrompt()
                viewModel.userInput = ""
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.green.opacity(0.65))
                    .scaleEffect(scale)
            }
            .padding(.bottom, 20)
        }
    
    
    var apiResponse: some View {
        Group {
            Spacer()
            if viewModel.isWaitingForResponse {
                showLoadingIcon
            } else {
                showResponse
            }
            Spacer()
        }
    }
    
    var showLoadingIcon: some View {
        // Show a progress view while waiting for the server response.
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .green))
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: 600) // Fixed height, maximum width
            .background(Color.white.opacity(0.1)) // Slightly opaque background to indicate area
            .overlay(
                RoundedRectangle(cornerRadius: 10) // Rounded corners for the overlay border
                    .stroke(Color.green.opacity(0.05), lineWidth: 1) // Green border
            )
            .cornerRadius(10) // Rounded corners for the ScrollView
            .padding(.horizontal, 20) // Horizontal padding to match the prompt's padding
            .frame(maxWidth: .infinity, maxHeight: 600) // Fixed height, maximum width
            // Add a semi-transparent white background with a shadow to create the "bubble" effect
            .background(
                RoundedRectangle(cornerRadius: 10) // Rounded corners for the bubble background
                    .fill(Color.white.opacity(0.7)) // Semi-transparent white background
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2) // Soft shadow for depth
            )
            .cornerRadius(10) // Rounded corners for the ScrollView
            .padding(.horizontal, 20) // Horizontal padding to match the prompt's padding
    }
    
    var showResponse: some View {
        ScrollView {
            Text(viewModel.displayedText)
                .padding()
                .transition(.opacity) // Fade in/out the text as it appears/disappears
        }
        .frame(maxWidth: .infinity, maxHeight: 600) // Fixed height, maximum width
        // Add a semi-transparent white background with a shadow to create the "bubble" effect
        .background(
            RoundedRectangle(cornerRadius: 10) // Rounded corners for the bubble background
                .fill(Color.white.opacity(0.7)) // Semi-transparent white background
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2) // Soft shadow for depth
        )
        .cornerRadius(10) // Rounded corners for the ScrollView
        .padding(.horizontal, 20) // Horizontal padding to match the prompt's padding
    }

}

#Preview {
    GuidanceHomeView()
}
