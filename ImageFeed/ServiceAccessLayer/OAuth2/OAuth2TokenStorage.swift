import Foundation
import SwiftKeychainWrapper

private extension String {
    static let bearerToken = "bearerToken"
}

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
    func removeToken()
    func clearToken()
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private let keychainStorage = KeychainWrapper.standard
        
    var token: String? {
        get {
            keychainStorage.string(forKey: .bearerToken)
        }
        set {
            guard let token = newValue else {
                keychainStorage.removeObject(forKey: .bearerToken)
                return
            }
            keychainStorage.set(token, forKey: .bearerToken)
        }
    }
    
    func removeToken() {
        keychainStorage.removeObject(forKey: .bearerToken)
    }
    
    func clearToken() {
        keychainStorage.removeAllKeys()
    }
}
