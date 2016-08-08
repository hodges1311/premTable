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
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var standings = [team]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.barTintColor = UIColor.orangeColor()
        loadStandings()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.premTable?.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func loadStandings() {
        
        
        Alamofire.request(.GET, "https://api.football-data.org/v1/soccerseasons/426/leagueTable", parameters: nil, encoding: .JSON, headers: ["X-Auth-Token" : "a0a6c9a4443e46f680b1fe4c3f5f0bb6"])
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
            
            if i < 3{
            currentTeam = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]), color : UIColor.greenColor())
            }
            else if i == 3{
            currentTeam  = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]), color : UIColor.blueColor())
            }
            else if i == 4{
                currentTeam  = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]), color : UIColor.yellowColor())
            }
            else if i < 20 && i > 16{
                currentTeam  = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]), color : UIColor.redColor())
            }
            else{
                   currentTeam  = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]), color : UIColor.whiteColor())
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
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.premTable.reloadData()
        })
    }
    
    func refresh(sender:AnyObject) {
        self.loadStandings()
    }
    
    }

