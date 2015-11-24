//
//  ViewController.swift
//  饼状图
//
//  Created by 大地创想 on 15/11/20.
//  Copyright © 2015年 大地创想. All rights reserved.
//

import UIKit

class ViewController: UIViewController,RFPieDelegate {
    let pie = RFPie()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let dataArr:[[AnyObject]] = [[10,"a",UIColor.redColor()],[2,"b",UIColor.grayColor()],[3,"c",UIColor.blueColor()],[4,"d",UIColor.yellowColor()]]

        pie.dataArr = dataArr
        pie.frame = CGRectMake(100, 200, 200, 200)
        pie.roundWidth = 50
        pie.delegate = self
        view.addSubview(pie)
        
  
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func chooseIndex(index:Int) {
        print("选择了第\(index)块")
        pie.moveToIndex(index)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

