import CocoaLumberjack
import RealmSwift



protocol DataProvider: DatabaseLayer {
}

/*
extension DataProvider where Self: Object {
    // MARK: - Generic `model` specific operations

    static func find(withName: String) -> Self? {
        let database = self.getDatabase()
        return database?.objects(Self.self).filter("name = '\(withName)'").first
    }


    static func find(withEmail: String) -> Self? {
        let database = self.getDatabase()
        // Realm case insensitive search syntax
        // https://stackoverflow.com/a/43746523/7599
        return database?.objects(Self.self).filter("email contains[c] %@", withEmail).first
    }


    static func findAllWith(_ withIDs: [String]) -> [Self] {

        if withIDs.isEmpty {
            return []
        }

        var predicateFormat: String = ""

        if withIDs.count != 0 {
            for (index, id) in withIDs.enumerated() {
                predicateFormat += "id = '\(id)'"
                if index != withIDs.count-1 {
                    predicateFormat += " || "
                }
            }
        }

        return filterAllwithPredicate(predicateFormat)
    }


    static func findAllWith(_ orgID: String,
                            locationID: String = "",
                            projectIDs: [String] = [],
                            workflowStateIDs: [String] = [],
                            reviewStates: [String] = [],
                            signTypeIDs: [String] = [],
                            signIDs: [String] = [],
                            sortedByOrderID: Bool = false,
                            withAdditionalPredicate: String = "") -> [Self] {

        var predicateFormat: String = "organizationID = '\(orgID)'"

        if !locationID.isEmpty {
            predicateFormat += " && locationID = '\(locationID)'"
        }

        if projectIDs.count != 0 {
            predicateFormat += " && ("
            for (index, id) in projectIDs.enumerated() {
                predicateFormat += "projectID = '\(id)'"
                if index != projectIDs.count-1 {
                    predicateFormat += " || "
                }
            }
            predicateFormat += ")"
        }

        if workflowStateIDs.count != 0 {
            predicateFormat += " && ("
            for (index, id) in workflowStateIDs.enumerated() {
                predicateFormat += "workflowStateID = '\(id)'"
                if index != workflowStateIDs.count-1 {
                    predicateFormat += " || "
                }
            }
            predicateFormat += ")"
        }

        if signTypeIDs.count != 0 {
            predicateFormat += " && ("
            for (index, id) in signTypeIDs.enumerated() {
                predicateFormat += "signTypeID = '\(id)'"
                if index != signTypeIDs.count-1 {
                    predicateFormat += " || "
                }
            }
            predicateFormat += ")"
        }

        if signIDs.count != 0 {
            predicateFormat += " && ("
            for (index, id) in signIDs.enumerated() {
                predicateFormat += "signID = '\(id)'"
                if index != signIDs.count-1 {
                    predicateFormat += " || "
                }
            }
            predicateFormat += ")"
        }

        if reviewStates.count != 0 {
            predicateFormat += " && ("
            for (index, id) in reviewStates.enumerated() {
                predicateFormat += "reviewState = '\(id)'"
                if index != reviewStates.count-1 {
                    predicateFormat += " || "
                }
            }
            predicateFormat += ")"
        }

        if !withAdditionalPredicate.isEmpty {
            predicateFormat += " && \(withAdditionalPredicate)"
        }

        return filterAllwithPredicate(predicateFormat, sortedByOrderID: sortedByOrderID)
    }


    static private func filterAllwithPredicate(_ predicateFormat: String, sortedByOrderID: Bool = true) -> [Self] {
//        DDLogInfo("\(predicateFormat)")
        let database = self.getDatabase()

        if let allObjects = database?.objects(Self.self) {
            if sortedByOrderID {
                let results = allObjects.sorted(byKeyPath: "orderID", ascending: true).filter(predicateFormat)
                return Array(results)
            } else {
                let results = allObjects.filter(predicateFormat)
                return Array(results)
            }
        }

        return []
    }


    // MARK: -

    static func updateRemovedOnClientFlag(for id: String, with state: Bool) {
        updateObject(id, forKey: "isRemovedOnClient", with: state)
    }


    // MARK: -

    static func updateObject(_ id: String, forKey: String, with value: String) {   // update with `String` value
        autoreleasepool {
            let database = self.getDatabase()!
            let object = database.object(ofType: Self.self, forPrimaryKey: id)!

            do {
                try database.write {
                    object.setValue(value, forKey: forKey)
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }


    static func updateObject(_ id: String, forKey: String, with value: Bool) {   // update with `Bool` value
        autoreleasepool {
            let database = self.getDatabase()!
            let object = database.object(ofType: Self.self, forPrimaryKey: id)!

            do {
                try database.write {
                    object.setValue(value, forKey: forKey)
                }
            } catch let error {
                DDLogError("Database error: \(error)")
                fatalError("Database error: \(error)")
            }
        }
    }

    static func getAllSortedByName() -> [Self] {
        return findAll(sortedBy: "name")
    }


    // sorted by "******LastUpdated"
    static func sortObjectsByLastUpdated<T: RLMDefaults>(order: ComparisonResult = .orderedDescending, _ objects: [T]) -> [T] {
        if objects.isEmpty {
            return []
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = DALconfig.ISO8601dateFormat

        let sortedObjects = objects.sorted(by: {
            // Convert ISO8601 date string format to Date() object.
            let serverDate0: Date? = $0.serverLastUpdated != nil ? formatter.date(from: $0.serverLastUpdated!) : nil
            let serverDate1: Date? = $1.serverLastUpdated != nil ? formatter.date(from: $1.serverLastUpdated!) : nil
            let clientDate0: Date? = $0.clientLastUpdated != nil ? formatter.date(from: $0.clientLastUpdated!) : nil
            let clientDate1: Date? = $1.clientLastUpdated != nil ? formatter.date(from: $1.clientLastUpdated!) : nil

            // Filter and sort each object separately.
            let objDate0: Date? = self.filterOptionalsWithLargeNil(lhs: serverDate0, rhs: clientDate0)
            let objDate1: Date? = self.filterOptionalsWithLargeNil(lhs: serverDate1, rhs: clientDate1)

            // Final comparison.
            guard let finalDate0 = objDate0 else { return false }
            guard let finalDate1 = objDate1 else { return false }

            return finalDate0.compare(finalDate1) == order

        })

        return sortedObjects
    }

    // fyi ref: @Martin R, https://stackoverflow.com/a/53427282/7599
    private static func filterOptionalsWithLargeNil<T: Comparable>(lhs: T?, rhs: T?) -> T? {
        var result: T?

        switch (lhs, rhs) {
        case let(l?, r?): result = l > r ? l : r    // Both lhs and rhs are not nil
        case let(nil, r?): result = r               // Lhs is nil
        case let(l?, nil): result = l               // Lhs is not nil, rhs is nil
        case (.none, .none):
            result = nil
        }

        return result
    }


}
*/
