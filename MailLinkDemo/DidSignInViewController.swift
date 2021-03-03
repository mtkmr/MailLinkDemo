//
//  DidSignInViewController.swift
//  MailLinkAuthDemo
//
//  Created by Masato Takamura on 2021/03/01.
//

import UIKit
import Firebase

class DidSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func signButtonTapped(_ sender: UIButton) {
        //ログイン状態ならば、サインアウト処理を行う
        if let user = Auth.auth().currentUser {
            
            do {
                try Auth.auth().signOut()
                print("サインアウト完了")
                //画面切り替えなど、サインアウト後の処理
                
            } catch let signOutError as NSError {
                print(signOutError.localizedDescription)
                return
            }
            
        }
    }
    

}
