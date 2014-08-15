import UIKit

@UIApplicationMain

class PSAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var mainController: PSMainVC? = PSMainVC()

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool
    {
        application!.statusBarHidden = true
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = mainController!
        window!.makeKeyAndVisible()
        
        return true
    }
}