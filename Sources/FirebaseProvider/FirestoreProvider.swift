//
//  FirestoreProvider.swift
//  FirebaseProvider
//
//  Created by Bo Gosmer on 14/10/2025.
//

internal import FirebaseFirestore
import Foundation
import WDBFirebaseInterfaces

public final class FirestoreHelpers: FirestoreHelpersType {
    public func dateFromTimestamp(_ timestamp: Any?) -> Date? {
        guard let t = timestamp as? Timestamp else {
            return nil
        }
        return t.dateValue()
    }
    
    public func dateFromSecondsAndNanoseconds(seconds: Int64, nanoseconds: Int32) -> Date? {
        Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
    }
    
    public func timestamp() -> Any {
        Timestamp()
    }
    
    public func timestampFromDate(_ date: Date) -> Any {
        Timestamp(date: date)
    }
    
    public func deleteFieldValue() -> Any {
        FieldValue.delete()
    }
}

final class FirestoreProvider: FirestoreAdapterType {
    let appProvider: FirebaseAppProvider
    
    init(appProvider: FirebaseAppProvider) {
        self.appProvider = appProvider
    }
    
    func collection(_ path: String) -> CollectionReferenceWrapper {
        let firestore = Firestore.firestore(app: appProvider.app)
        let collectionRef = firestore.collection(path)
        return FirestoreCollectionReferenceWrapper(reference: collectionRef)
    }
}

final class FirestoreDocumentReferenceWrapper: DocumentReferenceWrapper {
    private let reference: DocumentReference
    
    var path: String {
        reference.path
    }
    
    init(reference: DocumentReference) {
        self.reference = reference
    }
    
    func addSnapshotListener(_ callback: @escaping (DocumentSnapshotWrapper?, Error?) -> Void) -> ListenerRegistrationWrapper {
        let handle = reference.addSnapshotListener { snapshot, error in
            if let snapshot {
                callback(FirestoreDocumentSnapshotWrapper(snapshot: snapshot), error)
            } else {
                callback(nil, error)
            }
        }
        return FirestoreListenerRegistrationWrapper(registration: handle)
    }
    
    func collection(_ id: String) -> CollectionReferenceWrapper {
        let collectionRef = reference.collection(id)
        return FirestoreCollectionReferenceWrapper(reference: collectionRef)
    }
    
    func delete(completion: @Sendable @escaping (Error?) -> Void) {
        reference.delete(completion: completion)
    }
    
    func getDocument(_ completion: @Sendable @escaping (DocumentSnapshotWrapper?, Error?) -> Void) {
        let completionWrapper: @Sendable (DocumentSnapshot?, Error?) -> Void = { snapshot, error in
            if let snapshot {
                completion(FirestoreDocumentSnapshotWrapper(snapshot: snapshot), error)
            } else {
                completion(nil, error)
            }
        }
        reference.getDocument(completion: completionWrapper)
    }
    
    func setData(_ data: [String: Any], merge: Bool, completion: @Sendable @escaping (Error?) -> Void) {
        reference.setData(data, merge: merge, completion: completion)
    }
}

final class FirestoreCollectionReferenceWrapper: CollectionReferenceWrapper {
    private let reference: CollectionReference
    
    var path: String {
        reference.path
    }
    
    var description: String {
        "FirestoreCollectionReferenceWrapper: \(reference)"
    }
    
    init(reference: CollectionReference) {
        self.reference = reference
    }
    
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        reference.addDocument(data: data, completion: completion)
    }
    
    func document() -> DocumentReferenceWrapper {
        FirestoreDocumentReferenceWrapper(reference: reference.document())
    }
    
    func document(_ id: String) -> DocumentReferenceWrapper {
        FirestoreDocumentReferenceWrapper(reference: reference.document(id))
    }
    
    func whereField(_ field: String, isEqualTo: String) -> QueryWrapper {
        let newQuery = reference.whereField(field, isEqualTo: isEqualTo)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func whereField(_ field: String, isEqualTo: Bool) -> QueryWrapper {
        let newQuery = reference.whereField(field, isEqualTo: isEqualTo)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func whereField(_ field: String, isGreaterThan: Date) -> QueryWrapper {
        let newQuery = reference.whereField(field, isGreaterThan: isGreaterThan)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func order(by: String, descending: Bool) -> QueryWrapper {
        let newQuery = reference.order(by: by, descending: descending)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func limit(to: Int) -> QueryWrapper {
        let newQuery = reference.limit(to: to)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func addSnapshotListener(_ callback: @escaping (QuerySnapshotWrapper?, Error?) -> Void) -> ListenerRegistrationWrapper {
        let handle = reference.addSnapshotListener { snapshot, error in
            if let snapshot {
                callback(FirestoreQuerySnapshotWrapper(snapshot: snapshot), error)
            } else {
                callback(nil, error)
            }
        }
        return FirestoreListenerRegistrationWrapper(registration: handle)
    }
    
    func getDocuments(_ completion: @Sendable @escaping (QuerySnapshotWrapper?, Error?) -> Void) {
        let completionWrapper: @Sendable (QuerySnapshot?, Error?) -> Void = { snapshot, error in
            if let snapshot {
                completion(FirestoreQuerySnapshotWrapper(snapshot: snapshot), error)
            } else {
                completion(nil, error)
            }
        }
        reference.getDocuments(completion: completionWrapper)
    }
}

class FirestoreQueryWrapper: QueryWrapper {
    private let query: Query
    
    var description: String {
        "FirestoreQueryWrapper: \(query)"
    }
    
    init(query: Query) {
        self.query = query
    }
    
    func whereField(_ field: String, isEqualTo: String) -> QueryWrapper {
        let newQuery = query.whereField(field, isEqualTo: isEqualTo)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func whereField(_ field: String, isEqualTo: Bool) -> QueryWrapper {
        let newQuery = query.whereField(field, isEqualTo: isEqualTo)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func whereField(_ field: String, isGreaterThan: Date) -> QueryWrapper {
        let newQuery = query.whereField(field, isGreaterThan: isGreaterThan)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func order(by: String, descending: Bool) -> QueryWrapper {
        let newQuery = query.order(by: by, descending: descending)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func limit(to: Int) -> QueryWrapper {
        let newQuery = query.limit(to: to)
        return FirestoreQueryWrapper(query: newQuery)
    }
    
    func addSnapshotListener(_ callback: @escaping (QuerySnapshotWrapper?, Error?) -> Void) -> ListenerRegistrationWrapper {
        let handle = query.addSnapshotListener { snapshot, error in
            if let snapshot {
                callback(FirestoreQuerySnapshotWrapper(snapshot: snapshot), error)
            } else {
                callback(nil, error)
            }
        }
        return FirestoreListenerRegistrationWrapper(registration: handle)
    }
    
    func getDocuments(_ completion: @Sendable @escaping (QuerySnapshotWrapper?, Error?) -> Void) {
        let completionWrapper: @Sendable (QuerySnapshot?, Error?) -> Void = { snapshot, error in
            if let snapshot {
                completion(FirestoreQuerySnapshotWrapper(snapshot: snapshot), error)
            } else {
                completion(nil, error)
            }
        }
        query.getDocuments(completion: completionWrapper)
    }
}

final class FirestoreListenerRegistrationWrapper: ListenerRegistrationWrapper {
    let registration: ListenerRegistration
    
    init(registration: ListenerRegistration) {
        self.registration = registration
    }
    
    func remove() {
        registration.remove()
    }
}

final class FirestoreDocumentSnapshotWrapper: DocumentSnapshotWrapper {
    private let snapshot: DocumentSnapshot
    
    var exists: Bool {
        snapshot.exists
    }
    
    var documentID: String {
        snapshot.documentID
    }
    
    init(snapshot: DocumentSnapshot) {
        self.snapshot = snapshot
    }
    
    func data() -> [String: Any] {
        snapshot.data() ?? [:]
    }
    
    func data<T: Decodable>(as type: T.Type) throws -> T {
        try snapshot.data(as: T.self)
    }
}

final class FirestoreDocumentChangeWrapper: DocumentChangeWrapper {
    private let change: DocumentChange
    
    var type: DocumentChangeTypeWrapper {
        switch change.type {
        case .added:
            return .added
        case .modified:
            return .modified
        case .removed:
            return .removed
        }
    }
    var document: DocumentSnapshotWrapper {
        FirestoreDocumentSnapshotWrapper(snapshot: change.document)
    }
    
    init(change: DocumentChange) {
        self.change = change
    }
}

final class FirestoreQuerySnapshotWrapper: QuerySnapshotWrapper {
    private let snapshot: QuerySnapshot
    
    var documents: [QueryDocumentSnapshotWrapper] {
        snapshot.documents.map(FirestoreQueryDocumentSnapshotWrapper.init)
    }
    
    var documentChanges: [DocumentChangeWrapper] {
        snapshot.documentChanges.map(FirestoreDocumentChangeWrapper.init)
    }
    
    init(snapshot: QuerySnapshot) {
        self.snapshot = snapshot
    }
}

final class FirestoreQueryDocumentSnapshotWrapper: QueryDocumentSnapshotWrapper {
    private let snapshot: QueryDocumentSnapshot
    
    var documentID: String {
        snapshot.documentID
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        self.snapshot = snapshot
    }
    
    func data() -> [String : Any] {
        snapshot.data()
    }
}
