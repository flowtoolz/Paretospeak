import UIKit

@UIApplicationMain

class PSAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var mainController: PSMainVC? = PSMainVC()

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool
    {
        testStuff()

        application!.statusBarHidden = true
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = mainController!
        window!.makeKeyAndVisible()
        
        return true
    }
}

func testStuff()
{
    var testString = "Hallo"
    
    println("length = \(testString.length())")
    
    println(testString[2...4])
    
    println(testString[2])
}
