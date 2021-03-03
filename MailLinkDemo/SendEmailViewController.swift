import UIKit
import Firebase

class SendEmailViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField! //ユーザーからメールアドレスを受け取るUIを準備
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: UIButton) {
        
        let email = emailTextField.text ?? "" //ユーザーのメールアドレス
        
        let actionCodeSettings = ActionCodeSettings() //メールリンクの作成方法をFirebaseに伝えるオブジェクト
        
        actionCodeSettings.handleCodeInApp = true //ログインをアプリ内で完結させる必要がある
        
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!) //iOSデバイス内でログインリンクを開くアプリのBundleID
        
        //リンクURL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "maillinkdemo.page.link" //Firebaseコンソールで作成したダイナミックリンクURLドメイン
        let queryItemEmailName = "email" //URLにemail情報(パラメータ)を追加する
        let emailTypeQueryItem = URLQueryItem(name: queryItemEmailName, value: email)
        components.queryItems = [emailTypeQueryItem]
        guard let linkParameter = components.url else { return }
        print("\(linkParameter.absoluteString)")
        actionCodeSettings.url = linkParameter
        
        //ユーザーのメールアドレスに認証リンクを送信
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { (err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            print("サインイン用のメール送信完了")
            UserDefaults.standard.set(email, forKey: "email") //ユーザーがリンクをクリックしてログインを完了するときに使用したい
            
            //アラートを表示してメールアプリに誘導する
            let alertController = UIAlertController(title: "メールアプリを開きますか？", message: "", preferredStyle: .alert)
            let openMailAction = UIAlertAction(title: "メールアプリを開く", style: .default) { (action) in
                if let url = URL(string: "message://") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        print("メールアプリが開けません")
                    }
                }
            }
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alertActions = [openMailAction, okAction]
            alertActions.forEach{
                alertController.addAction($0)
            }
            self.present(alertController, animated: true)
            
            
            
            
        }
    }
    

}
