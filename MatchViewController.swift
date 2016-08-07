//
//  MatchViewController.swift
//  premTable
//
//  Created by Development on 8/7/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var matchStack: UIStackView!
    @IBOutlet var matchTable: UITableView!
    
    var currentMatchday = 1;
    
    var matches = [match]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatches()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMatches() {
        Alamofire.request(.GET, "https://api.football-data.org/v1/competitions/426/fixtures?matchday=1", parameters: ["X-Auth-Token" : "a0a6c9a4443e46f680b1fe4c3f5f0bb6"])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                self.createMatches(json["fixtures"])
                
    }
    }
    
    func createMatches(json :JSON) {
        for i in 0...json.count-1{
            let currentMatch :match = match(home : String(json[i]["homeTeamName"]), away : String(json[i]["awayTeamName"]), homeGoals : String(json[i]["result"]["homeTeamGoals"]), awayGoals :  String(json[i]["result"]["awayTeamGoals"]), status : String(json[i]["status"]), time : String(json[i]["date"]))
            matches.append(currentMatch)
        }
        reloadTable()
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        cell.home.text = matches[indexPath.row].home
        cell.away.text = matches[indexPath.row].away
        cell.homeCrest.image = UIImage(named: matches[indexPath.row].home + ".png")
        cell.awayCrest.image = UIImage(named: matches[indexPath.row].away + ".png")
        
        return cell
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.matchTable.reloadData()
        })
    }
    
}