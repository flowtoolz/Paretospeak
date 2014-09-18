/*
    ParetoSpeak Main View Controller
*/

import UIKit

let bigFontSize: CGFloat = 40.0
let smallFontSize: CGFloat = 20.0

class PSMainVC: UIViewController, UITextFieldDelegate
{
    // MARK: properties
    
    weak var model: PSModel? = PSModel.sharedInstance
    
    var questionLabel: UILabel? = createQuestionLabel()
    var answerField: UITextField? = createAnswerTextField()
    var answerButtons: [UIButton]? = createAnswerButtons()
    var feedbackLabel: UILabel? = createFeedbackLabel()
    var feedbackTimer: NSTimer?
    var nextButton: UIButton? = createNextButton()
    
    // MARK: view delegate protocol
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        view.addSubview(questionLabel!)
        
        answerField!.delegate = self
        view.addSubview(answerField!)
        
        for button in answerButtons!
        {
            button.addTarget(self, action: "answerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            view.addSubview(button)
        }
        
        view.addSubview(feedbackLabel!)
        
        nextButton?.addTarget(self, action: "nextButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(nextButton!)
        
        poseQuestion()
    }
    
    // MARK: text field delegate protocol
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: interaction
    
    func poseQuestion()
    {
        questionLabel?.text = model?.currentQuestion
        
        answerField?.text = ""
        answerField?.backgroundColor = UIColor.lightGrayColor()
        answerField!.font = UIFont.systemFontOfSize(smallFontSize)
        setAnswerButtonsHidden(false)
        updateAnswerButtonTitles()
        feedbackLabel?.text = ""
        feedbackLabel?.hidden = true
        nextButton?.hidden = true
    }
    
    func answerButtonPressed(button: UIButton?)
    {
        if answerField?.text == ""
        {
            answerField!.font = UIFont.systemFontOfSize(bigFontSize)
        }
        
        answerField?.text = answerField!.text + button!.titleLabel.text
        
        model!.currentAnswer += button!.titleLabel.text
        
        if model!.possibleTranslationsForCurrentAnswer().isEmpty
        {
            giveFeedback(false)
        }
        else if model!.currentAnswerIsCorrect()
        {
            giveFeedback(true)
        }
        else
        {
            updateAnswerButtonTitles()
        }
    }
    
    func updateAnswerButtonTitles()
    {
        let characters = model!.allCharacterOptions()
        
        for (index, button) in enumerate(answerButtons!)
        {
            button.setTitle(String(characters[index]), forState: UIControlState.Normal)
        }
    }
    
    func setAnswerButtonsHidden(hidden: Bool)
    {
        for button in answerButtons!
        {
            button.hidden = hidden
        }
    }
    
    func giveFeedback(success: Bool)
    {
        setAnswerButtonsHidden(true)
        
        feedbackLabel?.text = model?.stringOfCorrectAnswers()
        
        if !success || feedbackLabel?.text != answerField?.text
        {
            feedbackLabel?.hidden = false
        }
        
        let feedbackColor = success ? UIColor.greenColor() : UIColor.redColor()
        
        answerField?.backgroundColor = feedbackColor
        
        nextButton?.hidden = false
        
        feedbackTimer = NSTimer.scheduledTimerWithTimeInterval(
            success ? 1.0 : 4.0,
            target: self,
            selector: Selector("nextButtonPressed"),
            userInfo: nil,
            repeats: false)
    }
    
    func nextButtonPressed()
    {
        feedbackTimer?.invalidate()
        
        model?.goToNextQuestion()
        
        poseQuestion()
    }
}

// MARK: helper functions

func createQuestionLabel() -> UILabel
{
    let screenSize = UIScreen.mainScreen().bounds.size
    let buttonSize = screenSize.width / 3
    let labelHeight = (screenSize.height - (3 * buttonSize)) / 3
    let labelFrame = CGRect(x: 0, y: 0, width: screenSize.width, height: labelHeight)
    var label = UILabel(frame: labelFrame)
    label.text = "Voce"
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.lightGrayColor()
    label.font = UIFont.systemFontOfSize(bigFontSize)
    
    return label
}

func createAnswerTextField() -> UITextField
{
    let screenSize = UIScreen.mainScreen().bounds.size
    let buttonSize = screenSize.width / 3
    let fieldHeight = (screenSize.height - (3 * buttonSize)) / 3
    let fieldFrame = CGRect(x: 0, y: fieldHeight, width: screenSize.width, height: fieldHeight)
    var answerField = UITextField(frame: fieldFrame)
    answerField.backgroundColor = UIColor.lightGrayColor()
    answerField.placeholder = "Translate to Portuguese."
    answerField.textAlignment = NSTextAlignment.Center
    answerField.font = UIFont.systemFontOfSize(smallFontSize)
    
    return answerField
}

func createFeedbackLabel() -> UILabel
{
    let screenSize = UIScreen.mainScreen().bounds.size
    let buttonSize = screenSize.width / 3
    let labelHeight = (screenSize.height - (3 * buttonSize)) / 3
    let labelFrame = CGRect(x: 0, y: 2 * labelHeight, width: screenSize.width, height: labelHeight)
    var label = UILabel(frame: labelFrame)
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.greenColor()
    label.font = UIFont.systemFontOfSize(smallFontSize)
    label.hidden = true
    
    return label
}

func createAnswerButtons() -> [UIButton]
{
    let screenSize = UIScreen.mainScreen().bounds.size
    
    var buttons = [UIButton]()
    
    let buttonSideLength = screenSize.width / 3
    let buttonSize = CGSize(width: buttonSideLength, height: buttonSideLength)
    
    for x in 0 ... 2
    {
        for y in 0 ... 2
        {
            let originX = CGFloat(x) * buttonSideLength
            let originY = CGFloat(y) * buttonSideLength + screenSize.height - 3 * buttonSideLength
            let buttonOrigin = CGPoint(x: originX, y: originY)
            let buttonFrame = CGRect(origin: buttonOrigin, size: buttonSize)
            var button = UIButton(frame: buttonFrame)
            button.setTitle("\(x + 3 * y)", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.lightGrayColor()
            button.titleLabel.font = UIFont.systemFontOfSize(bigFontSize)
            
            buttons.append(button)
        }
    }
    
    return buttons
}

func createNextButton() -> UIButton
{
    let screenSize = UIScreen.mainScreen().bounds.size
    let buttonSize = screenSize.width / 3
    let buttonFrame = CGRect(x: 0, y: screenSize.height - 3 * buttonSize, width: screenSize.width, height: 3 * buttonSize)
    var button = UIButton(frame: buttonFrame)
    button.setTitle("Next Word", forState: UIControlState.Normal)
    button.backgroundColor = UIColor.lightGrayColor()
    button.titleLabel.font = UIFont.systemFontOfSize(bigFontSize)
    
    return button
}