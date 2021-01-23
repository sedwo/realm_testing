import CocoaLumberjack
import Eureka
//import RxEureka
import FloatLabelRow



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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(moreButton))
    }

    @objc func moreButton() {
        DDLogDebug("")

//        self.navigator.navigate(to: .VC4, with: .push)
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
/*
            <<< ButtonRow() { row in
                row.title = "button1"
                }.onCellSelection { [unowned self] cell, row in
                    DDLogVerbose("Selected \(row.title!)")
//                    self.navigator.navigate(to: .VC2, with: .modalWithNavigationBar)
//                    self.navigator.navigate(to: .VC2, with: .modal)
                }
*/


//        self.tableView.backgroundColor = UIColor.blue
    }

}
