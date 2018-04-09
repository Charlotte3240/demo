//
//  ViewController.swift
//  CalendarDemo
//
//  Created by 刘春奇 on 2018/3/19.
//  Copyright © 2018年 Cloudnapps. All rights reserved.
//

import UIKit
import FSCalendar
class ViewController: UIViewController,FSCalendarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = FSCalendar()
        calendar.frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: 300)
        calendar.appearance.caseOptions = .weekdayUsesUpperCase
        let locale = Locale.init(identifier: "zh_CN")
        calendar.locale = locale
        calendar.delegate = self
        self.view.addSubview(calendar)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - calendar delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = " YYYY-MM-dd "
        let customDate = dateformatter.string(from: date)

        

        print(customDate)
    }


}

