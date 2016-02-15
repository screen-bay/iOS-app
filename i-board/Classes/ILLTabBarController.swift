import UIKit


/// MARK: - ILLTabBarController
class ILLTabBarController: UITabBarController {

    /// MARK: - properties


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.designTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener


    /// MARK: - private api

    /**
     * design tab bar
     **/
    private func designTabBar() {
    }
}
