struct UserProfile: Codable {
    private let userCredentials: UserCredentials

    var isLastSignedIn: Bool = false

    // MARK: -

    init(userCredentials: UserCredentials = UserCredentials()) {
        self.userCredentials = userCredentials
    }

    var email: String {
        return userCredentials.email
    }

    var password: String {
        return userCredentials.password
    }

    func isEmpty() -> Bool {
        return email.isEmpty
    }


}
