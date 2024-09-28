// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

open class CleanURLManager {
    public init() {
        jsonData = [
            "include": [
                "*://*/*"
            ],
            "exclude": [
                "*://app.hive.co/*"
            ],
            "params": [
                "h_sid",
                "h_slt"
            ]
        ]
        
        includePatterns = jsonData["include"] as? [String] ?? []
        excludePatterns = jsonData["exclude"] as? [String] ?? []
        paramsToRemove = jsonData["params"] as? [String] ?? []
        
        if let url = Bundle.main.url(forResource: "Brave_Clean_URLs", withExtension: "json") {
            self.url = url
            do {
                let data = try Data(contentsOf: url)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                self.data = jsonObject
                print(jsonObject)
                // Use jsonObject here
            } catch {
                print("Error reading JSON: \(error)")
            }
        }
    }
    // JSON data with configurations
    var url:URL?
    let jsonData: [String: Any]
    var data:Any?
    
    // Extract configurations
    let includePatterns:[String]
    let excludePatterns:[String]
    let paramsToRemove:[String]
    
    // Function to check if a URL should be excluded
    private func shouldExclude(url: String) -> Bool {
        for pattern in excludePatterns {
            if url.contains(pattern.replacingOccurrences(of: "*", with: "")) {
                return true
            }
        }
        return false
    }

    // Function to clean the URL
    public func cleanURL(from urlString: String) -> String? {
        // Check if the URL should be excluded
        if shouldExclude(url: urlString) {
            return urlString // Return original if matched to exclude
        }
        
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        if let queryItems = urlComponents.queryItems {
            // Filter out the parameters specified in the JSON
            urlComponents.queryItems = queryItems.filter { !paramsToRemove.contains($0.name) }
        }
        
        return urlComponents.url?.absoluteString
    }
}
