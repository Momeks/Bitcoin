//
//  Obfuscator.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/24/25.
//

import Foundation

/// Obfuscator
class QrdlWPgAD4V0cSHcjTWvCQ: NSObject {

    // MARK: - Variables

    /// The salt used to obfuscate and reveal the string.
    private var salt: String

    // MARK: - Initialization

    override public init() {
        self.salt = "20ne9s"
        super.init()
    }

    static let shared = QrdlWPgAD4V0cSHcjTWvCQ()

    // MARK: - Instance Methods

    /**
     *bytesByObfuscatingString(_ string: String)*

     This method obfuscates the string passed in using the salt
     that was used when the Obfuscator was initialized.

     - parameter string: the string to obfuscate

     - returns: the obfuscated string in a byte array
     */
    func ivY5KMZlia1UO6RSZf8WL6v1ms8AZsf(_ string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count

        var encrypted = [UInt8]()

        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }

        return encrypted
    }

    /**
     *reveal(key: [UInt8]) -> String*

     This method reveals the original string from the obfuscated
     byte array passed in. The salt must be the same as the one
     used to encrypt it in the first place.

     - parameter key: the byte array to reveal

     - returns: the original string
     */
    func wsM03n0ifeFVaSF1kvquZw(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count

        var decrypted = [UInt8]()

        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }

        return String(bytes: decrypted, encoding: .utf8)!
    }
}
