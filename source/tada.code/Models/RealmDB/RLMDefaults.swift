import Foundation
import RealmSwift



class RLMDefaults: Object {

    @objc dynamic var _id: String = newUUID
    @objc dynamic var _partitionKey: String = ""

    @objc dynamic var serverLastUpdated: String? = nil
    @objc dynamic var clientLastUpdated: String? = nil


    override static func primaryKey() -> String? {
        return "_id"
    }

    convenience init(partitionKey: String) {
        self.init()
        self._partitionKey = partitionKey
    }

}
