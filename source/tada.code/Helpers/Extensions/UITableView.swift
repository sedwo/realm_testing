import UIKit



protocol TableViewRegisterable {

    static var nib: UINib { get }
    static var reuseIdentifier: String { get }

}


extension UITableView {

    func register(type: TableViewRegisterable.Type) {
        self.register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }

}
