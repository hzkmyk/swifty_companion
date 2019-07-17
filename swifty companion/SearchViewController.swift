//
//  SearchViewController.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SearchViewController: UIViewController {
    
    // 一番最初の画面のUIコンポーネントたち
    @IBOutlet var searchField: UITextField!
    @IBOutlet var errMsg: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //ユーザーの情報を格納する変数
    var user: Users? = nil
    //ユーザー検索に必要なtokenを含んだヘッダー
    var header =  { () -> [String : String] in
        if let token = UserDefaults.standard.string(forKey: "token") {
            return [
                "Authorization": "Bearer " + token,
                "Accept": "application/json"
            ]
        }
        return [:]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //トークンが期限切れていないかチェックしてる。
        //uninsta
        if (!checkToken()) {
            self.performSegue(withIdentifier: "authWebView", sender: nil)
        }
    }
    
    // トークンの期限を確認する関数。
    // UserDefaultsはアプリのローカルストレージにアクセスするための関数
    func checkToken() -> Bool {
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        if let expires = UserDefaults.standard.value(forKey: "expiration") as? Int64 {
            return currentTime < expires
        }
        return false
    }
    
    // 名前をもとにユーザーのidを取ってくる
    // callback と　errorのparameterは関数担っていて、ユーザーが取ってこれた場合にcallbackを読んで引数としてユーザーのidを渡している
    //escaingの後の()は引数型、矢印の後はreturn valuenの型
    func getUID(name: String, callback: @escaping (String) -> Void, error: @escaping () -> Void) {
        // AlamofireはAPIリクエストを作るためのライブラリ
        Alamofire.request("https://api.intra.42.fr/v2/users",
                          method: .get,
                          parameters: ["filter[login]": name],
                          encoding: URLEncoding.default,
                          headers: self.header)
            .responseData { res in
                //上のresponseDataはrequestが持ってる関数
                if let value = res.result.value {
                    let json = JSON(value)
                    let id = json[0]["id"].stringValue
                    if (id == "") { return error() }
                    //ここでcallback関数を読んで、引数にユーザーのIDを渡している。
                    callback(id)
                    return
                }
                error()
        }
    }
    
    // 上のgetUserId関数で取れたユーザーIDを使ってユーザーの情報を取ってくる関数。
    //引数は同じくcallback, errorの関数を取る
    func getUserData(id: String,
                     callback: @escaping (JSON) -> Void,
                     error: @escaping () -> Void) {
        Alamofire.request(
            "https://api.intra.42.fr/v2/users/\(id)",
            method: .get,
            headers: self.header)
            .responseData { res in
                if let value = res.result.value {
                    let json = JSON(value)
                    // ここでユーザーの情報全てをcallbackの引数として渡している。
                    callback(json)
                    return
                }
                error()
        }
    }
    
    // 上のgetUserDataで取れた情報のうち、プロファイルイメージのリンクを使って画像を取ってくる関数。
    func getProfImage(url: String,
                      callback: @escaping (Image) -> Void) {
        Alamofire.request(url,
                          method: .get,
                          headers: self.header)
            .responseImage { res in
                if let image = res.result.value{
                    callback(image)
                }
        }
    }
    
    // searchボタンに紐つけられている関数
    @IBAction func search(_ sender: UIButton) {
        if let input = searchField.text {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            getUID(name: input, callback: { [weak self] id in
                //weakはメモリーリーク予防
                // callbackに渡ってきたidを取ってきて、それを次の関数であるgetUserDataに渡してユーザー情報を取ってくる。
                self?.getUserData(id: id, callback: { [weak self] json in
                    // 取れたユーザー情報の中から、image urlを取ってきて、それを元にユーザーの画像を取ってきて、それをprofileImageViewにセットしている。
                    self?.getProfImage(url: json["image_url"].stringValue, callback: { image in
                        if let imageView = self?.imageView {
                            // ここでイメージをセットしている。
                            imageView.image = image
                            self?.errMsg.text = ""
                            self?.user = Users(json: json)
                        }
                        self?.indicator.stopAnimating()
                        self?.indicator.isHidden = true
                    })
                }) { [weak self] in
                    // getUserDataのerrorに渡す関数
                    self?.errMsg.text = "Error"
                    self?.imageView.image = nil
                    self?.user = nil
                    self?.indicator.stopAnimating()
                    self?.indicator.isHidden = true
                }
            }) { [weak self] in
                // getUserIdのerrorに渡す関数
                self?.errMsg.text = "Not Found"
                self?.imageView.image = nil
                self?.user = nil
                self?.indicator.stopAnimating()
            }
        }
    }
    
    //遷移の時に次の画面にパスするやつ
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultViewController {
            if let user = self.user {
                if let vc = segue.destination as? ResultViewController {
                    vc.navigationItem.title = user.login
                    vc.user = user
                    vc.userImage = self.imageView.image
                }
            }
        }
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
