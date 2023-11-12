//
//  ChatViewModel.swift
//  ai_parent
//
//  Created by Adolfo Calderon on 11/11/23.
//v

import SwiftUI

class ChatViewModel: ObservableObject {
    
    // The view will bind to this property to display the response
    @Published var responseText: String = ""
    // array of chatResponses
    
    
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
                return
            }
            
            // Decode the JSON data
            if let data = data {
                do {
                    let chatResponse = try JSONDecoder().decode(String.self, from: data)
                    DispatchQueue.main.async {
                        // Update the published property with the response
                        self?.responseText = chatResponse
                    }
                } catch {
                    // Handle decoding error
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}
