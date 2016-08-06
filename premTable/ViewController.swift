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


class ViewController: UIViewController {
    
     var standings = [team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func loadTable() {
        
        
        Alamofire.request(.GET, "https://api.football-data.org/v1/soccerseasons/426/leagueTable", parameters: ["X-Auth-Token" : "a0a6c9a4443e46f680b1fe4c3f5f0bb6"])
            .responseJSON{ response in
                let json = JSON(response.result.value!)
                //print(json["standing"])
                self.createStandings(json)
                
        }
    }
    
    func createStandings(json : JSON){
        
        for i in 0...json["standing"].count-1{
            let currentTeam : team = team(rank: String(json["standing"][i]["position"]), name: String(json["standing"][i]["teamName"]), points: String(json["standing"][i]["points"]))
            standings.append(currentTeam)
            print(standings[i].name)
        }
        
        
    
    }
}

