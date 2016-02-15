import UIKit


/// MARK: - ILLFeaturedViewController
class ILLFeaturedViewController: UIViewController {

    /// MARK: - properties


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when button is touched up inside
     * @param button UIButton
     **/
    @IBAction func touchedUpInside(button button: UIButton) {
        if ILLBluetoothCentral.sharedInstance.pairedPeripheral == nil { return }

        let data = UIImagePNGRepresentation(UIImage(named: "test")!)!
        //let data = "1".dataUsingEncoding(NSUTF8StringEncoding)!
        let fileName = "test.png"
        ILLBluetoothWritingOperationQueue.sharedInstance.play(
            data: data,
            fileName: fileName,
            completionHandler: { [unowned self] (error: NSError?) -> Void in
                ILLLOG(error)
            }
        )
    }

}

