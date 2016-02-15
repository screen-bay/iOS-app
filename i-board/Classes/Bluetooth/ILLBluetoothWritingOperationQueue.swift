// MARK: - ILLBluetoothWritingOperationQueue
class ILLBluetoothWritingOperationQueue: NSOperationQueue {

    /// MARK: - property

    static let sharedInstance = ILLBluetoothWritingOperationQueue()


    /// MARK: - initialization


    /// MARK: - public

    /**
     * play image
     * @param data data to write
     * @param fileName String
     * @param completionHandler (error: NSError?) -> Void
     **/
    func play(data data: NSData, fileName: String, completionHandler: (error: NSError?) -> Void) {
        self.cancelAllOperations()
        self.maxConcurrentOperationCount = 1

        let handler = { [unowned self] (error error: NSError?) -> Void in
            if error == nil { return }
            completionHandler(error: error)
            self.cancelAllOperations()
        }

        // start
        do {
            let data = try JSON(["action" : ILLIBoard.Play.Action.PlayStart, "file" : fileName,]).rawData()
            self.addOperation(ILLBluetoothWritingOperation(data: data, completionHandler: handler))
        }
        catch { return handler(error: nil) }

        // send image
        let datas = data.splitedDatas(size: 128)
        for var i = 0; i < datas.count; i++ {
            self.addOperation(ILLBluetoothWritingOperation(data: datas[i], completionHandler: handler))
        }

        // end
        do {
            let data = try JSON(["action" : ILLIBoard.Play.Action.PlayDone,]).rawData()
            self.addOperation(ILLBluetoothWritingOperation(data: data, completionHandler: completionHandler))
        }
        catch { return handler(error: nil) }
    }
}
