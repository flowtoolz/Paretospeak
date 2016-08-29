import CoreData

class PSCoreData
{
    private var model:          NSManagedObjectModel!
    private var coordinator:    NSPersistentStoreCoordinator!
    var         context:        NSManagedObjectContext!
    
    init()
    {
        model = PSCoreData.createModel()
        coordinator = PSCoreData.createCoordinator(model)
        context = PSCoreData.createContex(coordinator)
        PSCoreData.addStore("ParetoSpeak", coordinator: coordinator)
    }
    
    private class func createContex(coordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext
    {
        let new_context = NSManagedObjectContext()
        new_context.persistentStoreCoordinator = coordinator
        return new_context
    }
    
    private class func addStore(name: String, coordinator: NSPersistentStoreCoordinator)
    {
        let storeURL = PSCoreData.getStoreURL(name)
        
        var error: NSError? = nil
        
        let new_store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: nil,
            error: &error)
        
        assert(new_store != nil, "error: could not create persistent store")
    }
    
    private class func getStoreURL(name: String) -> NSURL
    {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = urls.last as NSURL
        return storeURL.URLByAppendingPathComponent(name + ".sqlite")
    }
    
    private class func createCoordinator(model: NSManagedObjectModel) -> NSPersistentStoreCoordinator
    {
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        return storeCoordinator
    }
    
    private class func createModel() -> NSManagedObjectModel
    {
        let new_model = NSManagedObjectModel.mergedModelFromBundles(nil)
        assert(new_model != nil, "error: object model cannot be created")
        return new_model!
    }
}







