//
//  AuthViewController.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class AuthWebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let url = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=b77ebfa5b96980c8a3c2695bcc96203388db834ea285866c9e8cebcef27cf720&redirect_uri=https%3A%2F%2Fprofile.intra.42.fr&response_type=code")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ウェブサイトに表示されてるリンクをそのままwebviewに投げる
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillLayoutSubviews() {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func loadView() {
        // webviewを設定、ロードしている。
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    // 最初のサイトにアクセスして帰ってきたコードを渡して、トークンをもらう処理。
    // client_id, client_secretはウェブサイトから取得
    func requestToken(code: String, callback: @escaping (String, Int) -> Void) {
        //codeを元にアクセスする先
        Alamofire.request("https://api.intra.42.fr/oauth/token",
                          method: .post,
                          parameters: [
                            "code": code,
                            "grant_type": "authorization_code",
                            "redirect_uri": "https://profile.intra.42.fr",
                            "client_id": "b77ebfa5b96980c8a3c2695bcc96203388db834ea285866c9e8cebcef27cf720",
                            "client_secret": "4496e31c0a58e6bbb84cae64a4dbbb64ef408c931e618b1d0db593542759662f",
                ],
                          encoding: URLEncoding.default)
            .responseData { res in
                if let value = res.result.value {
                    if res.error == nil && res.response?.statusCode == 200 {
                        let json = JSON(value)
                        let token = json["access_token"].stringValue
                        let time = json["expires_in"].intValue
                        // success関数に、tokenと有効期限を渡す。
                        callback(token, time)
                    }
                }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        if let url = webView.url {
            if (!url.absoluteString.starts(with: "https://profile.intra.42.fr")) {
                return
            }
            let code = url.absoluteString.replacingOccurrences(of: "^https://.*?code=",
                                                               with: "",
                                                               options: .regularExpression)
            requestToken(code: code) { [weak self] token, time in
                //これがsuccess関数の中身。
                let currSecond = Int64(Date().timeIntervalSince1970 * 1000)
                let expSecond = Int64(time * 1000)
                // UserDefaultsでkey-valueの形で、tokenを保存する。
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(currSecond + expSecond, forKey: "expiration")
                self?.navigationController?.popViewController(animated: true)
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
