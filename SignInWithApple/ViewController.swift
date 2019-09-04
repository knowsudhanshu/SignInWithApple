//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Sudhanshu on 04/09/19.
//  Copyright © 2019 Sudhanshu. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAppleSignIn()
    }

    private func observeAppleIdChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appleIdStateChange), name: .ASAuthorizationAppleIDProviderCredentialRevoked, object: nil)
    }
    
    @objc private func appleIdStateChange() {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: "saved user id here") { (state, error) in
            switch state {
            case .authorized:
                /// Continue what ever app is doing
            break
            case .revoked:
                /// Logout
            break
            case .notFound:
                /// Logout
            break
            default: break
            }
        }
    }
    func setupAppleSignIn() {

        let button = ASAuthorizationAppleIDButton()
//        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
//        button.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        self.view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        button.addTarget(self, action: #selector(appleSignInHandler), for: .touchUpInside)
    }
    
    @objc private func appleSignInHandler() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request1 = appleIDProvider.createRequest()
        request1.requestedScopes = [.fullName, .email]
        
        let request2 = ASAuthorizationPasswordProvider().createRequest()
        
        
        
        let authorizationContoller = ASAuthorizationController(authorizationRequests: [request1])
        authorizationContoller.delegate = self
        authorizationContoller.presentationContextProvider = self
        authorizationContoller.performRequests()
    }

}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleId = appleIDCredential.user
            let firstName = appleIDCredential.fullName?.givenName
            let lastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            
            print("appleId: \(appleId)")
            print("firstName: \(firstName)")
            print("lastName: \(lastName)")
            print("appleUserEmail: \(appleUserEmail)")
            
            /*
             First time login
             ======
             appleId: 001781.3e7e549fc56540c591064b3e23b76729.1038
             firstName: Optional("Sudhanshu")
             lastName: Optional("Srivastava")
             appleUserEmail: Optional("t3ezacuq7x@privaterelay.appleid.com")
             ======
             
             Second time login
             ======
             appleId: 001781.3e7e549fc56540c591064b3e23b76729.1038
             firstName: nil
             lastName: nil
             appleUserEmail: nil
             ======
             */
            
            
        }else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
        }
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

