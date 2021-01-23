struct Session {
    var token: APIToken = APIToken()
    var userProfile: UserProfile = UserProfile()


    func isSignedIn() -> Bool {
        return token.isValid()
    }

}
