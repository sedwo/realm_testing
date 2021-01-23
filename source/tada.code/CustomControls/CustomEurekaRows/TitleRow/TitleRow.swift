import Eureka
import CocoaLumberjack

// MARK: Custom Eureka Row
// Simple label row that shows title (with hidden value) and is not editable by the user.
//
// This custom row was created so that we can better control removing the 'SeparatorView' from the cell
// and make the row resemble a 'header' section if need be.
// Trying to do it outside of the cell doesn't consistantly work.
// fyi: https://stackoverflow.com/questions/49721027/why-isnt-uitableviewcells-separator-view-listed


open class TitleCellOf<T: Equatable>: Cell<T>, CellType {

    var withSeparator: Bool = true {
        didSet {
            self.layoutSubviews()
        }
    }

    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func setup() {
        super.setup()
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.hideBottomSeparator(!withSeparator)
    }

    deinit {
//        DDLogWarn("")
    }

}



public typealias TitleCell = TitleCellOf<String>



// MARK: TitleRow

open class _TitleRow: Row<TitleCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
    }

    deinit {
//        DDLogWarn("")
    }
}



/// Simple row that can show `title` only and is not editable by user.
public final class TitleRow: _TitleRow, RowType {

    private var meta: [String: Any] = [:]

    required public init(tag: String?) {
        super.init(tag: tag)

        // Nullify displaying any value.  As we use it for holding data (eg. id's)
        // https://github.com/xmartlabs/Eureka/issues/301#issuecomment-196967005
        self.displayValueFor = { value in
            return nil
        }
    }

    // Support for storage of generic values.
    // Does not affect `row.value` property.

    func storeMetaValue(value: Any, forKey: String) {
        meta[forKey] = value
    }

    func retrieveMetaValue(forKey: String) -> Any? {
        return meta[forKey]
    }

    deinit {
//        DDLogWarn("")
    }
}
