/// MARK: - NSData+Extension
extension NSData {

    /// MARK: - public api

    /**
     * split data into data array
     * @param size data size Int
     * @return [NSData]
     **/
    func splitedDatas(size size: Int) -> [NSData] {
        var splitedDatas: [NSData] = []
        if self.length == 0 { return splitedDatas }

        var range = NSRange(location: 0, length: size)
        while range.location < self.length {
            if range.location+range.length >= self.length { range.length = self.length-range.location }
            let data = self.subdataWithRange(range)
            splitedDatas.append(data)
            range.location += size
        }

        return splitedDatas
    }

}
