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
    
    public func call(_ data: Any?, completion: @escaping (HTTPSCallableResultWrapper?, Error?) -> Void) {
        let completionWrapper: (HTTPSCallableResult?, Error?) -> Void = { result, error in
            if let result {
                completion(HTTPSCallableResultProvider(result: result), nil)
            } else {
                completion(nil, error)
            }
        }
        callable.call(data, completion: completionWrapper)
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
