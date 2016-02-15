import UIKit


/// MARK: - ILLBoardViewController
class ILLBoardViewController: UIViewController {

    /// MARK: - properties

    @IBOutlet weak var leftBarButton: UIButton!
    @IBOutlet weak var rightBarButton: UIButton!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchTextFieldWrapperView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    let deviceInfos = [
        ILLDeviceInfo(name: "Kodak Building", dimentions: "30'x40'", location: "Time Square", price: "$$$", imageName: "Img1"),
        ILLDeviceInfo(name: "Big Chill Fridge", dimentions: "6'x11'", location: "Middle schools", price: "$", imageName: "Fridge"),
        ILLDeviceInfo(name: "Extreme Soccer", dimentions: "1'x1'", location: "Location", price: "$$", imageName: "Cleats"),
        ILLDeviceInfo(name: "Safeway", dimentions: "2'x2'", location: "San Francisco, CA", price: "$$", imageName: "Coffee"),
        ILLDeviceInfo(name: "Serendipity", dimentions: "30'x20'", location: "Las Vegas, NV", price: "$$$", imageName: "Vegas"),
    ]


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.leftBarButton.setImage(
            IonIcons.imageWithIcon(
                ion_android_chat,
                iconColor: UIColor.grayColor(),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )
        // rightbar button
        self.rightBarButton.setImage(
            IonIcons.imageWithIcon(
                ion_navicon,
                iconColor: UIColor.grayColor(),
                iconSize: 32,
                imageSize: CGSizeMake(32, 32)
            ),
            forState: .Normal
        )

        // tableview
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clearColor()

        // search text
        self.searchTextFieldWrapperView.layer.cornerRadius = 8.0
        self.searchTextFieldWrapperView.layer.masksToBounds = true
        self.searchTextFieldWrapperView.clipsToBounds = true
        self.searchTextFieldWrapperView.layer.borderWidth = 2
        self.searchTextFieldWrapperView.layer.borderColor = UIColor.whiteColor().CGColor
        self.searchImageView.image = IonIcons.imageWithIcon(
            ion_ios_search_strong,
            iconColor: UIColor.whiteColor(),
            iconSize: 32,
            imageSize: CGSizeMake(32, 32)
        )

        ILLBluetoothCentral.sharedInstance.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
            ILLBluetoothCentral.sharedInstance.unpairPeripheral()
        }
        ILLBluetoothCentral.sharedInstance.startScanning()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        ILLBluetoothCentral.sharedInstance.stopScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ILLNSStringFromClass(ILLAdvertisementViewController) {
            let vc = segue.destinationViewController as! ILLAdvertisementViewController
            if self.tableView.indexPathForSelectedRow != nil {
                vc.deviceInfo = self.deviceInfos[self.tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
    }


    /// MARK: - event listener

    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.rightBarButton {
            //self.tableView.reloadData()
            ILLBluetoothCentral.sharedInstance.startScanning()
        }
    }
}


/// MARK: - UITableViewDelegate, UITableViewDataSource
extension ILLBoardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return ILLBluetoothCentral.sharedInstance.peripherals.count
        return self.deviceInfos.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = HLVPlaylistTableViewCell.hlv_cell()
        //cell.setPlaylist(self.playlists[indexPath.row])
        //let cell = UITableViewCell()

        //cell.textLabel!.text = ILLBluetoothCentral.sharedInstance.peripherals[indexPath.row].name!

        let cell = ILLBoardTableViewCell.cell()
        cell.backgroundColor = UIColor.clearColor()
        let deviceInfo = self.deviceInfos[indexPath.row]
        cell.design(deviceInfo: deviceInfo)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ILLBluetoothCentral.sharedInstance.peripherals.count == 0 { self.tableView.deselectRowAtIndexPath(indexPath, animated: true); return }
        //let row = indexPath.row
        //if row >= ILLBluetoothCentral.sharedInstance.peripherals.count { self.tableView.deselectRowAtIndexPath(indexPath, animated: true); return }

        let peripheral = ILLBluetoothCentral.sharedInstance.peripherals[0]
        ILLBluetoothCentral.sharedInstance.pairPeripheral(peripheral)

        self.loadingView.hidden = false
        self.indicatorView.startAnimating()
    }

}


// MARK: - ILLBluetoothCentralDelegate
extension ILLBoardViewController: ILLBluetoothCentralDelegate {

    func didDiscoverPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral) {
        //self.tableView.reloadData()
    }

    func didPairPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral) {
        self.indicatorView.stopAnimating()
        self.loadingView.hidden = true
        self.performSegueWithIdentifier(ILLNSStringFromClass(ILLAdvertisementViewController), sender: self)
    }

    func didUnpairPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral) {
        self.indicatorView.stopAnimating()
        self.loadingView.hidden = true

        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        }

    }

}
