//
//  ContactListViewController.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit

class ContactListViewController: UITableViewController {
    
    var contacts: [Contact] = [
        Contact(name: "Hoang Hai", phoneNumber: "0123456789", email: "hai@example.com", image: "avatar1")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destination = segue.destination as? ContactDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedContact = contacts[indexPath.row]
        }
    }
}
