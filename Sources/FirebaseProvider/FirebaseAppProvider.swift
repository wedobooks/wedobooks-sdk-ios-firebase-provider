//
//  FirebaseAppProvider.swift
//  FirebaseProvider
//
//  Created by Bo Gosmer on 14/10/2025.
//

internal import Firebase
internal import FirebaseAuth
import Foundation
import WDBFirebaseInterfaces

public final class FirebaseAppProvider: FirebaseAppWrapper {
    public var projectId: String? {
        app.options.projectID
    }
    
    let app: FirebaseApp
    
    init(app: FirebaseApp) {
        self.app = app
    }
}
