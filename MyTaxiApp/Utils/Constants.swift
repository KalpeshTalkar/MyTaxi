//
//  Constants.swift
//
//  Created by Kalpesh on 24/05/17.
//  Copyright © 2017 Kalpesh Talkar. All rights reserved.
//

import UIKit

@objc extension UIView {
    
    @objc func applyShadow(_ setShadowPath: Bool = true) {
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 7.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.masksToBounds = false
        if setShadowPath {
            // To improve the performance, set shadow path
            let shadowFrame = layer.bounds
            let shadowPath = UIBezierPath(rect: shadowFrame).cgPath
            layer.shadowPath = shadowPath
        }
    }
    
    @objc func cornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
}

@objc class UIConstants: NSObject {
    @objc class func margin() -> CGFloat { return 15 }
    @objc class func cornerRadius() -> CGFloat { return 10 }
}

@objc class Color: NSObject {
    static let black = UIColor.black
    static let white = UIColor.white
    static let darkGray = UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0)
    static let gray = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
    static let lightGray = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)

    @objc class func background()-> UIColor { return lightGray }
    @objc class func darkText() -> UIColor { return black }
    @objc class func lightText() -> UIColor { return darkGray }
}

@objc class Constants: NSObject {
    @objc class func genericErrorMessage() -> String { return "Some some error occured. Please try again later." }
    @objc class func noInternetMessage() -> String { return "Oops, your connection seems off..." }
    @objc class func noInternetDescription() -> String { return "Please check your internet connection and try again" }
}

struct NotificationName {
    static let YOUR_NOTIFICATION_NAME = NSNotification.Name(rawValue: "YOUR_NOTIFICATION_NAME")
}

typealias JSONObject = Dictionary<String, Any>
typealias JSONArray = Array<JSONObject>

extension Array  {
    func toArray<T:Decodable>(of type: T.Type) -> [T]? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Error123: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Dictionary {
    func to<T:Decodable>(type: T.Type) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}


/// Print logs only in debug mode with file > method > line#
///
/// - Parameters:
///   - items: items to print
///   - fileName: name of the class file
///   - methodName: name of the method from the class file
///   - lineNumber: line number of the method
public func print(items: Any..., fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fn = URL(fileURLWithPath: fileName).lastPathComponent
        let path = "\(fn) > \(methodName) #\(lineNumber)"
        Swift.print("\(path):\n\(items)")
    #endif
}


/// Print logs only in debug mode
///
/// - Parameter items: items to print
public func print(_ items: Any...) {
    #if DEBUG
        Swift.print(items)
    #endif
}

