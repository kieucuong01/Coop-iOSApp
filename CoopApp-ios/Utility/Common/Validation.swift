
//
//  Validations.swift
//  Validations
//
//  Created by Sierra 2 on 14/09/17.
//  Copyright © SandsHellCreations. All rights reserved.
//  https://github.com/SandeepSpider811
import Foundation

enum Alert {
    case success
    case failure
    case error
}

enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

enum ValidationType {
    case email
    case phoneNo
    case alphabeticNNumber
    case password
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{1,40}$" // Password length 8-40
    case alphabeticNNumber = "^[0-9a-zA-Z_]*$" // e.g. hello sandeep
    case phoneNo = "[0-9]{10,14}" // PhoneNo 10-14 Digits

    //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidEmail = "error_wrong_format_email"
    case inValidPhone = "error_wrong_format_phone"
    case invalidAlphabeticNNumber = "error_common"
    case inValidPSW = "error_wrong_format_password"

    case emptyPhone = "error_empty_phone"
    case emptyEmail = "error_empty_email"
    case emptyAlphabeticNNumber = "error_empty_text"
    case emptyPSW = "error_empty_password"
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class Validation: NSObject {

    public static let shared = Validation()

    func validate(values: [(type: ValidationType, inputValue: String)]) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .email, .emptyEmail, .inValidEmail)) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return tempValue
                }
            case .alphabeticNNumber:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticNNumber, .emptyAlphabeticNNumber, .invalidAlphabeticNNumber)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .password, .emptyPSW, .inValidPSW)) {
                    return tempValue
                }
            }
        }
        return .success
    }

    func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }

    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}
