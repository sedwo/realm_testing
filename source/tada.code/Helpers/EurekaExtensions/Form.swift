import Eureka


extension Form {

    static func createSectionWith(tag: String, in form: Form) -> Section {
        var formSection = Section(header: "", footer: "") { section in
            section.tag = tag
        }

        // Check if the form has already been created.
        if form.last == nil {
            form +++ formSection        // new form + section
        } else {  // form exists, but check if section exists ...
            if let section = form.sectionBy(tag: tag) {
                formSection = section
            } else { // nope
                form +++ formSection    // new section
            }
        }

        return formSection
    }


    // (form) dictionary values() returns double optionals
    // issue #82: https://github.com/xmartlabs/Eureka/issues/82
    public func unwrappedValues(includeHidden hidden: Bool = false) -> [String: Any] {
        let wrapped = self.values(includeHidden: hidden)

        var unwrapped = [String: Any]()

        for (k, v) in wrapped {
            unwrapped[k] = v ?? nil
        }

        return unwrapped
    }

}
