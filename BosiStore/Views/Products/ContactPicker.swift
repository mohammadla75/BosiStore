//
//  ContactPicker.swift
//  LuxuryStore
//
//  Created by MAC on 3/4/1405 AP.
//

import SwiftUI
import ContactsUI
import MessageUI

// MARK: - Contact Picker
struct ContactPicker: UIViewControllerRepresentable {
    @Binding var selectedPhone: String?
    @Binding var showMessageComposer: Bool
    @Binding var showWarning: Bool
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPicker
        
        init(_ parent: ContactPicker) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                parent.selectedPhone = phoneNumber
                
                if MFMessageComposeViewController.canSendText() {
                    parent.showMessageComposer = true
                } else {
                    parent.showWarning = true
                }
            }
        }
    }
}

// MARK: - Message Composer
struct MessageComposer: UIViewControllerRepresentable {
    var phoneNumbers: [String]
    var message: String
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.recipients = phoneNumbers
        composer.body = message
        composer.messageComposeDelegate = context.coordinator
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposer
        
        init(_ parent: MessageComposer) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
            parent.dismiss()
        }
    }
}
