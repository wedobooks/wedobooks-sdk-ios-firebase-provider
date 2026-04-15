//
//  FunctionsProvider.swift
//  FirebaseProvider
//
//  Created by Bo Gosmer on 14/10/2025.
//

internal import FirebaseFunctions
import Foundation
import WDBFirebaseInterfaces

public final class FunctionsProvider: FunctionsAdapterType {
    let appProvider: FirebaseAppProvider
    let functions: Functions
    
    init(appProvider: FirebaseAppProvider, region: String) {
        self.appProvider = appProvider
        self.functions = Functions.functions(app: appProvider.app, region: region)
    }
    
    public func httpsCallable(_ name: String) -> HTTPSCallableWrapper {
        let callable = functions.httpsCallable(name)
        return HTTPSCallableProvider(callable: callable)
    }
}

public final class HTTPSCallableProvider: HTTPSCallableWrapper {
    private let callable: HTTPSCallable
    
    init(callable: HTTPSCallable) {
        self.callable = callable
    }
    
    
    public func call(_ data: sending Any?, completion: @escaping @Sendable @MainActor ((any HTTPSCallableResultWrapper)?, (any CallableError)?) -> Void) {
        let completionWrapper: @MainActor (HTTPSCallableResult?, Error?) -> Void = { result, error in
            if let result {
                completion(HTTPSCallableResultProvider(result: result), nil)
            } else {
                completion(nil, CallableErrorMapper.map(error))
            }
        }
        callable.call(data, completion: completionWrapper)
    }
}

struct CallableErrorAdapter: CallableError, @unchecked Sendable {
    let code: CallableErrorCode
    let errorUserInfo: [String: Any]
}

enum CallableErrorMapper {
    static func map(_ error: Error?) -> (any CallableError)? {
        guard let error else {
            return nil
        }
        
        let nsError = error as NSError
        if nsError.domain == FunctionsErrorDomain,
           let functionsCode = FunctionsErrorCode(rawValue: nsError.code),
           let callableCode = CallableErrorCode(rawValue: functionsCode.rawValue) {
            return CallableErrorAdapter(code: callableCode, errorUserInfo: nsError.userInfo)
        }
        
        var userInfo = nsError.userInfo
        if userInfo[NSUnderlyingErrorKey] == nil {
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        return CallableErrorAdapter(code: .unknown, errorUserInfo: userInfo)
    }
}

public final class HTTPSCallableResultProvider: HTTPSCallableResultWrapper {
    public var data: Any {
        result.data
    }
    
    private let result: HTTPSCallableResult
    
    init(result: HTTPSCallableResult) {
        self.result = result
    }
}
