//
//  PasswordManaging.swift
//  RSNumberPad
//
//  Created by devxsby on 2023/07/06.
//

import Foundation
import CryptoKit

public protocol PasswordManaging {
    func savePassword(key: String, password: String)
    func checkPassword(key: String, password: String) -> Bool
}

extension PasswordManaging {
    public func savePassword(key: String, password: String) {
        let hashedPassword = generateHash(from: password)
        let result = KeychainManager.save(key: key, data: hashedPassword)
        
        switch result {
        case .success():
            debugPrint("Password saved successfully.")
        case .failure(let error):
            debugPrint("Failed to save password: \(error.localizedDescription)")
        }
    }
    
    public func checkPassword(key: String, password: String) -> Bool {
        let hashedPassword = generateHash(from: password)
        let result = KeychainManager.load(key: key)
        
        switch result {
        case .success(let savedPassword):
            return hashedPassword == savedPassword
        case .failure(let error):
            debugPrint("Failed to load password: \(error.localizedDescription)")
            return false
        }
    }
    
    func generateHash(from string: String) -> String {
        let inputData = Data(string.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashedString
    }
}
