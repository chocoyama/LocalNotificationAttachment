//
//  ViewController.swift
//  AttachmentTest
//
//  Created by 横山 拓也 on 2016/08/18.
//  Copyright © 2016年 jp.co.chocoyama. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    private let repository = NotificationTmpImageRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTappedRegisterButton(_ sender: AnyObject) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { [weak self] (result, error) in
            let imageUrlString = "http://a12160714.xsrv.jp/kazuki/wp-content/uploads/2014/11/%E3%81%95%E3%81%95%E3%81%8D%EF%BC%92-234x300.jpg"
            self?.registerNotification(imageUrlString: imageUrlString)
        })
    }
    
    @IBAction func didTappedRegisterButton2(_ sender: AnyObject) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { [weak self] (result, error) in
            let imageUrlString = "http://actresspress.com/wp-content/uploads/2016/02/e601e74739893d7b73900c29999b16ba.jpg"
            self?.registerNotification(imageUrlString: imageUrlString)
        })
    }
    
    private func registerNotification(imageUrlString: String) {
        let url = URL(string: imageUrlString)!
        repository.saveImage(from: url, imageName: "tmp", completion: { [weak self] (savedUrl) in
            let content = UNMutableNotificationContent()
            content.title = "title"
            content.subtitle = "subtitle"
            content.body = "body"
            
            if let savedUrl = savedUrl,
                let attachment = try? UNNotificationAttachment(identifier: imageUrlString, url: savedUrl, options: nil) {
                content.attachments = [attachment]
            }
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest.init(identifier: imageUrlString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { [weak self] (error) in
                if let savedUrl = savedUrl {
                    self?.repository.deleteImage(from: savedUrl)
                }
            })
        })
    }

}

