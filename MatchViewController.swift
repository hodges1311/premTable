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
    @IBOutlet weak var changeMatchday: UIButton!
    @IBOutlet weak var MatchdayTitle: UINavigationItem!

  
    
    var currentMatchday = "8"
    var matches = [match]()
    var refreshControl = UIRefreshControl()
    var matchdaySet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatchday(matchdaySet)
        if matchdaySet {
            MatchdayTitle.title = "Matchday " + currentMatchday
        }
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.matchTable?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMatchday(set : Bool){
        if !set{
         Alamofire.request(.GET, "https://api.football-data.org/v1/competitions/426/", parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : apiKey.key])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                self.currentMatchday = json["currentMatchday"].description
                self.MatchdayTitle.title = "Matchday " + self.currentMatchday
                self.loadMatches(self.currentMatchday)
        }
        }
            else{
                self.loadMatches(self.currentMatchday)
            }
        
    }
    
    
    func loadMatches(matchday : String) {
        Alamofire.request(.GET, "https://api.football-data.org/v1/competitions/426/fixtures?matchday=" + matchday, parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : apiKey.key])
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
            let currentMatch :match = match(home : String(json[i]["homeTeamName"]), away : String(json[i]["awayTeamName"]), homeGoals : String(json[i]["result"]["goalsHomeTeam"]), awayGoals :  String(json[i]["result"]["goalsAwayTeam"]), status : String(json[i]["status"]), time : String(json[i]["date"]), matchUrl : String(json[i]["_links"]["self"]["href"]))
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
        if String(matches[indexPath.row].status) == "TIMED" || String(matches[indexPath.row].status) == "SCHEDULED" {
            cell.score.text = getDayTime(getGameTime(matches[indexPath.row].time)!)
        }
        else {
            cell.score.text = String(matches[indexPath.row].homeGoals) + "-" + String(matches[indexPath.row].awayGoals)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let singleMatch = self.storyboard!.instantiateViewControllerWithIdentifier("singleMatch") as! singleMatchController
        singleMatch.currentMatch = matches[indexPath.row]
        self.navigationController!.pushViewController(singleMatch, animated: true)
        
    }
    
    @IBAction func changeMatchday(sender: AnyObject) {
        let singleMatch = self.storyboard!.instantiateViewControllerWithIdentifier("pickMatchday") as! UITableViewController
         self.navigationController!.pushViewController(singleMatch, animated: true)
        
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
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.matchTable.reloadData()
        })
    }
    
    func refresh(sender:AnyObject) {
        self.loadMatches(currentMatchday)
    }
    
}