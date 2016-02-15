/// MARK: - LOG

/**
 * display log
 * @param body log
 */
func ILLLOG(body: Any, function: String = __FUNCTION__, line: Int = __LINE__) {
#if DEBUG
    print("[\(function) : \(line)] : \(NSThread.currentThread())")
    print("\(body)\n")
#endif
}


/// MARK: - function

/**
 * return class name
 * @param classType classType
 * @return class name
 */
func ILLNSStringFromClass(classType:AnyClass) -> String {
    let classString = NSStringFromClass(classType.self)
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
}


/// MARK: - User Defaults

struct ILLUserDefaults {
    //static let DemoCSV =            "ILLUserDefaults.DemoCSV"
}


/// MARK: - NotificationCenter

struct ILLNotificationCenter {
    static let DidSucceedBluetoothWriting =         "ILLNotificationCenter.DidSucceedBluetoothWriting"
    static let DidFailBluetoothWriting =            "ILLNotificationCenter.DidFailBluetoothWriting"
}


/// MARK: - ILLIBoard

struct ILLIBoard {

    // device names
    static let Names =    [
        "i-board",
        "kenzan8000",
        "raspberrypi",
    ]

    // play
    struct Play {
        struct Service {
            static let UUIDString =         "8000"
        }
        struct Characteristic {
            static let UUIDString =         "8001"
        }
        struct Action {
            static let PlayStart =       "i-board play start"
            static let PlayDone =        "i-board play done"
            static let Stop =            "i-board stop"
        }
    }
}
