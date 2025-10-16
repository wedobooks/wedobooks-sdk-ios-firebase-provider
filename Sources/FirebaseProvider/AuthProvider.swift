//
//  AuthProvider.swift
//  FirebaseProvider
//
//  Created by Bo Gosmer on 14/10/2025.
//

internal import Firebase
internal import FirebaseAuth
import Foundation
import WDBFirebaseInterfaces

public final class FirebaseUser: AuthUserWrapper {
    public var uid: String {
        user.uid
    }
    
    public var displayName: String? {
        user.displayName
    }
    
    public var photoURL: URL? {
        user.photoURL
    }
    
    public var email: String? {
        user.email
    }
    
    public var isEmailVerified: Bool {
        user.isEmailVerified
    }
    
    public var isAnonymous: Bool {
        user.isAnonymous
    }
    
    public var metadata: AuthUserMetadataWrapper {
        FirebaseUserMetadata(metadata: user.metadata)
    }
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    public func getIDToken(_ completion: @escaping (String?, Error?) -> Void) {
        user.getIDToken(completion: completion)
    }
}

public final class FirebaseUserMetadata: AuthUserMetadataWrapper {
    public var lastSignInDate: Date? {
        metadata.lastSignInDate
    }
    
    public var creationDate: Date? {
        metadata.creationDate
    }
    
    private let metadata: UserMetadata
    
    init(metadata: UserMetadata) {
        self.metadata = metadata
    }
}

public enum AuthProviderError: Error {
    case unknownSignInError
}

public final class AuthProvider: AuthAdapterType {
    public var currentUser: AuthUserWrapper? {
        if let user = auth.currentUser {
            return FirebaseUser(user: user)
        }
        return nil
    }
    
    let appProvider: FirebaseAppProvider
    
    private var auth: Auth {
        Auth.auth(app: appProvider.app)
    }
    
    init(appProvider: FirebaseAppProvider) {
        self.appProvider = appProvider
    }
    
    public func addStateDidChangeListener(_ listener: @escaping (Any, AuthUserWrapper?) -> Void) -> NSObjectProtocol {
        let listenerWrapper: (Auth, User?) -> Void = { auth, user in
            guard let user else {
                listener(auth, nil)
                return
            }
            listener(auth, FirebaseUser(user: user))
        }
        return auth.addStateDidChangeListener(listenerWrapper)
    }
    
    public func removeStateDidChangeListener(_ listener: NSObjectProtocol) {
        auth.removeStateDidChangeListener(listener)
    }
    
    public func signIn(withEmail: String, password: String, completion: @escaping (Result<AuthUserWrapper, Error>) -> Void) {
        let completionWrapper: ((AuthDataResult?, Error?) -> Void) = { authResult, error in
            let result: Result<AuthUserWrapper, any Error>
            if let authResult {
                result = .success(FirebaseUser(user: authResult.user))
            } else if let error {
                result = .failure(error)
            } else {
                result = .failure(AuthProviderError.unknownSignInError)
            }
            completion(result)
        }
        auth.signIn(withEmail: withEmail, password: password, completion: completionWrapper)
    }
    
    public func signIn(withCustomToken: String, completion: @escaping (Result<AuthUserWrapper, Error>) -> Void) {
        let completionWrapper: ((AuthDataResult?, Error?) -> Void) = { authResult, error in
            let result: Result<AuthUserWrapper, any Error>
            if let authResult {
                result = .success(FirebaseUser(user: authResult.user))
            } else if let error {
                result = .failure(error)
            } else {
                result = .failure(AuthProviderError.unknownSignInError)
            }
            completion(result)
        }
        auth.signIn(withCustomToken: withCustomToken, completion: completionWrapper)
    }
    
    public func signOut() throws {
        try auth.signOut()
    }
}
