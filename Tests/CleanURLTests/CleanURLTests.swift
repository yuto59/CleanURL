import Testing
@testable import CleanURL

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let cleanURLManager = CleanURLManager()
    #expect(cleanURLManager.url != nil)
    #expect(cleanURLManager.data != nil)
}
