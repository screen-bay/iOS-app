import UIKit
import QBFlatButton


/// MARK: - ILLBuyAdvertisementViewController
class ILLBuyAdvertisementViewController: UIViewController {

    /// MARK: - properties

    var deviceInfo: ILLDeviceInfo!
    var startDate: NSDate!
    var endDate: NSDate!

    @IBOutlet weak var leftBarButton: UIButton!
    @IBOutlet weak var rightBarButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dimentionsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var inputTextFieldWrapperView: UIView!
    @IBOutlet weak var inputTextField: UITextField!

    @IBOutlet weak var purchaseButton: QBFlatButton!

    @IBOutlet weak var purchaseWrapperView: UIView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var cancelPurchaseButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var purchaseNameLabel: UILabel!
    @IBOutlet weak var purchaseDimentionsLabel: UILabel!
    @IBOutlet weak var purchaseLocationLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.inputTextFieldWrapperView.layer.cornerRadius = 8.0
        self.inputTextFieldWrapperView.layer.masksToBounds = true
        self.inputTextFieldWrapperView.clipsToBounds = true

        self.nameLabel.text = self.deviceInfo.name
        self.dimentionsLabel.text = self.deviceInfo.dimentions
        self.locationLabel.text = self.deviceInfo.location
        self.priceLabel.text = self.deviceInfo.price

        self.purchaseButton.margin = 0
        self.purchaseButton.depth = 0
        self.purchaseButton.faceColor = UIColor(red: 243.0/255.0, green: 156.0/255.0, blue: 18.0/255.0, alpha: 1.0)

        self.leftBarButton.setImage(
            IonIcons.imageWithIcon(
                ion_ios_arrow_back,
                iconColor: UIColor.grayColor(),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )

        self.rightBarButton.setImage(
            IonIcons.imageWithIcon(
                ion_navicon,
                iconColor: UIColor.grayColor(),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )

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
        if button == self.purchaseButton {
            self.showPurchaseView()
        }
        else if button == self.cancelPurchaseButton {
            self.hidePurchaseView()
        }
        else if button == self.buyButton {
            self.hidePurchaseView()

            let image = ILLBuyAdvertisementViewController.imageFromString(self.inputTextField.text!, font: UIFont(name: "Helvetica Neue", size: 12)!)
            //let data = UIImagePNGRepresentation(UIImage(named: "test")!)!
            let data = UIImagePNGRepresentation(image)!
            let fileName = "test.png"
            ILLBluetoothWritingOperationQueue.sharedInstance.play(
                data: data,
                fileName: fileName,
                completionHandler: { [unowned self] (error: NSError?) -> Void in
                    ILLLOG(error)
                }
            )

        }
        else if button == self.leftBarButton {
            self.navigationController!.popViewControllerAnimated(true)
        }
    }


    /// MARK: - private api

    class func imageFromString(string: String,  font: UIFont) -> UIImage {
        let size = ILLBuyAdvertisementViewController.textSize(text: string, font: font, height: 30)
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            //NSParagraphStyleAttributeName: textStyle
        ]
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        string.drawInRect(CGRectMake(0, 0, size.width, size.height), withAttributes: textFontAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }

    /**
     * get estimated size
     * @param text String
     * @param font UIFont
     * @param width CGFloat
     * @return CGSize
     */
    class func textSize(text text: String, font: UIFont, height: CGFloat) -> CGSize {
        let string = ILLBuyAdvertisementViewController.justifiedString(text, font: font)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading)
        let rect = string.boundingRectWithSize(
            CGSizeMake(CGFloat(MAXFLOAT), height),
            options: options,
            context: nil
        )
        return rect.size
        //return CGSizeMake(rect.width, rect.height * 1.3)
    }

    class func justifiedString(text: String, font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        paragraphStyle.firstLineHeadIndent = 0.001
        return NSAttributedString(
            string: text,
            attributes: [
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle,
            ]
        )
    }

    private func showPurchaseView() {
        self.view.bringSubviewToFront(self.purchaseWrapperView)

        self.purchaseWrapperView.hidden = false

        self.purchaseView.layer.cornerRadius = 8.0
        self.purchaseView.layer.masksToBounds = true
        self.purchaseView.clipsToBounds = true
        self.purchaseView.transform = CGAffineTransformMakeScale(3.0, 3.0)
        self.purchaseView.alpha = 0.0

        self.cancelPurchaseButton.setImage(
            IonIcons.imageWithIcon(
                ion_ios_close_outline,
                iconColor: UIColor(red: 243.0/255.0, green: 156.0/255.0, blue: 18.0/255.0, alpha: 1.0),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )
        self.cancelPurchaseButton.hidden = true

        self.purchaseNameLabel.text = self.deviceInfo.name
        self.purchaseDimentionsLabel.text = self.deviceInfo.dimentions
        self.purchaseLocationLabel.text = self.deviceInfo.location

        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .FullStyle
        dateFormatter.dateFormat = "MM/dd/yy: HH:mm-"
        let startDateString = dateFormatter.stringFromDate(self.startDate)
        dateFormatter.dateFormat = "HH:mm"
        let endDateString = dateFormatter.stringFromDate(self.endDate)
        self.purchaseDateLabel.text = startDateString + endDateString

        UIView.animateWithDuration(
            0.25,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.purchaseView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.purchaseView.alpha = 1.0
            },
            completion: { [unowned self] finished in
                self.cancelPurchaseButton.hidden = false
            }
        )
    }

    private func hidePurchaseView() {
        self.purchaseView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        self.purchaseView.alpha = 1.0
        self.cancelPurchaseButton.hidden = true

        UIView.animateWithDuration(
            0.20,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.purchaseView.transform = CGAffineTransformMakeScale(2.0, 2.0)
                self.purchaseView.alpha = 0.0
            },
            completion: { [unowned self] finished in
                self.purchaseWrapperView.hidden = true
            }
        )
    }

}
