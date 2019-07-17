//
//  ResultViewController.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    
    var user: Users?
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // ナビゲーションのヘッダーを出現させている
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func initializeTable() {
        //テーブルビューの設定。
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        // カスタムセルの登録。
        tableview.register(UINib(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileImageTableViewCell")
        tableview.register(UINib(nibName: "UserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserInfoTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section != 2) {
            return
        }
        if let user = self.user {
            let stBD = UIStoryboard(name: "Main", bundle: nil)
            switch indexPath.row {
            case 0:
                // スキルセルがタップされた時の画面遷移処理
                if let vc = stBD.instantiateViewController(withIdentifier: "SkillSB") as? SkillViewController  {
                    vc.navigationItem.title = "Skills"
                    vc.skills = user.skills
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                // プロジェクトのセルがタップされた時の画面遷移処理
                if let vc = stBD.instantiateViewController(withIdentifier: "ProjectSB") as? ProjectViewController {
                    vc.navigationItem.title = "Projects"
                    vc.projects = user.projects
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 200
        case 2:
            return 70
        default:
            return 100
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //セクションの数を指定している。
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクションのセルの数を指定している。
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        //それぞれのセクションに表示する際のデータを受け渡している。
        case 0:
            // セルの呼び出し
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableViewCell", for: indexPath) as? ProfileImageTableViewCell {
                if let image = self.userImage {
                    cell.profileImageView.image = image
                }
                return cell
            }
            // データのセット
            return UITableViewCell()
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? UserInfoTableViewCell {
                if let user = self.user {
                    //データのセット
                    cell.email.text = user.email
                    cell.phone.text = user.phone
                    cell.level.text = String(user.level)
                    cell.wallet.text = String(user.wallet)
                    return cell
                }
                return UITableViewCell()
            }
            return UITableViewCell()
        case 2:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            //データのセット
            cell.textLabel?.text = indexPath.row == 0 ? "Skills" : "Projects"
            return cell
        default:
            return UITableViewCell()
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
