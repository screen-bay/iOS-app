import CoreBluetooth


// MARK: - ILLBluetoothCentralDelegate
@objc protocol ILLBluetoothCentralDelegate {

    /**
     * called when peripheral is discovered
     * @param bluetoothCentral ILLBluetoothCentral
     */
    func didDiscoverPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral)

    /**
     * called when peripheral is paired
     * @param bluetoothCentral ILLBluetoothCentral
     */
    func didPairPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral)

    /**
     * called when peripheral is unpaired
     * @param bluetoothCentral ILLBluetoothCentral
     */
    func didUnpairPeripheral(bluetoothCentral bluetoothCentral: ILLBluetoothCentral)

}


/// MARK: - ILLBluetoothCentral
class ILLBluetoothCentral: NSObject {

    /// MARK: - properties

    static let sharedInstance = ILLBluetoothCentral()

    var centralManager: CBCentralManager!
    var readyToScan = false
    var targetPeripheral: CBPeripheral?
    var pairedPeripheral: CBPeripheral?
    var peripherals: [CBPeripheral] = []

    weak var delegate: AnyObject?


    /// MARK: - initialization

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }


    /// MARK: - public api

    /**
     * start scanning peripherals
     * @return success or failure Bool
     **/
    func startScanning() -> Bool {
        if !self.readyToScan { return false }

        self.centralManager.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        return true
    }

    /**
     * stop scanning peripherals
     **/
    func stopScanning() {
        self.centralManager.stopScan()
    }

    /**
     * pair peripheral
     * @param aPeripheral CBPeripheral
     **/
    func pairPeripheral(aPeripheral: CBPeripheral) {
        self.targetPeripheral = aPeripheral
        aPeripheral.delegate = self
        self.centralManager.connectPeripheral(aPeripheral, options: nil)
    }

    /**
     * unpair peripheral
     **/
    func unpairPeripheral() {
        if self.targetPeripheral != nil { self.centralManager.cancelPeripheralConnection(self.targetPeripheral!) }
        self.targetPeripheral = nil
        self.pairedPeripheral = nil
        self.peripherals = []

        if self.delegate != nil {
            (self.delegate as! ILLBluetoothCentralDelegate).didUnpairPeripheral(bluetoothCentral: self)
        }
    }

    /**
     * write value to pairedPeripheral
     * @param data NSData
     * @param characteristicUUIDString characteristic UUID
     * @return can write?
     **/
    func writeValueToPairedPeripheral(data data: NSData, characteristicUUIDString: String) -> Bool {
        if self.pairedPeripheral == nil { return false }
        if self.pairedPeripheral!.services == nil { return false }

        // search characteristic to write
        var characteristicToWrite: CBCharacteristic? = nil
        for service in self.pairedPeripheral!.services! {
            if service.characteristics == nil { continue }
            for characteristic in service.characteristics! {
                if characteristic.UUID.UUIDString != characteristicUUIDString { continue }
                characteristicToWrite = characteristic
                break
            }
        }
        if characteristicToWrite == nil { return false }

        self.pairedPeripheral!.writeValue(data, forCharacteristic: characteristicToWrite!, type: .WithResponse)
        return true
    }

}


/// MARK: - CBPeripheralDelegate
extension ILLBluetoothCentral: CBPeripheralDelegate {

    func peripheralDidUpdateName(peripheral: CBPeripheral) {
    }

    func peripheral(peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    }

    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil { return }
        if self.targetPeripheral != peripheral { return }
        if peripheral.services == nil { return }

        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CBUUID(string: ILLIBoard.Play.Characteristic.UUIDString)], forService: service)
        }
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverIncludedServicesForService service: CBService, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error != nil { return }
        if self.targetPeripheral != peripheral { return }
        if service.characteristics == nil { return }

        self.peripherals = [peripheral]
        self.pairedPeripheral = peripheral
        if self.delegate != nil {
            (self.delegate as! ILLBluetoothCentralDelegate).didPairPeripheral(bluetoothCentral: self)
        }
  }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        ILLLOG(error)

        // post notification
        let notificationString = (error != nil) ? ILLNotificationCenter.DidSucceedBluetoothWriting : ILLNotificationCenter.DidFailBluetoothWriting
        NSNotificationCenter.defaultCenter().postNotificationName(notificationString, object: nil, userInfo: [:])
    }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
    }

    func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
    }

}


/// MARK: - ILLBluetoothCentral
extension ILLBluetoothCentral: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
            case .PoweredOn:
                self.readyToScan = true
                self.startScanning()
            case .Unknown, .Resetting, .Unsupported, .Unauthorized, .PoweredOff:
                self.readyToScan = false
                self.unpairPeripheral()
        }
    }

    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
    }

    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        // check if it's a i-board
        if peripheral.name == nil { return }
        var isIBoard = false
        for deviceName in ILLIBoard.Names {
            if peripheral.name! == deviceName { isIBoard = true; break }
        }
        if !isIBoard { return }

        // renew peripheral
        var renewingIndex = -1
        for var i = 0; i < self.peripherals.count; i++ {
            let p = self.peripherals[i]
            if p.identifier.UUIDString == peripheral.identifier.UUIDString { renewingIndex = i; break }
        }
        let newPeripheral = peripheral
        if renewingIndex < 0 { self.peripherals.append(newPeripheral) } // new peripheral
        else { self.peripherals[renewingIndex] = newPeripheral }        // swap peripherals

        // sort
        self.peripherals = self.peripherals.sort { "\($0.name)".localizedCaseInsensitiveCompare("\($1.name)") == NSComparisonResult.OrderedAscending }

        // delegate
        if self.delegate != nil {
            (self.delegate as! ILLBluetoothCentralDelegate).didDiscoverPeripheral(bluetoothCentral: self)
        }
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        if self.targetPeripheral != peripheral { return }
        peripheral.discoverServices([CBUUID(string: ILLIBoard.Play.Service.UUIDString)])
    }

    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        self.unpairPeripheral()
    }

    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        self.unpairPeripheral()
    }

}
