import UIKit
import QBFlatButton


/// MARK: - ILLMagnetAdvertisementViewController
class ILLMagnetAdvertisementViewController: UIViewController {

    /// MARK: - properties

    @IBOutlet weak var leftBarButton: UIButton!

    @IBOutlet weak var inputTextFieldWrapperView: UIView!
    @IBOutlet weak var inputTextField: UITextField!

    @IBOutlet weak var sendButton: QBFlatButton!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.leftBarButton.setImage(
            IonIcons.imageWithIcon(
                ion_android_close,
                iconColor: UIColor.grayColor(),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )

        self.inputTextFieldWrapperView.layer.cornerRadius = 8.0
        self.inputTextFieldWrapperView.layer.masksToBounds = true
        self.inputTextFieldWrapperView.clipsToBounds = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
        self.inputTextField.resignFirstResponder()
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.leftBarButton {
            self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        }
        else if button == self.sendButton {
//            let image = ILLBuyAdvertisementViewController.imageFromString(self.inputTextField.text!, font: UIFont(name: "Helvetica Neue", size: 12)!)
//            //let data = UIImagePNGRepresentation(UIImage(named: "test")!)!
//            let data = UIImagePNGRepresentation(image)!
//            let fileName = "test.png"
//            ILLBluetoothWritingOperationQueue.sharedInstance.play(
//                data: data,
//                fileName: fileName,
//                completionHandler: { [unowned self] (error: NSError?) -> Void in
//                    ILLLOG(error)
//                }
//            )

        // request
        let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox.magnet.com/message/api/v2/messages/send_to_user_ids")!)
        request.wst_setHTTPBody(
            [
              "receipt": true,
              "recipientUserIds": ["ff80808152d879cc0152dda603a801d5"],
              "content": [ "header1": "data1", "message": self.inputTextField.text! ],
              "metadata":[ "content-type":"text", "content-encoding":"simple"]
            ]
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("8tFV5zNIvvEeMMn8iPPmD57c1u_-u1UP3buN3AnXze3v0eJR_FZ2e5TxA6I5UCUTN7MllR3VHgQJDBnO77Y0z73XkpSTWD6__4FxQWy5aT8HpWbIhTT7aQGi1C3zzxxoUo1phsBXjkNWLhUh9yssQyGsIWLqAHm7SlgpB0D7uocS_YuwQOTCZuQSjHfYrIa4Da9d47RBFaMWOw_jmBM6XJLcyPV3Pa4rZWIbN_PAj6fxN5-Lyqn_PaPexJXAqI3X5Fy17DYYUvngnR6HDe6McuI0dx172r8qZHUGlzcu4Rc", forHTTPHeaderField: "Authorization")
        request.addValue("timeout=10, max=20", forHTTPHeaderField: "keep-alive")

        let operation = ISHTTPOperation(
            request: request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil {
                    responseJSON = JSON(data: object as! NSData)
                }
                ILLLOG(responseJSON)
            }
        )
        ISHTTPOperationQueue.defaultQueue().addOperation(operation)

        }

    }


    /// MARK: - private api

}
