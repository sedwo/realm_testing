import XCTest
import Moya
import CocoaLumberjack

@testable import tada


class SignInTests: XCTestCase {

    var session: Session!


    override func setUp() {
        super.setUp()
        // code goes here
    }


    override func tearDown() {
        // code goes here
        super.tearDown()
    }


    func testForEmptyAuthCredentials() {
        let userCredentials = UserCredentials(email: "", password: "")

        // Try to sign in user with credentials.
        AuthAPIservice.authenticateUserWith(userCreds: userCredentials) { token, error in
//            DDLogDebug("error = \(error)")
            XCTAssert(error != nil)
        }
    }


    func testAuthSignIn() {
        let userCredentials = UserCredentials(email: "testuser", password: "testpassword")

        // Try to sign in user with credentials.
        AuthAPIservice.authenticateUserWith(userCreds: userCredentials) { [unowned self] token, error in

            XCTAssert(token != nil)

            if let token = token {
                // New profile
                let userProfile = UserProfile(userCredentials: userCredentials)

                // New session
                self.session = Session(token: token, userProfile: userProfile)

            } else if error != nil { }
        }
    }


}
