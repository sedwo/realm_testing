import CocoaLumberjack
import Eureka
//import RxEureka
import FloatLabelRow
import RealmSwift



class TestVC1: CommonFormViewController {

    private var navigator: AppNavigator!

    // MARK: - Initializers(...)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DDLogInfo("")
    }


    init(navigator: AppNavigator) {
        super.init(nibName: nil, bundle: nil)
//        DDLogVerbose("AppNavigator = \(navigator)")

        self.navigator = navigator
    }


    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogInfo("")

        initializeForm()

        navigationItem.title = "Test VC #1"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
    }

    @objc func signOut() {
        DDLogDebug("")

        app.currentUser?.logOut()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DDLogWarn("\(self)")
    }


    deinit {
        DDLogWarn("\(self)")
    }

}


extension TestVC1 {

    func initializeForm() {

        // MARK: - email section
        form +++ Section(header: "", footer: "") { section in
            }

            <<< TextFloatLabelRow() { row in
                row.title = "ABC"
                row.value = "123"
                }.onCellSelection { cell, row in
                    DDLogVerbose("Selected \(row.title!)")
                }

        form +++ Section(header: "", footer: "") { section in
            }

            <<< TextFloatLabelRow() { row in
                row.title = "DEF"
                row.value = "456"
                }.onCellSelection { cell, row in
                    DDLogVerbose("Selected \(row.title!)")
        }

        form +++ Section(header: "", footer: "") { section in
            }

            <<< ButtonRow() { row in
                row.title = "button1"
                }.onCellSelection { [unowned self] cell, row in
                    DDLogVerbose("Selected \(row.title!)")

//                    DispatchQueue.main.async {
                    let car = RLMCar(partitionKey: "user=\(app.currentUser!.id)")
//                    let car = RLMCar(partitionKey: "user=\(appSession.userProfile.email)")
                    car.brand = "Tesla SUV"
                    car.colour = "Cyan"

                    appSession.userRealm?.createOrUpdateAll(with: [car])



//                    self.navigator.navigate(to: .VC2, with: .modalWithNavigationBar)
//                    self.navigator.navigate(to: .VC2, with: .modal)


//                    }
                }



//        self.tableView.backgroundColor = UIColor.blue
    }

}
