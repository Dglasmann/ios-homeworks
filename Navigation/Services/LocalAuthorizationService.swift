//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 16.08.2026.
//


import LocalAuthentication

class LocalAuthorizationService: LocalAuthorizationServiceProtocol {
    
    var biometryType: BiometryType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
        
        let context = LAContext()
        var error: NSError?
        
        let reason = L10n.Login.biometryReason
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authorizationFinished(false, error)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
            DispatchQueue.main.async {
                authorizationFinished(success, evaluationError)
            }
            
        }
    }
}
