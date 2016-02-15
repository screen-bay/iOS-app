　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　/// MARK: - ILLBluetoothWritingOperation
class ILLBluetoothWritingOperation: NSOperation {

    /// MARK: - property

    var data: NSData!
    var completionHandler: (error: NSError?) -> Void

    // executing operation?
    override var executing : Bool {
        get { return _executing }
        set {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    private var _executing : Bool = false

    // finished operation?
    override var finished : Bool {
        get { return _finished }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    private var _finished : Bool = false


    /// MARK: - class method

//    override class func automaticallyNotifiesObserversForKey(key: String) -> Bool {
//        if key == "isExecuting" || key == "isFinished" {
//            return true
//        }
//
//        return automaticallyNotifiesObserversForKey(key)
//    }


    /// MARK: - initialization

    /**
     * constructor
     * @param data data to write
     * @param completionHandler (error: NSError?) -> Void
     **/
    init(data: NSData, completionHandler: (error: NSError?) -> Void) {
        self.data = data
        self.completionHandler = completionHandler
        super.init()
    }


    /// MARK: - destruction

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    /// MARK: - notification

    func didSucceedBluetoothWriting(notification: NSNotification) {
        self.end(error: nil)
    }

    func didFailBluetoothWriting(notification: NSNotification) {
        self.end(error: nil)
    }


    /// MARK: - public api

    override func start() {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
            // cancelled?
            if self.cancelled { self.finished = true; return }

            // start
            self.executing = true
            let canWrite = ILLBluetoothCentral.sharedInstance.writeValueToPairedPeripheral(data: self.data, characteristicUUIDString: ILLIBoard.Play.Characteristic.UUIDString)
            if !canWrite { self.end(error: nil) }

            // notification
            let notificationSelectors = [Selector("didSucceedBluetoothWriting:"), Selector("didFailBluetoothWriting:")]
            let notificationNames = [ILLNotificationCenter.DidSucceedBluetoothWriting, ILLNotificationCenter.DidFailBluetoothWriting]
            for var i = 0; i < notificationSelectors.count; i++ {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: notificationSelectors[i], name: notificationNames[i], object: nil)
            }
        })
    }


    /// MARK: - private api

    /**
     * end operation
     * @param error NSError?
     **/
     private func end(error error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
            NSNotificationCenter.defaultCenter().removeObserver(self)
            self.completionHandler(error: error)
            self.executing = false
            self.finished = true
        })
     }

}
