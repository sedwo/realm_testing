import CocoaLumberjack
import Eureka
//import RxEureka
import FloatLabelRow
import RealmSwift



class TestVC1: CommonFormViewController {

    private var navigator: AppNavigator!

    var uploadToken: SyncSession.ProgressNotificationToken?



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


        if let syncSession = appSession.userRealm?.syncSession {
            uploadToken = syncSession.addProgressNotification(for: .upload,
                                                              mode: .reportIndefinitely) { progress in

                DDLogVerbose("sync progress (.upload): \(progress.fractionTransferred*100.0)")

//                if progress.isTransferComplete {
//                    self.uploadToken?.invalidate()
//                }

            }
        } else {
            DDLogError("⚠️ invalid syncSession")
        }


    }

    @objc func signOut() {
        DDLogDebug("")

        _ = realmApp.currentUser?.logOut()
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
/*
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
*/
        form +++ Section(header: "", footer: "") { section in
            }

            <<< ButtonRow() { row in
                row.title = "button1"
                }.onCellSelection { [unowned self] cell, row in
                    DDLogVerbose("Selected \(row.title!)")


//                    let car = RLMCar()
//                    car.brand = "Honda"
//                    car.colour = "Blue"
//
//                    appSession.userRealm?.createOrUpdateAll(with: [car])



                    let car = RLMCar()
                    car.brand = "Datsun"
                    car.colour = "Neon"

                    RLMCar.createOrUpdateAll(with: [car])


                    DispatchQueue.global(qos: .userInitiated).async { // separate thread...

//                    DispatchQueue.main.async {
//                    let car = RLMCar()
//                    let car = RLMCar(partitionKey: Partition.user)
//                    car.brand = "Datsun"
//                    car.colour = "Neon"
//
//                    RLMCar.createOrUpdateAll(with: [car])

                    RLMCar.findAll()

                    }

//                    self.navigator.navigate(to: .VC2, with: .modalWithNavigationBar)
//                    self.navigator.navigate(to: .VC2, with: .modal)


//                    }
                }


            <<< ButtonRow() { row in
                row.title = "sync now"
            }.onCellSelection { [unowned self] cell, row in
                DDLogVerbose("Selected \(row.title!)")
                appSession.userRealm?.syncSession?.resume()
            }


//        self.tableView.backgroundColor = UIColor.blue
    }

}
