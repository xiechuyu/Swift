//
//  ViewController.swift
//  BullsEye
//
//  Created by Mios on 15/12/12.
//  Copyright © 2015年 PCG. All rights reserved.
//

import UIKit
import QuartzCore //引入动画框架
import AVFoundation //引入音视频框架

class ViewController: UIViewController {

    @IBOutlet weak var slider:UISlider!
    @IBOutlet weak var targetLabel:UILabel!
    @IBOutlet weak var scoreLabel:UILabel!
    @IBOutlet weak var roundLabel:UILabel!
    
    var currentValue:Int=50
    var targetValue:Int=0
    var score=0
    var round=0
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starNewGame()
        updateLabels()
        currentValue=lroundf(slider.value)
        playBgMusic()
        
//        let thumbImageNormal=UIImage(named: "SliderThumb-Normal")
//        slider.setThumbImage(thumbImageNormal, forState: .Normal)
//        let thumbImageHighlighted=UIImage(named: "SliderThumb-Highlighted")
//        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
//        let insets=UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
//        if let trackLeftImage=UIImage(named: "SliderTrackLeft")
//        {
//            let trackLeftResizable=trackLeftImage.resizableImageWithCapInsets(insets)
//            slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
//        }
//        if let trackRightImage=UIImage(named: "SliderTrackRight")
//        {
//            let trackRightResizable=trackRightImage.resizableImageWithCapInsets(insets)
//            slider.setMinimumTrackImage(trackRightResizable, forState: .Normal)
//        }
//        为什么代码一样，滑动条的图片不出来？
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeftImage = UIImage(named: "SliderTrackLeft")
        {
            let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
        }
        if let trackRightImage = UIImage(named: "SliderTrackRight")
        {
            let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func starNewRound()
    {
        targetValue=1+Int(arc4random_uniform(100))//随机函数的取值范围是0-99
        currentValue=50
        slider.value=Float(currentValue)
        
        round += 1
    }
    
    func starNewGame()
    {
        score=0
        round=0
        starNewRound()
    }
    
    func updateLabels()
    {
        targetLabel.text=String(targetValue)
        scoreLabel.text=String(score)
        roundLabel.text=String(round)
    }
    
    func scoreLabels()
    {
        targetLabel.text=String(targetValue)
    }
    
    func playBgMusic()
    {
        let musicPath=NSBundle.mainBundle().pathForResource("bgmusic", ofType: "mp3")
        let url=NSURL(fileURLWithPath: musicPath!)
        
        do
        {
            audioPlayer=try AVAudioPlayer(contentsOfURL: url)
        }
        catch _
        {
            audioPlayer=nil
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func sliderMoved(slider:UISlider)
    {
        currentValue=lroundf(slider.value)
    }
    
    @IBAction func showAlert()
    {
        let difference=abs(currentValue - targetValue)
        var points=100 - difference
        
        var title:String
        if difference==0
        {
            title="完美！你可以去买彩票了！"
            points += 100
        }
        else if difference<5
        {
            title="这运气可以中二等奖了！"
            points += 50
        }
        else if difference<10
        {
            title="貌似还不错"
        }
        else
        {
            title="就这水平你还敢来玩耍？。。。"
        }
        
        score += points
        let message="你的得分是：\(points)"
        let alert=UIAlertController(title:title, message:message, preferredStyle: .Alert)
        let action=UIAlertAction(title: "OK", style: .Default, handler:
            {
                action in
                self.starNewRound()
                self.updateLabels()
                self.scoreLabels()
            }
            )
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func starOver()
    {
        starNewGame()
        updateLabels()
        
        let transition=CATransition() //淡入淡出动画
        transition.type=kCATransitionFade
        transition.duration=1
        transition.timingFunction=CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.addAnimation(transition, forKey: nil)
    }
}

