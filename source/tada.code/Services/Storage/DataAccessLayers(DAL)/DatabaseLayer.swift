import CocoaLumberjack
import RealmSwift



let realmApp = RealmSwift.App(id: "tada-wkgma")

enum Partition: String, CaseIterable {
    case user
    case `default`

    var description: String {
        if let currentUser = realmApp.currentUser {
            switch self {
            case .user,
                 .default:
                return "user=\(currentUser.id)"
            }
        } else {
            DDLogError("Realm configuration error: invalid current user. 💥")
            fatalError("Realm configuration error: invalid current user. 💥")
        }
    }

    // Default MongoDB Realm partition key string name.
    static let key = "_partition"
}



protocol DatabaseLayer {
}

extension DatabaseLayer where Self: Object {

    // MARK: - DB setup
    /*
     private var userRealmFile: URL {
     let fullURLpath = userAppDirectory.appendingPathComponent(DALconfig.realmStoreName)
     return fullURLpath
     }
     */

    private static func setup(config: Realm.Configuration) -> Realm.Configuration {
        var realmConfig = config

//        realmConfig.fileURL = userRealmFile

/*
        // synced Realms don’t support migration blocks
        // https://docs.realm.io/sync/using-synced-realms/syncing-data
        realmConfig.schemaVersion = DALconfig.DatabaseSchemaVersion

        realmConfig.migrationBlock = { migration, oldSchemaVersion in
            // If we haven’t migrated anything yet, then `oldSchemaVersion` == 0
            if oldSchemaVersion < DALconfig.DatabaseSchemaVersion {
                // Realm will automatically detect new properties and removed properties,
                // and will update the schema on disk automatically.
                DDLogVerbose("⚠️  Migrating Realm DB: from v\(oldSchemaVersion) to v\(DALconfig.DatabaseSchemaVersion)  ⚠️")
                /*
                 if oldSchemaVersion < 2 {
                 DDLogVerbose("⚠️ ++ \"oldSchemaVersion < 2\"  ⚠️")
                 // Changes for v2:
                 // ...
                 DDLogVerbose("... ")
                 migration.enumerateObjects(ofType: ...) { (_, type) in

                 }
                 }
                 */
            }
        }
*/
        realmConfig.shouldCompactOnLaunch = { (totalBytes: Int, usedBytes: Int) -> Bool in
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let totalBytesString = bcf.string(fromByteCount: Int64(totalBytes))
            let usedBytesString = bcf.string(fromByteCount: Int64(usedBytes))

            DDLogInfo("size_of_realm_file: \(totalBytesString), used_bytes: \(usedBytesString)")
            let utilization = Double(usedBytes) / Double(totalBytes) * 100.0
            DDLogInfo(String(format: "utilization: %.0f%%", utilization))

            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file

            // Compact if the file is over 100mb in size and less than 60% 'used'
            let filesizeMB = 100 * 1024 * 1024
            let compactRealm: Bool = (totalBytes > filesizeMB) && (Double(usedBytes) / Double(totalBytes)) < 0.6

            if compactRealm {
                DDLogError("⚠️ Compacting Realm database...")
            }

            return compactRealm
        }

        return realmConfig
    }



    static func openRealm(partition: String? = Partition.default.description) -> Realm? {
        guard let partitionValue = partition else {
            DDLogError("Realm configuration error: invalid partition value. 💥")
            fatalError("Realm configuration error: invalid partition value. 💥")
        }

        let config = realmApp.currentUser!.configuration(partitionValue: partitionValue)
        let realmConfiguration = setup(config: config) // update with other params.

        do {
            return try Realm(configuration: realmConfiguration)
        } catch let error {
            DDLogError("Database error: \(error)")
            fatalError("Database error: \(error)")
        }
    }


//    static func getDatabase(_ completion:@escaping (_ realm: Realm?) -> Void) {
//        // Open the realm asynchronously so that it downloads the remote copy before opening the local copy.
//        Realm.asyncOpen(configuration: realmConfig) { result in
//            switch result {
//            case .failure(let error):
//                DDLogError("Database error: \(error)")
//                fatalError("Database error: \(error)")
//            case .success(let userRealm):
//                completion(userRealm)
//            }
//        }
//    }



    // MARK: - Low-level CRUD
/*
    func create() {
        autoreleasepool {
            do {
                let database = Self.getDatabase()

                try database?.safeWrite {
                    database?.add(self)
                }
//                try database?.write {
//                    database?.add(self)
//                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }
*/

    static func createOrUpdateAll(with objects: [Self], update: Bool = true) {
        if objects.isEmpty {
            DDLogError("⚠️ 0 objects")
            return
        }

        let objectPartitionValue = objects.first?.value(forKeyPath: Partition.key) as! String

        autoreleasepool {
            do {
                let database = self.openRealm(partition: objectPartitionValue)
                try database?.write {
                    database?.add(objects, update: update ? .all : .error)
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }

    }


    static func findAll(inPartition: String? = Partition.default.description) -> [Self] {
        if let database = self.openRealm(partition: inPartition) {
            return database.objects(Self.self).map { $0 }
        } else {
            return []
        }
    }


/*
    static func deleteAll(objects: [Self]) {
        autoreleasepool {
            do {
                let database = self.getDatabase()
                try database?.write {
                    database?.delete(objects)
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }

    static func deleteAllOfType(objectType: Object.Type) {
        autoreleasepool {
            do {
                let database = Self.getDatabase()
                try database?.write {
                    if let allObjects = database?.objects(objectType) {
                        database?.delete(allObjects)
                    }
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }

    static func find(withID: String) -> Self? {
        let database = self.getDatabase()
        return database?.object(ofType: Self.self, forPrimaryKey: withID)
    }




    static func findAll(sortedBy key: String) -> [Self] {
        let database = self.getDatabase()

        if let allObjects = database?.objects(Self.self) {
            let results = allObjects.sorted(byKeyPath: key, ascending: true)
            return Array(results)
        }

        return []
    }


    static func writeTransaction(writeTransactionBlock: @escaping () -> Void) {
        autoreleasepool {
            do {
                let database = getDatabase()
                try database?.safeWrite {
                    writeTransactionBlock()
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }


    // MARK: - Change notifications

    // Setup to observe Realm `CollectionChange` notifications
    func setupNotificationToken(for observer: AnyObject, _ block: @escaping () -> Void) -> NotificationToken? {
        let database = Self.getDatabase()

        return database?.objects(Self.self).observe { changes in// [weak observer] (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    return  // ignore first setup
                case .update(_, _, _, _):
//                case .update(let objects, let deletions, let insertions, let modifications):
                    /// .. a write transaction has been committed which either changed which objects are in the collection,
                    /// and/or modified one or more of the objects in the collection.
//                    DDLogDebug("NotificationToken triggered on: \(observer!) for object: \(Self.self)")
/*
                    DDLogDebug("(triggered!) - objects count = \(objects.count)")
                    for object in objects {
                        if let id = object.value(forKey: "id") as? String {
                            DDLogDebug("id = \(id)")
                        }
                    }

                    DDLogDebug("deletions = \(deletions)")
                    DDLogDebug("insertions = \(insertions)")
                    DDLogDebug("modifications = \(modifications)")
*/
                    block()
                case .error(let err):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(err)")
                }
            }
    }


    // MARK: - Collect all objects that are set to be removed from the DB.

    static func findAllremovedOnServer() -> [Self] {
        let database = getDatabase()

        if let allObjects = database?.objects(Self.self).filter("isRemovedOnServer = true") {
            return allObjects.map { $0 }
        }

        return []
    }


    static func findAllremovedOnClient() -> [Self] {
        let database = getDatabase()

        if let allObjects = database?.objects(Self.self).filter("isRemovedOnClient = true") {
            return allObjects.map { $0 }
        }

        return []
    }


    static func purgeRemovedOnServer() {
        let removeObjects = findAllremovedOnServer()
        if removeObjects.count > 0 {
            deleteAll(objects: removeObjects)
            DDLogVerbose("🗑  Removed \(removeObjects.count) object(s) from \(Self.self).")
        }
    }


    // MARK: -

    // *important* for multithreading purposes.
    // https://stackoverflow.com/a/45810078/7599
    static func forceRefresh() {
        getDatabase()?.refresh()
    }
*/
}



// https://stackoverflow.com/a/54203871/7599
extension Realm {

    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }

}
