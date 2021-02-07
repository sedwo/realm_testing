import Foundation
import CocoaLumberjack
import RealmSwift



class RLMDefaults: Object, DataProvider {

    @objc dynamic var _id: String = newUUID
    @objc dynamic var _partition: String = Partition.default.description

    @objc dynamic var serverLastUpdated: String? = nil
    @objc dynamic var clientLastUpdated: String? = nil


    override static func primaryKey() -> String? {
        return "_id"
    }



    convenience init(partitionKey: String) {
        self.init()
        self._partition = partitionKey
    }



//    convenience init(inRealm: Realm) {
//        self.init()
//
//        if let syncConfiguration = inRealm.configuration.syncConfiguration,
//           let partitionValue = syncConfiguration.partitionValue?.stringValue {
//            self._partition = partitionValue
//        } else {
//            DDLogError("Realm configuration error: not a syncing realm. 💥")
//            fatalError("Realm configuration error: not a syncing realm. 💥")
//       }
//    }



}
