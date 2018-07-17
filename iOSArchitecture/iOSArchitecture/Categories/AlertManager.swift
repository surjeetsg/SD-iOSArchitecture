//
//  AlertManager.swift
//  Test_Rest_Library
//
//  Created by Sumeet Jain on 26/08/16.
//  Copyright © 2016 Sumit Jain. All rights reserved.
//

import UIKit

public typealias BlankBlock = () -> Void

open class AlertButton: Any {
    fileprivate(set) var style = UIAlertActionStyle.default
    fileprivate(set) var title = "OK"
    fileprivate(set) var buttonClicked: BlankBlock? = nil
    
    init(style: UIAlertActionStyle = .default, title: String = "OK", buttonClicked: BlankBlock? = nil) {
        self.style = style
        self.title = title
        self.buttonClicked = buttonClicked
    }
}

open class AlertManager: Any {
    
    public typealias ButtonClickedResponse = (_ clickedIndex: Int) -> Void
    
    //MARK: ALERT VIEW
    open class func showOKAlert(_ type: UIAlertActionStyle = .default, withTitle title: String?, withMessage message: String?, onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock: ButtonClickedResponse? = nil) -> UIAlertController {
        return showAlertWithSimilarButtonsType(type, withTitle: title, withMessage: message, buttonsTitles: ["OK"], onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showAlertWithSimilarButtonsType(_ type: UIAlertActionStyle = .default, withTitle title: String?, withMessage message: String?, buttonsTitles:[String], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock: ButtonClickedResponse? = nil) -> UIAlertController {
        var actions = [AlertButton]()
        for title in buttonsTitles {
            actions.append(AlertButton(style: type, title: title))
        }
        
        return showAlert(withTitle: title, withMessage: message, buttons: actions, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showAlert(withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        return _presentWithStyle(.alert, withTitle: title, withMessage: message, buttons: buttons, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    //MARK: IMPLEMENTATION
    fileprivate class func _presentWithStyle(_ style: UIAlertControllerStyle, withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, button) in buttons.enumerated() {
            let action = UIAlertAction(title: button.title, style: button.style, handler: { (action) in
                if let buttonButtonClicked = button.buttonClicked {
                    buttonButtonClicked()
                }
                if let returnBlock = returnBlock {
                    returnBlock(index)
                }
            })
            
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            vc.present(alert, animated: animatedly, completion: presentationCompletionHandler)
        }
        
        return alert
    }
    
    //MARK: ACTION SHEET
    open class func showActionSheet(withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        return _presentWithStyle(.actionSheet, withTitle: title, withMessage: message, buttons: buttons, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showActionSheetWithSimilarButtonsType(_ type: UIAlertActionStyle = .default, withTitle title: String?, withMessage message: String?, buttonsTitles:[String], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock:@escaping ButtonClickedResponse) -> UIAlertController {
        var actions = [AlertButton]()
        for title in buttonsTitles {
            actions.append(AlertButton(style: type, title: title))
        }
        
        return showActionSheet(withTitle: title, withMessage: message, buttons: actions, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
}
