//
//  MainController.swift
//  ChargeTRemider
//
//  Created by Shu-Mei Cheng on 2/25/17.
//  Copyright © 2017 Shu-Mei Cheng. All rights reserved.
//
import Foundation
import UIKit
import EventKit

class MainController: UIViewController {
    var message: String?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        message = ""
        NotificationCenter.default.addObserver(self, selector: #selector(MainController.checkBattery), name: NSNotification.Name.UIDeviceBatteryStateDidChange , object: nil)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
   func checkReminder() {
        let reminders = EKEventStore()
        reminders.requestAccess(to: .reminder, completion: {
        (granted, error) in
            if(granted){
                let predicate = reminders.predicateForReminders(in: nil)
                reminders.fetchReminders(matching: predicate, completion:{ (allRemindres:[EKReminder]?)  -> Void in
                    for r:EKReminder in allRemindres!{
                        self.message = self.message! + "\n" + r.title
                    }
                })
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
                    self.showReminder()
                })
            }
        })
    
    }
  
   func showReminder( ) {
        if(message == "" ){
            message = "There is no reminder."
        }
        let alert = UIAlertController(title: "Reminders", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            exit(0)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)

    }
    
    func checkBattery(){
        if(UIDevice.current.isBatteryMonitoringEnabled == true){
            if(UIDevice.current.batteryState != .unplugged){
                checkReminder()
            }else{
                let alert = UIAlertController(title: "Your phone is not plugged in.", message: "Your phone is not recharging.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: {
                (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
               alert.addAction(ok)
               present(alert, animated: true, completion: nil)
            }
        }

    }
    
}

