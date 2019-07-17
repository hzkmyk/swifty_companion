//
//  SkillViewController.swift
//  swifty companion
//
//  Created by Hazuki Miyake on 7/11/19.
//  Copyright © 2019 Hazuki Miyake. All rights reserved.
//

import UIKit

class SkillViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var skills: [Skills]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTable()
    }
    //やってることはProjectViewと同じ
    func initializeTable() {
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 70
        tableview.register(UINib(nibName: "SkillTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "SkillTableViewCell")
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if let skills = self.skills {
            return skills.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell") as? SkillTableViewCell {
            if let skills = self.skills {
                cell.skillname.text = skills[indexPath.row].name
                let level: Int = Int(skills[indexPath.row].level)
                cell.level.text = "level: \(level).\(Int((skills[indexPath.row].level - Double(level)) * 100))%"
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
