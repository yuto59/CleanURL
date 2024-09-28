import Testing
import Foundation
@testable import CleanURL


class SanitizerTest {
    let service = URLSanitizerService()
    @Test(
        "SanitizerTest",
        arguments:
            [
                "https://x.com/tweetsoku1/status/1839579982579867948?s=46&t=1qoxGcMhMQWil8XhdB6LsA",
                "https://www.instagram.com/reel/DALh_zYsWsP/?igsh=htOWk2cw%3D%3D",
                "https://youtube.com/shorts/1bLgwTncN-s?si=jymDjQL4iyVaRDrN"
            ]
    )
    func example(url:String) async throws {
        let originalURL:URL = .init(string: url)!
        
        let url = service.sanitizeURL(initialURL: originalURL)
        print("\(originalURL)")
        print("↓\n\(url)\n")
    }
}

