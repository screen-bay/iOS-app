import UIKit
import MagnetMax


/// MARK: - AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// MARK: - properties

    var window: UIWindow?


    /// MARK: - life cycle

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // magnet
        let configurationFile = NSBundle.mainBundle().pathForResource("MagnetMax", ofType: "plist")
        let configuration = MMPropertyListConfiguration(contentsOfFile: configurationFile!)
        MagnetMax.configure(configuration!)
            // login
        let username = "kzn8000"
        let password = "12345678"
        let credential = NSURLCredential(user: username, password: password, persistence: .None)
        MMUser.login(credential,
            success: {
                print(MMUser.currentUser())
                MagnetMax.initModule(MMX.sharedInstance(),
                    success: {
                        ILLLOG("success")
                    },
                    failure: { error in
                        ILLLOG("\(error)")
                })
            },
            failure: { error in
                ILLLOG(error.localizedDescription)
            }
        )
            // Indicate that you are ready to receive messages now!
        MMX.start()
        NSNotificationCenter.defaultCenter().addObserver(
           self,
           selector: "didReceiveMessage:",
           name: MMXDidReceiveMessageNotification,
           object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
           self,
           selector: "didReceiveChannelInvite:",
           name: MMXDidReceiveChannelInviteNotification,
           object: nil)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


    func didReceiveMessage(notification: NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let message = userInfo[MMXMessageKey] as! MMXMessage
        ILLLOG(message.messageContent)

            let image = ILLBuyAdvertisementViewController.imageFromString(message.messageContent["message"]! as String, font: UIFont(name: "Helvetica Neue", size: 12)!)
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

    func didReceiveChannelInvite(notification: NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let invite = userInfo[MMXInviteKey] as! MMXInvite
        ILLLOG(invite)
    }
}
