//
//  AlertUtils.swift
//
//  Created by Kalpesh on 11/04/17.
//  Copyright © 2017 Kalpesh Talkar. All rights reserved.
//

import UIKit

class AlertUtils {

    /// action block for UIAlertController
    typealias Alert_Action_Block = (_ isPositiveAction: Bool) -> (Void)

    /// Default duration for toast
    private static let Default_Toast_Duration = 2.0

    /// Presents alert view with Okay button
    ///
    /// - parameter title:          alert title
    /// - parameter message:        alert description
    /// - parameter viewController: controller in which to present the alert
    /// - parameter actionBlock:    OK button action
    static func showAlertWith(title: String?, message: String?, viewController: UIViewController?, actionBlock: Alert_Action_Block? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            if nil != actionBlock {
                actionBlock!(true)
            }
        })
        alertController.addAction(okAction)
        if nil == viewController {
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            viewController!.present(alertController, animated: true, completion: nil)
        }
    }

    /// Presents alert with default and destructive actions
    ///
    /// - parameter title:               alert title
    /// - parameter message:             alert message
    /// - parameter positiveActionTitle: default action title
    /// - parameter negativeActionTitle: destruvctive action title
    /// - parameter viewController:      controller in which alert is to be presented
    /// - parameter actionBlock:         action button click
    static func showAlert(title: String?, message: String?, positiveActionTitle: String, negativeActionTitle: String, viewController: UIViewController?, actionBlock: Alert_Action_Block?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let positiveAction = UIAlertAction(title: positiveActionTitle, style: UIAlertAction.Style.default, handler: { (action) in
            if nil != actionBlock {
                actionBlock!(true)
            }
        })
        let negativeAction = UIAlertAction(title: negativeActionTitle, style: UIAlertAction.Style.destructive, handler: { (action) in
            if nil != actionBlock {
                actionBlock!(false)
            }
        })
        alertController.addAction(positiveAction)
        alertController.addAction(negativeAction)
        if nil == viewController {
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            viewController!.present(alertController, animated: true, completion: nil)
        }
    }

    /// Presents UIAlertController as a toast for specified duration
    /// if the duration is nil, it takes the default duration of 2 sec.
    ///
    /// - parameter title:          toast title
    /// - parameter message:        toast message
    /// - parameter duration:       duration of toast
    /// - parameter viewController: controller in which the toast is to be shown
    static func showToast(title: String?, message: String?, duration: Double? = nil, viewController: UIViewController?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if nil == viewController {
            UIApplication.shared.delegate?.window??.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            viewController!.present(alertController, animated: true, completion: nil)
        }
        let d =  (nil == duration) ? Default_Toast_Duration : duration!
        DispatchQueue.main.asyncAfter(deadline: .now() + d) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}
