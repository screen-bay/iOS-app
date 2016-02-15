import Foundation


/// MARK: - NSMutableURLRequest+HTTPBody
extension NSMutableURLRequest {

    /// MARK: - public api

    /**
     * set httpbody
     * @param dictionary dictionary
     */
    func wst_setHTTPBody(queries: Dictionary<String, AnyObject>) {
        let json = JSON(queries)
        var body: NSData? = nil
        do { body = try json.rawData() }
        catch _ { }

        self.HTTPBody = body
        if body != nil { self.setValue("\(body!.length)", forHTTPHeaderField:"Content-Length") }
    }


    /// MARK: - private api
}
