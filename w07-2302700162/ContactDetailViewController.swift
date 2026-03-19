//
//  ContactDetailViewController.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!

    var selectedContact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        if let contact = selectedContact {
            nameTextField.text = contact.name
            phoneTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            avatarImageView.image = UIImage(named: contact.image)
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Xử lý logic lưu dữ liệu tại đây
        navigationController?.popViewController(animated: true)
    }
}
