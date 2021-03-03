//
//  SceneDelegate.swift
//  MailLinkAuthDemo
//
//  Created by Masato Takamura on 2021/03/01.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    //ユーザーのアクティビティオブジェクトの情報を全て受信したときに呼ばれる
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        //リンクURLを取得
        guard let url = userActivity.webpageURL else { return }
        let link = url.absoluteString
        if Auth.auth().isSignIn(withEmailLink: link) {
            //保存していたメールアドレスを取得
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                print("サインインエラー: メールアドレスが存在しません")
                return
            }
            //ログイン処理
            Auth.auth().signIn(withEmail: email, link: link) { (auth, err) in
                if let err = err {
                    print(err.localizedDescription)
                    print("ログイン失敗")
                    
                    return
                }
                guard let auth = auth else {
                    print("サインインエラー")
                    return
                }
                let uid = auth.user.uid
                print("uid: \(uid)のユーザーがログインに成功")
                print("ログイン成功")
//                Hud.handle(hud, with: HudInfo(type: .success, text: "認証に成功しました。", detailText: "サインインします"))
                guard let scene = (scene as? UIWindowScene) else { return }
                let window = UIWindow(windowScene: scene)
                self.window = window
                window.makeKeyAndVisible()
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let didSignInVC = storyboard.instantiateViewController(withIdentifier: "DidSignInViewController")
                self.switchVC(viewController: didSignInVC)
            }
        }
    }
    
    func switchVC(viewController: UIViewController) {
        
        self.window?.rootViewController = viewController
        
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sendEmailVC = storyboard.instantiateViewController(withIdentifier: "SendEmailViewController")
        let didSignInVC = storyboard.instantiateViewController(withIdentifier: "DidSignInViewController")
        window.makeKeyAndVisible()

        if Auth.auth().currentUser != nil {
            //ログインしているとき、MapVCへ
            self.switchVC(viewController: didSignInVC)
        } else {
            //ログアウトしているとき、WelcomeVCへ
            self.switchVC(viewController: sendEmailVC)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

