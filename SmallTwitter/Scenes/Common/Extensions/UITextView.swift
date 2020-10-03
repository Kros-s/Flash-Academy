//
//  UITextView.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 24/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

extension UITextView {
    func addDoneButtonOnKeyboard(){
        let size = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let doneToolbar: UIToolbar = UIToolbar(frame: .init(origin: .zero,
                                                            size: size))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        resignFirstResponder()
    }
}
