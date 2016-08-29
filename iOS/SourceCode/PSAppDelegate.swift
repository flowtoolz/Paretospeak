import UIKit
import CoreData

@UIApplicationMain

class PSAppDelegate: UIResponder, UIApplicationDelegate
{
    let coreData = PSCoreData()
    var window: UIWindow?
    var mainController: PSMainVC? = PSMainVC()

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool
    {
        application!.statusBarHidden = true
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = mainController!
        window!.makeKeyAndVisible()
        
        test()
        
        return true
    }
    
    // MARK: Test Core Data
    
    func test()
    {
        //store()
        
        load()
        
        /*
        var successful: Bool = testResult?.valueForKey("wasSuccessful") as Bool
        
        println("was successful: \(successful)")
        */
    }
    
    func store()
    {
        var testResult: PSTranslationTestResult? = NSEntityDescription.insertNewObjectForEntityForName("PSTranslationTestResult", inManagedObjectContext: coreData.context) as? PSTranslationTestResult
        
        if testResult == nil
        {
            println("error: could not load testresult from core data")
            return
        }
        
        //testResult.setValue(true, forKey:"wasSuccessful")
        testResult?.wasSuccessful = true
        
        coreData.context.save(nil)
    }
    
    func load()
    {
        var request = NSFetchRequest(entityName: "PSTranslationTestResult")
        request.returnsObjectsAsFaults = false
        
        var error: NSError?
        
        var results = coreData.context.executeFetchRequest(request, error: &error)
    
        if error != nil
        {
            println("error: fetching failed: " + error!.description)
            return
        }
        
        for result in results!
        {
            let testResult = result as PSTranslationTestResult
            
            let successful = testResult.wasSuccessful //valueForKey("wasSuccessful") as Bool
            
            println("successful = \(successful)")
        }
    }
}



