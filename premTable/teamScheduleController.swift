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
    @IBOutlet weak var matchTable: UITableView!
    
    var teamUrl : String = "http://api.football-data.org/v1/teams/1044"
    var matches = [match]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatches()
        
       // self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.matchTable?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func loadMatches() {
        teamUrl = teamUrl.stringByReplacingOccurrencesOfString("http", withString: "https")
        Alamofire.request(.GET, teamUrl + "/fixtures", parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : apiKey.key])
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
            let currentMatch :match = match(home : String(json[i]["homeTeamName"]), away : String(json[i]["awayTeamName"]), homeGoals : String(json[i]["result"]["goalsHometeam"]), awayGoals :  String(json[i]["result"]["goalsAwayTeam"]), status : String(json[i]["status"]), time : String(json[i]["date"]), matchUrl : String(json[i]["_links"]["self"]["href"]))
            matches.append(currentMatch)
        }
        reloadTable()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchTableViewCell", forIndexPath: indexPath) as! MatchTableViewCell
        let row = indexPath.row
        cell.home.text = matches[row].home
        cell.away.text = matches[row].away
        cell.homeCrest.image = UIImage(named: matches[row].home + ".png")
        cell.awayCrest.image = UIImage(named: matches[row].away + ".png")
        if String(matches[row].status) == "TIMED" || String(matches[row].status) == "SCHEDULED"{
            cell.score.text = getDayTime(getGameTime(matches[row].time)!)
        }
        else {
            cell.score.text = String(matches[row].homeGoals) + "-" + String(matches[row].awayGoals)
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
        teamUrl = teamUrl.stringByReplacingOccurrencesOfString("https", withString: "http")
        self.loadMatches()
    }
    


}