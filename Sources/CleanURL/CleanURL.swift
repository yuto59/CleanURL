// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

///以下のロジックを参考にしている
///
///https://github.com/brave/brave-core/blob/c4efb412d81f738217f4fefeaa0378193444da35/components/url_sanitizer/browser/url_sanitizer_service.cc
///
///
open class URLSanitizerService {
    public init() {
        if let url = Bundle.module.url(forResource: "BraveCleanURLs", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                self.matchers = jsonObject as? [[String: Any]]
                // Use jsonObject here
            } catch {
                print("Error reading JSON: \(error)")
            }
        }
    }
    
    var matchers:[ [String: Any]]?
    
    public func sanitizeURL(initialURL: URL) -> URL {
        guard let matchers = matchers, !matchers.isEmpty,
              (initialURL.scheme == "http" || initialURL.scheme == "https") else {
            return initialURL
        }
        
        var url = initialURL
        for matcher in matchers {
            guard
                let includePattern = matcher["include"] as? [String],
                let excludePattern = matcher["exclude"] as? [String],
                let params = matcher["params"] as? [String],
                matchURL(patterns: includePattern, url: url),
                !matchURL(patterns: excludePattern, url: url)
            else {
                continue
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.query = stripQueryParameter(url: url, params: params)
            if let newURL = components?.url {
                url = newURL
            }
        }
        
        return url
    }
    
    private func matchURL(patterns: [String], url: URL) -> Bool {
        // Placeholder implementation for URL matching logic
        let urlString = url.absoluteString
        for pattern in patterns {
            let subPatterns = pattern.split(separator: "*")
            var notAllMatched = false
            
            for subPattern in subPatterns {
                var subPatternText = subPattern
                // Check if the text starts with a dot and remove it
                if subPatternText.hasPrefix(".") {
                    subPatternText.removeFirst()
                }
                if !urlString.contains(subPatternText) {
                    notAllMatched = true
                }
                
            }
            
            if !notAllMatched {
                return true
            }
        }
        return false
    }
    
    private func stripQueryParameter(url: URL, params: [String]) -> String? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              var queryItems = components.queryItems else {
            return nil
        }
        
        queryItems.removeAll { item in params.contains(item.name) }
        
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.percentEncodedQuery
    }
}
