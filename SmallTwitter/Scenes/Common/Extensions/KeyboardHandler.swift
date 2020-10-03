//
//  KeyboardHandler.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 25/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol KeyboardHandler {
    func setKeyboardHandler()
    func removeKeyboardHandler()
}

extension KeyboardHandler where Self: UIViewController {
    func setKeyboardHandler() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(sender: notification as NSNotification)
        }
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillHide(sender: notification as NSNotification)
        }
    }
    
    func removeKeyboardHandler() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
