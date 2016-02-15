import UIKit


/// MARK: - ILLBoardTableViewCell
class ILLBoardTableViewCell: UITableViewCell {

    /// MARK: - property

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dimentionsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var thumbnailImageView: UIImageView!


    /// MARK: - class method

    /**
     * get cell
     * @return CPDArticleBodyTableViewCell
     **/
    class func cell() -> ILLBoardTableViewCell {
        return UINib(nibName: ILLNSStringFromClass(ILLBoardTableViewCell), bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ILLBoardTableViewCell
    }


    /// MARK: - life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    /// MARK: - event listener


    /// MARK: - public api

    /**
     * design
     * @param deviceInfo ILLDeviceInfo
     **/
    func design(deviceInfo deviceInfo: ILLDeviceInfo) {
        self.nameLabel.text = deviceInfo.name
        self.dimentionsLabel.text = deviceInfo.dimentions
        self.locationLabel.text = deviceInfo.location
        self.thumbnailImageView.image = UIImage(named: deviceInfo.imageName)
    }

}
