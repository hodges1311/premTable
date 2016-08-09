//
//  teamScheduleController.swift
//  premTable
//
//  Created by Hodges, Ethan on 8/9/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class teamScheduleController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var teamStack: UIStackView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var matchTable: UITableView!
    
    var teamUrl : String = ""
    var matches = [match]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.barTintColor = UIColor.orangeColor()
        loadMatches()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.matchTable?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func loadMatches() {
        teamUrl = teamUrl.stringByReplacingOccurrencesOfString("http", withString: "https")
        Alamofire.request(.GET, teamUrl + "/fixtures", parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : "a0a6c9a4443e46f680b1fe4c3f5f0bb6"])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                
                if self.refreshControl.refreshing
                {
                    self.refreshControl.endRefreshing()
                }
                
                self.createMatches(json["fixtures"])
                
        }
    }
    
    func createMatches(json :JSON) {
        matches.removeAll()
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
        if String(matches[indexPath.row].status) == "TIMED" || String(matches[indexPath.row].status) == "SCHEDULED"{
            cell.score.text = getDayTime(getGameTime(matches[indexPath.row].time)!)
        }
        else {
            cell.score.text = String(matches[indexPath.row].homeGoals) + "-" + String(matches[indexPath.row].awayGoals)
        }
        return cell
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.matchTable.reloadData()
        })
    }
    
    
    func getGameTime(date : String) -> NSDate?{
        let dateString = date
        var gameTime : NSDate?
        var secondsFromGMT: Int { return NSTimeZone.localTimeZone().secondsFromGMT }
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        gameTime = dateFormatter.dateFromString(dateString)
        return gameTime
    }
    
    func getDayTime(iso : NSDate)->String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: iso)
        let time = (String(components.hour) + ":" + String(components.minute)).stringByReplacingOccurrencesOfString(":0", withString: ":00")
        return String(components.month) + "/" + String(components.day) + "\n" + time
    }

    func refresh(sender:AnyObject) {
        self.loadMatches()
    }
    


}