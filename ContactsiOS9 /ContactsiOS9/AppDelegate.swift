

import UIKit
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var store = CNContactStore()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func checkAccessStatus(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
            case .Authorized:
                completionHandler(accessGranted: true)
            case .Denied, .NotDetermined:
                self.store.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                    if access {
                        completionHandler(accessGranted: access)
                    }
                    else {
                        print("access denied")
                    }
                })
            default:
                completionHandler(accessGranted: false)
        }
    }

}
