import UIKit
import QBFlatButton


/// MARK: - ILLAdvertisementViewController
class ILLAdvertisementViewController: UIViewController {

    /// MARK: - properties

    var deviceInfo: ILLDeviceInfo!

    @IBOutlet weak var leftBarButton: UIButton!
    @IBOutlet weak var rightBarButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dimentionsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var dateButtonWrapperView: UIView!
    var currentSettingButton: UIButton? = nil
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var findAvailabilitiesButton: QBFlatButton!

    @IBOutlet weak var datePickerButton: UIButton!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var timeSlotView: UIView!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.findAvailabilitiesButton.margin = 0
        self.findAvailabilitiesButton.depth = 0
        self.findAvailabilitiesButton.faceColor = UIColor(red: 200.0/255.0, green: 100.0/255.0, blue: 14.0/255.0, alpha: 1.0)

        self.timeSlotView.hidden = true

        self.nameLabel.text = self.deviceInfo.name
        self.dimentionsLabel.text = self.deviceInfo.dimentions
        self.locationLabel.text = self.deviceInfo.location
        self.priceLabel.text = self.deviceInfo.price

        self.dateButtonWrapperView.layer.cornerRadius = 8.0
        self.dateButtonWrapperView.layer.masksToBounds = true
        self.dateButtonWrapperView.clipsToBounds = true
        self.dateButtonWrapperView.layer.borderWidth = 1
        self.dateButtonWrapperView.layer.borderColor = UIColor.whiteColor().CGColor

        self.datePickerView.frame = CGRectMake(0, self.view.frame.height, self.datePickerView.frame.width, self.datePickerView.frame.height)

        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .FullStyle
        dateFormatter.dateFormat = "MM/dd/yy 18:00"
        let dateString = dateFormatter.stringFromDate(self.datePicker.date)
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        let date = dateFormatter.dateFromString(dateString)!

        self.datePicker.date = date

        self.datePicker.minuteInterval = 30
        self.setButtonTitle(date: date, button: self.timeButton)

        self.datePicker.minuteInterval = 1
        self.setButtonTitle(date: date, button: self.dateButton)

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ILLNSStringFromClass(ILLBuyAdvertisementViewController) {
            let vc = segue.destinationViewController as! ILLBuyAdvertisementViewController
            vc.deviceInfo = self.deviceInfo
            vc.startDate = self.startDate()
            vc.endDate = self.datePicker.date
        }
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.dateButton {
            if button != self.currentSettingButton {
                self.setButtonTitle(date: self.startDate(), button: self.currentSettingButton)
            }

            self.currentSettingButton = button
            self.datePicker.datePickerMode = .Date
            self.datePicker.minuteInterval = 1
            self.showDatePicker(button: button)
        }
        else if button == self.timeButton {
            if button != self.currentSettingButton {
                self.setButtonTitle(date: self.startDate(), button: self.currentSettingButton)
            }
            self.datePicker.date = self.startDate()

            self.currentSettingButton = button
            self.datePicker.datePickerMode = .Time
            self.datePicker.minuteInterval = 30
            self.showDatePicker(button: button)
        }
        else if button == self.datePickerButton {
            if self.timeSlotView.hidden {
                self.setButtonTitle(date: self.datePicker.date, button: self.currentSettingButton)
                //self.currentSettingButton = nil
                //self.hideDatePicker()
                if self.currentSettingButton == self.dateButton {
                    self.touchedUpInside(button: self.timeButton)
                }
                else if self.currentSettingButton == self.timeButton {
                    self.touchedUpInside(button: self.findAvailabilitiesButton)
                }
            }
            else {
                self.performSegueWithIdentifier(ILLNSStringFromClass(ILLBuyAdvertisementViewController), sender: self)
            }
        }
        else if button == self.findAvailabilitiesButton {
            let dateComponents = NSDateComponents()
            let calendar = NSCalendar.currentCalendar()
            dateComponents.hour = 1
            let endDate = calendar.dateByAddingComponents(dateComponents, toDate: self.startDate(), options: [])!

            self.datePicker.datePickerMode = .Time
            self.datePicker.minuteInterval = 30
            self.datePicker.date = endDate
            self.showDatePicker(button: button)
        }
        else if button == self.leftBarButton {
            self.navigationController!.popViewControllerAnimated(true)
        }
    }


    /// MARK: - private api

    private func showDatePicker(button button: UIButton) {
        self.timeSlotView.hidden = (button == self.findAvailabilitiesButton) ? false : true
        //self.datePicker.hidden = (self.timeSlotView.hidden) ? false : true
        self.datePickerButton.titleLabel!.font = (self.timeSlotView.hidden) ? UIFont(name: "Helvetica Neue", size: 12.0)! : UIFont(name: "HelveticaNeue-Bold", size: 12.0)!

        UIView.animateWithDuration(
            0.35,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.datePickerView.frame = CGRectMake(0, self.view.frame.height-self.datePickerView.frame.height, self.datePickerView.frame.width, self.datePickerView.frame.height)
            },
            completion: { finished in
            }
        )
    }

    private func hideDatePicker() {
        UIView.animateWithDuration(
            0.25,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.datePickerView.frame = CGRectMake(0, self.view.frame.height, self.datePickerView.frame.width, self.datePickerView.frame.height)
            },
            completion: { [unowned self] finished in
            }
        )
    }

    private func setButtonTitle(date date: NSDate, button: UIButton?) {
        if button == nil { return }

        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .FullStyle

        if button == self.dateButton {
            dateFormatter.dateFormat = "MM/dd/yy"
        }
        else if button == self.timeButton {
            dateFormatter.dateFormat = "HH:mm"
        }
        let title = dateFormatter.stringFromDate(date)
        button!.setTitle(title, forState: .Normal)
    }

    private func startDate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .FullStyle

        dateFormatter.dateFormat = "MM/dd/yyHH:mm"
        return dateFormatter.dateFromString(self.dateButton.titleForState(.Normal)! + self.timeButton.titleForState(.Normal)!)!
    }

}
