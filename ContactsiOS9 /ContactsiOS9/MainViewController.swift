
//

import UIKit
import Contacts
import ContactsUI

class MainViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var store = CNContactStore()
    var contacts: [CNContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK: - User Actions
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        if let query = textField.text {
            findContactsWithName(query)
        }
    }

//MARK: - Private Methods
    
    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus({ (accessGranted) -> Void in
            if accessGranted {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContactsMatchingName(name)
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactViewController.descriptorForRequiredKeys()]
                        self.contacts = try self.store.unifiedContactsMatchingPredicate(predicate, keysToFetch:keysToFetch)
                        print("store values %@", self.store)
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }

}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
        cell!.textLabel!.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        
        if let birthday = contacts[indexPath.row].birthday {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .NoStyle
        
            cell!.detailTextLabel?.text = formatter.stringFromDate((birthday.date)!)
        }
        return cell!
    }
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = CNContactViewController(forContact: contacts[indexPath.row])
        controller.contactStore = self.store
        controller.allowsEditing = false
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
