//
//  ViewController.swift
//  premTable
//
//  Created by Development on 8/5/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
 
    @IBOutlet var tableStack: UIStackView!
    @IBOutlet var premTable: UITableView!

    
    
    var standings = [team]()
    var refreshControl = UIRefreshControl()
    var teamUrl : String = "Error"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStandings()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.premTable?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func loadStandings() {
        
        
        Alamofire.request(.GET, "https://api.football-data.org/v1/soccerseasons/426/leagueTable", parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : apiKey.key])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                
                if self.refreshControl.refreshing
                {
                    self.refreshControl.endRefreshing()
                }
                
                self.createStandings(json)
                
        }
    }
    
    func createStandings(json : JSON){
        standings.removeAll()
        
        for i in 0...json["standing"].count-1{
            var currentTeam : team
            let rank = String(json["standing"][i]["position"])
            let name = String(json["standing"][i]["teamName"])
            let points = String(json["standing"][i]["points"])
            let url = String(json["standing"][i]["_links"]["team"]["href"])
            if i < 3{
            currentTeam = team(rank: rank, name: name, points: points, color : UIColor.greenColor(), url : url)
            }
            else if i == 3{
                currentTeam  = team(rank: rank, name: name, points: points, color : UIColor.blueColor(), url : url)
            }
            else if i == 4{
                currentTeam  = team(rank: rank, name: name, points: points, color : UIColor.yellowColor(), url : url)
            }
            else if i < 20 && i > 16{
                currentTeam  = team(rank: rank, name: name, points: points, color : UIColor.redColor(), url : url)
            }
            else{
                currentTeam  = team(rank: rank, name: name, points: points, color : UIColor.whiteColor(), url : url)
            }
            

            standings.append(currentTeam)
           
        }
        reloadTable()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamTableViewCell", forIndexPath: indexPath) as! TeamTableViewCell
        cell.teamName?.text = standings[indexPath.row].name
        cell.position.text = standings[indexPath.row].rank
        cell.points.text = standings[indexPath.row].points
        cell.TeamCrest.image = UIImage(named: standings[indexPath.row].name + ".png")
        cell.sideBar.backgroundColor = standings[indexPath.row].color
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    teamUrl = standings[indexPath.row].url
    let teamSchedule = self.storyboard!.instantiateViewControllerWithIdentifier("teamSchedule") as! teamScheduleController
    teamSchedule.teamUrl = self.teamUrl
    self.navigationController!.pushViewController(teamSchedule, animated: true)
        
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "segue" {
//            let teamSchedule = segue.destinationViewController as! teamScheduleController
//            teamSchedule.teamUrl = self.teamUrl
//        }
//    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.premTable.reloadData()
        })
    }
    
    func refresh(sender:AnyObject) {
        self.loadStandings()
    }
    
    }

