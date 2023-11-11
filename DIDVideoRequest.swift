import Foundation

let headers = [
    "accept": "application/json",
    "content-type": "application/json",
    "authorization": "a2lsbGFzaG90MDA3QGdtYWlsLmNvbQ:Sw0OeFJloojCJDJ54YiZy"  // Replace with your D-ID API key
]

let parameters = [
    "script": [
        "type": "text",
        "subtitles": "false",
        "provider": [
            "type": "microsoft",
            "voice_id": "en-US-JennyNeural"
        ],
        "ssml": "false"
    ],
    "config": [
        "fluent": "false",
        "pad_audio": "0.0"
    ],
    "source_url": "/workspaces/HackPrinceton-Fall23-AI-Parent/images/avatar.jpg",  // Replace with the URL of your image
    "result_url": "/workspaces/HackPrinceton-Fall23-AI-Parent/videoUrls",  // Replace with the URL where you want to store the result
    "webhook": "https://host.domain.tld/to/webhook"
] as [String: Any]

do {
    let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

    guard let url = URL(string: "https://api.d-id.com/talks") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request) { (data, response, error) in
    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }

    guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid HTTP Response")
        return
    }

    print("HTTP Status Code: \(httpResponse.statusCode)")

    if let data = data {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
            print("Response: \(jsonResponse)")

            // Process the jsonResponse here, handle success or error states
            if let jsonDictionary = jsonResponse as? [String: Any] {
                // Extract relevant information from the JSON response
                if let videoURL = jsonDictionary["video_url"] as? String {
                    print("Video URL: \(videoURL)")

                    // Use the videoURL as needed
                    // Example: Display the video in your app
                } else {
                    print("Video URL not found in the response.")
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
}

dataTask.resume()

} catch {
    print("Error serializing JSON: \(error.localizedDescription)")
}


//Storing Video

// Assuming your result directory is 'results' within your app's documents directory
let fileManager = FileManager.default
let documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let resultsDirectory = documentsDirectory.appendingPathComponent("generated_videos")

// Ensure the 'results' directory exists
if !fileManager.fileExists(atPath: resultsDirectory.path) {
    try! fileManager.createDirectory(at: resultsDirectory, withIntermediateDirectories: true, attributes: nil)
}

// Generate a unique filename (you might use a UUID or timestamp)
let filename = "result_video.mp4"
let fileURL = resultsDirectory.appendingPathComponent(filename)

// Save or move your generated video to the 'results' directory
// For example, you might move a video from a temporary location to the results directory
try! fileManager.moveItem(at: /workspaces/HackPrinceton-Fall23-AI-Parent/videoUrls, to: fileURL)

// The fileURL can be used to reference the stored video
