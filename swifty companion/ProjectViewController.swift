//
//  ProjectViewController.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var projects: [Projects]?
    // nilを安全に取り出す
    // やってることはほぼresultviewと同じなのでそちらを参照
    override func viewDidLoad() {
        super.viewDidLoad()
        //ユーザーが終えたプロジェクとだけ
        //＄０はスウィフト特有の書き方
        projects = projects?.filter{ $0.finished }
        initialize()
    }
    
    func initialize() {
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 70
        tableview.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let projects = self.projects {
            return projects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell") as? ProjectTableViewCell {  if let projects = self.projects {
            let score = projects[indexPath.row].finalMark ?? 0
            cell.score.textColor = projects[indexPath.row].validated ? UIColor.green : UIColor.red
            cell.score.text = String(score)
            cell.projectName.text = projects[indexPath.row].projectName
            
            return cell
            }
        }
        return UITableViewCell()
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
