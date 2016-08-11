//
//  singleMatchController.swift
//  premTable
//
//  Created by Hodges, Ethan on 8/10/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class singleMatchController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var headToHeadStack: UIStackView!
    @IBOutlet weak var headToHeadView: UIView!
    @IBOutlet weak var headToHeadTable: UITableView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var awayTeamImage: UIImageView!
    
    var currentMatch : match = match(home: "fake", away: "team", homeGoals: "1", awayGoals: "1", status: "TIMED", time: "shit", matchUrl: "https//api.football-data.org/v1/fixtures/150838")
    var matches = [match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTeamImage.image = UIImage(named: currentMatch.home + ".png")
        awayTeamImage.image = UIImage(named: currentMatch.away + ".png")
        time.text = getDayTime(getGameTime(currentMatch.time)!)
        self.automaticallyAdjustsScrollViewInsets = false
        currentMatch.matchUrl = currentMatch.matchUrl.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        loadMatches(currentMatch.matchUrl)
        
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
        cell.score.text = String(matches[row].homeGoals) + "-" + String(matches[row].awayGoals)
        return cell
    }

    func loadMatches(fixtures: String) {
        Alamofire.request(.GET, fixtures, parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : apiKey.key])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                
                self.createMatches(json["head2head"]["fixtures"])
        }
    }
    
    func createMatches(json :JSON) {
        matches.removeAll()
        for i in 0...json.count-1{
            
            let currentMatch : match = match(home : String(json[i]["homeTeamName"]), away : String(json[i]["awayTeamName"]), homeGoals : String(json[i]["result"]["goalsHomeTeam"]), awayGoals :  String(json[i]["result"]["goalsAwayTeam"]), status : String(json[i]["status"]), time : String(json[i]["date"]), matchUrl : String(json[i]["_links"]["self"]["href"]))
            matches.append(currentMatch)
        }
        reloadTable()
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
            self.headToHeadTable.reloadData()
        })
    }
}