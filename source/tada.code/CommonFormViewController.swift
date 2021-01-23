import UIKit
import CocoaLumberjack
import Eureka



// MARK: -

class CommonFormViewController: FormViewController, IndicatorProtocol {

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
//        DDLogInfo("\(self)")
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        DDLogInfo("\(self)")

        // https://stackoverflow.com/a/34923168/7599
        // Display back buttons as a '<' chevron only.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }


    override func updateViewConstraints() {
        super.updateViewConstraints()
//        DDLogInfo("")
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
//        DDLogInfo("")
        view.setNeedsUpdateConstraints()
    }


    // MARK: - lock rotation control, except for iPad
    override var shouldAutorotate: Bool {
//        DDLogVerbose("")
        return hardwareDevice.isPad
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        DDLogInfo("\(appDelegate.device.isPhone ? UIInterfaceOrientationMask.portrait : UIInterfaceOrientationMask.all)")
        return hardwareDevice.isPhone ? UIInterfaceOrientationMask.portrait : UIInterfaceOrientationMask.all
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DDLogInfo("")
        view.setNeedsUpdateConstraints()
    }


    deinit {
        DDLogWarn("")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DDLogError("")
    }


    // To avoid a `grouped type` table view displaying all caps in the section header title.
    // https://github.com/xmartlabs/Eureka/issues/1609
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.text = (view as? UITableViewHeaderFooterView)?.textLabel?.text?.capitalized
    }

}
