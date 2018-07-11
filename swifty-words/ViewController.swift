//
//  ViewController.swift
//  swifty-words
//
//  Created by Leo Liu on 6/27/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var allButtons = [UIButton]()
    var usedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //manually connect all the buttons
        for subview in view.subviews where subview.tag == 1001{
            let btn = subview as! UIButton
            allButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        
        loadLevel()
    }
    
    func loadLevel(){
        var clue = ""
        var numberOfLettersHint = ""
        var allAnswerBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt"), let levelContents = try? String(contentsOfFile: levelFilePath){
            var lines: [String] = levelContents.components(separatedBy: "\n")
            lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
            
            for (index, line) in lines.enumerated(){
                let parts: [String] = line.components(separatedBy: ": ")
                let answerPart: String = parts[0]
                let cluePart: String = parts[1]
                
                let answerBits: [String] = answerPart.components(separatedBy: "|")
                let answer = answerPart.replacingOccurrences(of: "|", with: "")
                clue = "\(index + 1). \(cluePart)\n"
                
                numberOfLettersHint += "\(answer.count) letters\n"
                solutions.append(answer)
                
                allAnswerBits += answerBits
            }
        }
        
        //configure buttons and labels
        cluesLabel.text = clue.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = numberOfLettersHint.trimmingCharacters(in: .whitespacesAndNewlines)
        
        allAnswerBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allAnswerBits) as! [String]
        
        if allAnswerBits.count == allButtons.count {
            for i in 0 ..< allAnswerBits.count{
                allButtons[i].setTitle(allAnswerBits[i], for: .normal)
            }
        }
        
    }
    
    @objc func letterTapped(btn: UIButton){
        print("button \(btn) tapped")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

