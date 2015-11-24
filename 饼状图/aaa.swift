//
//  aaa.swift
//  饼状图
//
//  Created by 大地创想 on 15/11/24.
//  Copyright © 2015年 大地创想. All rights reserved.
//

import Foundation
//
//  Pie.swift
//  饼状图
//
//  Created by 大地创想 on 15/11/20.
//  Copyright © 2015年 大地创想. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol RFPieDelegate{
    func chooseIndex(index:Int)
}


class RFPie: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var ColorView:UIView?
    private var nameViews:[UIView]?
    
    var roundCap:CGFloat = 5
    var roundWidth:CGFloat = 20
    
    var delegate:RFPieDelegate?
    
    
    var dataArr = [[AnyObject]](){
        didSet{
            backgroundColor = UIColor.clearColor()
            var total:CGFloat = 0
            for arr in dataArr{
                nameArr.append(arr[1] as! String)
                colorArr.append(arr[2] as! UIColor)
                total += (arr[0] as! CGFloat)
            }
            var beforT:CGFloat = 0
            percentArr.append(0)
            for arr in dataArr{
                beforT += (arr[0] as! CGFloat)
                percentArr.append(beforT/total)
            }
        }
    }
    
    private var percentArr = [CGFloat]()
    private var nameArr = [String]()
    private var colorArr = [UIColor]()
    
    private var minL:CGFloat = 0
    
    private var midPointArr = [CGPoint]()
    private var labelArr = [UILabel]()
    
    
    
    
    override func drawRect(rect: CGRect) {
        minL = (frame.size.width > frame.size.height ? frame.size.height : frame.size.width)/2 - roundCap
        
        
        for i in 0..<dataArr.count{
            colorArr[i].set()
            let path = UIBezierPath()
            path.lineWidth = 1
            path.lineCapStyle = CGLineCap.Round
            path.lineJoinStyle = CGLineJoin.Round
            
            let startA = CGFloat(2*M_PI) * percentArr[i]
            let endA = CGFloat(2*M_PI) * percentArr[i+1]
            
            
            path.moveToPoint(CGPointMake(frame.width/2 + minL * cos(startA), frame.height/2 + minL * sin(startA)))
            path.addArcWithCenter(CGPointMake(frame.width/2, frame.height/2), radius: minL , startAngle: startA, endAngle:endA, clockwise: true)
            path.addLineToPoint(CGPointMake(frame.width/2 + (minL - roundWidth) * cos(endA), frame.height/2 + (minL - roundWidth) * sin(endA)))
            path.addArcWithCenter(CGPointMake(frame.width/2, frame.height/2), radius: minL - roundWidth , startAngle: endA, endAngle:startA, clockwise: false)
            
            let midA = ( startA + endA )/2
            let pointh = CGPointMake(frame.width/2 + (minL - roundWidth/2) * cos(midA), frame.height/2 + (minL - roundWidth/2) * sin(midA))
            midPointArr.append(pointh)
            let l = UILabel()
            l.frame = CGRectMake(0, 0, 44, 44)
            l.center = convertPoint(pointh, toView: superview!)
            l.text = nameArr[i]
            l.textAlignment = NSTextAlignment.Center
            
            superview!.addSubview(l)
            labelArr.append(l)
            
            path.closePath()
            path.fill()
        }
        
        //        moveToIndex(1)
        
    }
    
    var oldPoint:CGPoint?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count > 1{
            return
        }
        if superview == nil{
            return
        }
        
        let point = ((touches as NSSet).anyObject() as! UITouch).locationInView(superview!)
        
        let long:CGFloat = sqrt(pow((point.x - center.x),2) + pow((point.y - center.y),2))
        
        
        
        
        if long < minL - roundWidth || long > minL {
            return
        }
        
        oldPoint = point
        
        
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count > 1{
            return
        }
        if superview == nil{
            return
        }
        
        let point = ((touches as NSSet).anyObject() as! UITouch).locationInView(superview!)
        
        if oldPoint == nil{
            oldPoint = point
            return
        }
        
        let oldA = pointToAngle(oldPoint!)
        let newA = pointToAngle(point)
        var fin = newA - oldA
        if fin > 180 {
            fin =   -360 + fin
        }
        if fin < -180{
            fin = 360 + fin
        }
        transform = CGAffineTransformRotate(transform,(fin) * 2 * CGFloat( M_PI ) / 360)
        for i in 0..<self.labelArr.count{
            self.labelArr[i].center = self.convertPoint(self.midPointArr[i], toView: self.superview!)
        }
        
        
        oldPoint = point
        
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        oldPoint = nil
        

        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        oldPoint = nil
        let selfAngle = pointToAngle(((touches as NSSet).anyObject() as! UITouch).locationInView(self), isInFather: false)
        
        for i in 0..<percentArr.count{
            if percentArr[i] > selfAngle / 360{
                if delegate != nil{
                    delegate!.chooseIndex(i)
                }
                return
            }
        }
    }
    
    
    
    func moveToIndex(index:Int){
        var startPointArr = [CGPoint]()
        for i in 0..<self.labelArr.count{
            startPointArr.append(self.convertPoint(self.midPointArr[i], toView: self.superview!))
        }
        
        
        
        UIView.animateWithDuration(2) { () -> Void in
            self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2) - (self.percentArr[index] + self.percentArr[index-1]) * CGFloat( M_PI ) )
            for i in 0..<self.labelArr.count{
                self.labelArr[i].center =  self.convertPoint(self.midPointArr[i], toView: self.superview!)
            }
        }
        
        var endPointArr = [CGPoint]()
        for i in 0..<self.labelArr.count{
            endPointArr.append(self.convertPoint(self.midPointArr[i], toView: self.superview!))
        }
        
        
        
//        for i in 0..<self.labelArr.count{
//            let a = CAKeyframeAnimation(keyPath: "position")
//            a.calculationMode = kCAAnimationPaced
//            a.fillMode = kCAFillModeForwards
//            a.duration = 2
//            a.removedOnCompletion = true
//            a.repeatCount = 1
//            let p = CGPathCreateMutable()
//            CGPathAddArcToPoint(p, nil, startPointArr[i].x, startPointArr[i].y, endPointArr[i].x, endPointArr[i].y, (minL - roundWidth/2))
//            a.path = p
//            
//            labelArr[i].layer.addAnimation(a, forKey: "position")
//            print("a = \(a) e = \(startPointArr[i]) s = \(endPointArr[i])")
//        }
        
        
    }
    
    
    func pointToAngle(point:CGPoint,isInFather:Bool = true)->CGFloat{
        var cPoint = center
        if !isInFather{
            cPoint = convertPoint(center, fromView: self.superview!)
        }
        
        
        if point.y != center.y{
            let a = (point.x - cPoint.x) / (point.y - cPoint.y)
            
            let angle = (CGFloat(M_PI)/2 - atan(a) + (point.y < cPoint.y ? CGFloat(M_PI) : 0) ) / CGFloat(2*M_PI)
            return angle * 360
        }
        else{
            if point.x > cPoint.x {
                return 180
            }
            else{
                return 0
            }
        }
    }
    
    
}