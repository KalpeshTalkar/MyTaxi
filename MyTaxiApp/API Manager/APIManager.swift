//
//  APIManager.swift
//
//  Created by Kalpesh on 31/05/17.
//  Copyright © 2017 Kalpesh Talkar. All rights reserved.
//

//import MBProgressHUD
import Alamofire

/// Server request object
class APIRequest {


    /// Request url
    var url = String()

    /// Shos activity indicator of true
    var showIndicator = true

    /// View in which the activity indicator will be shown
    var viewForIndicator: UIView? {
        didSet {
            showIndicator = (viewForIndicator != nil)
        }
    }

    /// Request method
    var method = HTTPMethod.get

    /// Parameters to be passed with the request
    var parameters: Dictionary<String,Any>?

    /// Headers to be passed with the request
    var headers: Dictionary<String,String>?

    /// Timeout for request
    var requestTimeout: TimeInterval?

    /// Display error in alert controller if any
    var showError: Bool = true


    /// Default init method
    init() {
    }

    /// Initialize the object
    ///
    /// - Parameters:
    ///   - url: request url
    ///   - method: request method
    ///   - showIndicator: shows activity indicator if true
    init(url: String, method: HTTPMethod, viewForIndicator: UIView? = nil) {
        self.url = url
        self.viewForIndicator = viewForIndicator
        self.method = method
    }

}

/// Response headers type
typealias ResponseHeaders = [AnyHashable : Any]

/// Response closure
typealias APIResponse = (_ responseJSON: Any?, _ responseHeaders: ResponseHeaders?, _ error: String?) -> Void

class APIManager {


    /// Default request timeout interval
    fileprivate static let Default_Timeout: TimeInterval = 60


    /// Make server request
    ///
    /// - Parameters:
    ///   - request: request object containg url and method
    ///   - apiResponse: response received from the server
    static func request(_ apiRequest: APIRequest, apiResponse: APIResponse?) {
        // Check if request has headers
        if nil == apiRequest.headers {
            apiRequest.headers = Dictionary<String,String>()
        }
        // Set token if not set
        //apiRequest.headers!["X-AUTH-TOKEN"] = "TOKEN_HERE"

        // Check if request has parameters
        if nil == apiRequest.parameters {
            apiRequest.parameters = Dictionary<String,Any>()
        }
        // Set response type
        apiRequest.parameters!["responseType"] = "json"
        
        // Get the session manager
        let manager = Alamofire.SessionManager.default

        // Set request timeout
        manager.session.configuration.timeoutIntervalForRequest = apiRequest.requestTimeout ?? Default_Timeout
        // Make server request
        manager.request(apiRequest.url, method: apiRequest.method, parameters: apiRequest.parameters, encoding: URLEncoding.default, headers: apiRequest.headers).responseJSON { (dataResponse) in
            let error = dataResponse.error
            var errorDescription:String? = nil
            if nil != error {
                print(items: "Error: \(error!)")
                errorDescription = error!.localizedDescription
            } else {
                if let responseJSON = dataResponse.value {
                    // Check for authentication failure
                    if responseJSON is JSONObject {
                        let responseDict = responseJSON as! JSONObject
                        if let errorDesc = responseDict["error"] as? String {
                            errorDescription = errorDesc
                            print("Authentication failure. Reason: \(errorDesc)")
                            // Token expired or authorisation failed
                            // Delete user data and ask for login
                            //User.logout(isTokenExpired: true)
                        }
                    }
                } else {
                    errorDescription = Constants.genericErrorMessage()
                    print(items: "No response received from server.")
                }
            }
            // Call the completion handler
            if nil != apiResponse {
                apiResponse!(dataResponse.result.value, dataResponse.response?.allHeaderFields, errorDescription)
            }
            // Show error if required
            if nil != errorDescription && apiRequest.showError {
                AlertUtils.showAlertWith(title: "Error", message: errorDescription!, viewController: nil)
            }
        }
    }


    /// Make server request
    ///
    /// - Parameters:
    ///   - url: request url
    ///   - method: request method
    ///   - showIndicator: shows activity indicator if true
    ///   - apiResponse: response received from the server
    static func request(url: String, method: HTTPMethod, parameters: Dictionary<String,Any>?, showIndicatorInView: UIView? = nil, apiResponse: APIResponse?) {
        let apiRequest = APIRequest(url: url, method: method, viewForIndicator: showIndicatorInView)
        apiRequest.viewForIndicator = showIndicatorInView
        apiRequest.parameters = parameters
        request(apiRequest, apiResponse: apiResponse)
    }
    
    func request(_ apiRequest: APIRequest, apiResponse: APIResponse?) {
        // Check if request has headers
        if nil == apiRequest.headers {
            apiRequest.headers = Dictionary<String,String>()
        }
        // Set token if not set
        //apiRequest.headers!["X-AUTH-TOKEN"] = "TOKEN_HERE"

        // Check if request has parameters
        if nil == apiRequest.parameters {
            apiRequest.parameters = Dictionary<String,Any>()
        }
        // Set response type
        apiRequest.parameters!["responseType"] = "json"

        // Get the session manager
        let manager = Alamofire.SessionManager.default

        // Set request timeout
        manager.session.configuration.timeoutIntervalForRequest = apiRequest.requestTimeout ?? APIManager.Default_Timeout
        // Make server request
        manager.request(apiRequest.url, method: apiRequest.method, parameters: apiRequest.parameters, encoding: URLEncoding.default, headers: apiRequest.headers).responseJSON { (dataResponse) in
            let error = dataResponse.error
            var errorDescription:String? = nil
            if nil != error {
                print(items: "Error: \(error!)")
                errorDescription = error!.localizedDescription
            } else {
                if let responseJSON = dataResponse.value {
                    // Check for authentication failure
                    if responseJSON is JSONObject {
                        let responseDict = responseJSON as! JSONObject
                        if let errorDesc = responseDict["error"] as? String {
                            errorDescription = errorDesc
                            print("Authentication failure. Reason: \(errorDesc)")
                            // Token expired or authorisation failed
                            // Delete user data and ask for login
                            //User.logout(isTokenExpired: true)
                        }
                    }
                } else {
                    errorDescription = Constants.genericErrorMessage()
                    print(items: "No response received from server.")
                }
            }
            // Call the completion handler
            if nil != apiResponse {
                apiResponse!(dataResponse.result.value, dataResponse.response?.allHeaderFields, errorDescription)
            }
            // Show error if required
            if nil != errorDescription && apiRequest.showError {
                AlertUtils.showAlertWith(title: "Error", message: errorDescription!, viewController: nil)
            }
        }
    }

}
