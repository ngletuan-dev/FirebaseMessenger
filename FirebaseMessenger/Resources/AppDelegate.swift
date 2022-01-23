//
//  AppDelegate.swift
//  FirebaseMessenger
//
//  Created by Tuấn Nguyễn on 13/12/2021.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var signInConfig: GIDConfiguration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        // Facebook Sign In
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:launchOptions)
        // Google Sign In
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user = user, error == nil {
                self?.handleSessionRestore(user: user)
            }
        }
        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }

        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }
        // Handle other custom URL types.
        // If not handled by this app, return false.
        return false
    }

    
    func handleSessionRestore(user: GIDGoogleUser) {
            guard let email = user.profile?.email,
                  let firstName = user.profile?.givenName,
                  let lastName = user.profile?.familyName else {
                    return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    // insert to database
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            // upload image
                            if user.profile?.hasImage == true {
                                guard let url = user.profile?.imageURL(withDimension: 200) else {
                                    return
                                }

                                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                    guard let data = data else {
                                        return
                                    }

                                    let filename = chatUser.profilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case .failure(let error):
                                            print("Storage manager error: \(error)")
                                        }
                                    })
                                }).resume()
                            }
                        }
                    })
                }
            })

            let authentication = user.authentication
            guard let idToken = authentication.idToken else {
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken
            )

            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("failed to log in with google credential")
                    return
                }

                print("Successfully signed in with Google cred.")
                NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            })
        }
    
    
    
    
// MARK: UISceneSession Lifecycle ----------------------------------------------------

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
    
