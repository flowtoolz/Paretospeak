import CoreData

class PSTranslationTestResult: NSManagedObject
{
    @NSManaged var wasSuccessful: Bool
    @NSManaged var translation: NSManagedObject
}