import XCTest
internal import FirebaseFunctions
@testable import FirebaseProvider

final class FirebaseProviderTests: XCTestCase {
    func testCallableErrorMapperMapsFunctionsErrorCodeOneToOneAndPreservesUserInfo() {
        let originalUserInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "Permission denied",
            "details": ["scope": "books.read"]
        ]
        let functionsError = NSError(
            domain: FunctionsErrorDomain,
            code: FunctionsErrorCode.permissionDenied.rawValue,
            userInfo: originalUserInfo
        )
        
        let mappedError = CallableErrorMapper.map(functionsError)
        
        XCTAssertEqual(mappedError?.code, .permissionDenied)
        XCTAssertEqual(mappedError?.errorUserInfo[NSLocalizedDescriptionKey] as? String, "Permission denied")
        XCTAssertEqual(
            (mappedError?.errorUserInfo["details"] as? [String: String])?["scope"],
            "books.read"
        )
    }
    
    func testCallableErrorMapperMapsNonFunctionsErrorToUnknownAndAddsUnderlyingError() {
        let nonFunctionsError = NSError(
            domain: "com.example.testing",
            code: 77,
            userInfo: [NSLocalizedDescriptionKey: "Example failure"]
        )
        
        let mappedError = CallableErrorMapper.map(nonFunctionsError)
        
        XCTAssertEqual(mappedError?.code, .unknown)
        XCTAssertEqual(mappedError?.errorUserInfo[NSLocalizedDescriptionKey] as? String, "Example failure")
        XCTAssertNotNil(mappedError?.errorUserInfo[NSUnderlyingErrorKey] as? NSError)
    }
    
    func testCallableErrorMapperPreservesExistingUnderlyingError() {
        let originalUnderlying = NSError(
            domain: "com.example.underlying",
            code: 991,
            userInfo: [NSLocalizedDescriptionKey: "Underlying"]
        )
        let nonFunctionsError = NSError(
            domain: "com.example.testing",
            code: 88,
            userInfo: [
                NSLocalizedDescriptionKey: "Example failure",
                NSUnderlyingErrorKey: originalUnderlying
            ]
        )
        
        let mappedError = CallableErrorMapper.map(nonFunctionsError)
        
        XCTAssertEqual(mappedError?.code, .unknown)
        XCTAssertTrue((mappedError?.errorUserInfo[NSUnderlyingErrorKey] as? NSError) === originalUnderlying)
    }
    
    func testCallableErrorMapperReturnsNilForNilInput() {
        XCTAssertNil(CallableErrorMapper.map(nil))
    }
}
