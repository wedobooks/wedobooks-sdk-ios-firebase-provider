//
//  FirebaseProvider.swift
//  FirebaseProvider
//
//  Created by Bo Gosmer on 13/10/2025.
//

internal import Firebase
import Foundation
import WDBFirebaseInterfaces

public final class FirebaseProvider: FirebaseAdapterType {
    public let appWrapper: FirebaseAppWrapper
    public let authAdapter: AuthAdapterType
    public let firestoreHelpers: FirestoreHelpersType = FirestoreHelpers()
    public let firestoreAdapter: FirestoreAdapterType
    public let functionsAdapter: FunctionsAdapterType
    
    public init(appWrapper: FirebaseAppProvider, functionsRegion: String) {
        self.appWrapper = appWrapper
        self.authAdapter = AuthProvider(appProvider: appWrapper)
        self.firestoreAdapter = FirestoreProvider(appProvider: appWrapper)
        self.functionsAdapter = FunctionsProvider(appProvider: appWrapper, region: functionsRegion)
    }
}

@objc(WDBFirebaseAdapterFactory)
public final class FirebaseAdapterFactory: NSObject, FirebaseAdapterFactoryType {
    public func configure(appName: String, filePath: String, functionsRegion: String) -> FirebaseAdapterType {
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(name: appName, options: options!)
        let app = FirebaseApp.app(name: appName)!
        let firestoreSettings = FirestoreSettings()
        firestoreSettings.cacheSettings = PersistentCacheSettings()
        Firestore.firestore(app: app).settings = firestoreSettings
        let appProvider = FirebaseAppProvider(app: app)
        return FirebaseProvider(appWrapper: appProvider, functionsRegion: functionsRegion)
    }

    public func configure(functionsRegion: String) -> FirebaseAdapterType {
        FirebaseApp.configure()
        let app = FirebaseApp.app()!
        let firestoreSettings = FirestoreSettings()
        firestoreSettings.cacheSettings = PersistentCacheSettings()
        Firestore.firestore(app: app).settings = firestoreSettings
        let appProvider = FirebaseAppProvider(app: app)
        return FirebaseProvider(appWrapper: appProvider, functionsRegion: functionsRegion)
    }
}
