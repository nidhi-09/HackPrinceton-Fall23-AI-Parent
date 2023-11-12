//
//  GuidanceViewModel.swift
//  ai_parent
//
//  Created by Adolfo Calderon on 11/10/23.
//

import Combine
import SwiftUI


class GuidanceViewModel: ObservableObject {
    @Published var displayedText = ""
    @Published var isTyping = false
    @Published var isWaitingForResponse = false
    @Published var userInput: String = ""
    @Published var responseText: String = ""
    // array of chatResponses


    private var model = GuidanceModel()
    private var fullResponse: String = ""
    private var typingTimer: Timer?
    private var currentIndex = 0
    
// When the user submits a prompt, we start waiting for the response.
    func submitPrompt() {
        self.isWaitingForResponse = true
        model.prompt = userInput
        
        // Call the model to submit the prompt.
        fetchResponse(prompt: userInput)
    }
    
    // Prepare for typing effect by setting up initial state.
    private func prepareTypingEffect(with response: String) {
        fullResponse = response
        currentIndex = 0
//        displayedText = ""
        isTyping = true
        startTypingEffect()
    }
    
    // Start the timer that simulates typing effect.
    private func startTypingEffect() {
        typingTimer?.invalidate()
        self.isWaitingForResponse = false
        self.displayedText += "\n" + "\n"
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            DispatchQueue.main.async {
                self?.typeNextCharacter()
            }
        }
    }
    
    // Append the next character of the response to the displayed text.
    private func typeNextCharacter() {
        if currentIndex < fullResponse.count {
            let index = fullResponse.index(fullResponse.startIndex, offsetBy: currentIndex)
            displayedText.append(fullResponse[index])
            currentIndex += 1
        } else {
            // Once the end is reached, stop typing and invalidate the timer.
            isTyping = false
            typingTimer?.invalidate()
        }
    }
    
    
// Fetch Response for local API
    func fetchResponse(prompt: String) {
        // Construct the URL and request
        guard let url = URL(string: "http://localhost:9988/chat") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert your prompt into JSON
        let body: [String: Any] = ["prompt": prompt]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                // Handle the error scenario (e.g., network error)
                print("Network error: \(error.localizedDescription)")
                self?.responseText = "Error"
                return
            }
            
            // Decode the JSON data
            if let data = data, let rawJSON = String(data: data, encoding: .utf8) {
                    print("Received raw data: \(rawJSON)")
                    DispatchQueue.main.async {
                        self?.prepareTypingEffect(with: rawJSON)// Temporarily display the raw JSON in the UI for debugging
                    }
                
                }
        }
        
        task.resume()
    }
    
    // Invalidate the timer when the ViewModel deinitializes.
    deinit {
        typingTimer?.invalidate()
    }
}
