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
    @IBOutlet weak var answerOrNumLettersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var allButtons = [UIButton]()
    var usedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    @IBAction func submitTapped(_ sender: UIButton) {
        print("submit tapped \(sender)")
        
        if let solutionIndex = solutions.index(of: currentAnswer.text!){
            usedButtons.removeAll()
            
            var splitAnswers = answerOrNumLettersLabel.text!.components(separatedBy: "\n")
            splitAnswers[solutionIndex] = currentAnswer.text!
            answerOrNumLettersLabel.text = splitAnswers.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            //check if done
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        print("clear tapped \(sender)")
        currentAnswer.text = ""
        
        for btn in usedButtons {
            btn.isEnabled = true
            btn.isHidden = false
        }
        usedButtons.removeAll()
    }
    
    @objc func letterTapped(btn: UIButton){
        print("button \(btn) tapped")
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        usedButtons.append(btn)
        btn.isEnabled = false
        btn.isHidden = true
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
    
    func levelUp(action: UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in allButtons{
            btn.isEnabled = true
            btn.isHidden = false
        }
    }
    
    func loadLevel(){
        var clue = ""
        var numberOfLettersHint = ""
        var allAnswerBits = [String]()
        
        //open weird format level file, parse it
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
        answerOrNumLettersLabel.text = numberOfLettersHint.trimmingCharacters(in: .whitespacesAndNewlines)
        
        allAnswerBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allAnswerBits) as! [String]
        
        if allAnswerBits.count == allButtons.count {
            for i in 0 ..< allAnswerBits.count{
                allButtons[i].setTitle(allAnswerBits[i], for: .normal)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

