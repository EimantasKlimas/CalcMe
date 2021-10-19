//
//  ViewController.swift
//  CalcMe
//
//  Created by Eimantas Klimas on 2021-10-14.
//

import UIKit

class ViewController: UIViewController {

    private var numberSequence: [String] = []
    private var operatorSequence: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
    }
    
    // MARK: - UI
    func generateButton(
        text: String,
        color: UIColor,
        isBig: Bool = false,
        action: Selector
    ) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if isBig {
            (button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)).isActive = true
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    lazy var outputLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 85)
        
        return label
    }()
    
    lazy var outputView: UIView = {
        let outputView = UIView(frame: CGRect.zero)
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.backgroundColor = .black
        outputView.addSubview(outputLabel)
        
        return outputView
    }()
        
    lazy var topStackView: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.5
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        ["AC","+/-","%","/"].map { oper in
            generateButton(
                text: oper,
                color: oper == "/" ? UIColor.orange : UIColor.darkGray,
                action: #selector(operationPressed)
            )
        }.forEach { button in
            stack.addArrangedSubview(button)
        }
        
        return stack
    }()
    
    lazy var middleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0.5
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        [
            ["7","8","9","X"],
            ["4","5","6","-"],
            ["1","2","3","+"]
        ].forEach { row in
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 0.5
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            row
                .enumerated()
                .map { (index, element) in
                    generateButton(
                        text: element,
                        color: (index != row.count - 1) ? UIColor.gray : UIColor.orange,
                        action: (index != row.count - 1) ? #selector(numberPressed) : #selector(operationPressed)
                    )
                }.forEach { button in
                    rowStack.addArrangedSubview(button)
                }
            
            stack.addArrangedSubview(rowStack)
        }
        
        return stack
    }()
    
    lazy var bottomStackView: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.5
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let zeroButton = generateButton(
            text: "0",
            color: UIColor.gray,
            isBig: true,
            action: #selector(numberPressed)
        )
        stack.addArrangedSubview(zeroButton)
        
        let elementStackView = UIStackView()
        elementStackView.axis = .horizontal
        elementStackView.spacing = 0.5
        elementStackView.alignment = .fill
        elementStackView.distribution = .fillEqually
        elementStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [",","="].map { oper in
            generateButton(
                text: oper,
                color: oper == "=" ? UIColor.orange : UIColor.gray,
                action: #selector(operationPressed)
            )
        }.forEach { button in
            elementStackView.addArrangedSubview(button)
        }
        
        stack.addArrangedSubview(elementStackView)
        
        return stack
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0.5
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(topStackView)
        stack.addArrangedSubview(middleStackView)
        stack.addArrangedSubview(bottomStackView)
        
        return stack
    }()
        
    
    func draw() {

        view.addSubview(outputView)
        view.addSubview(stackView)

        let outputViewConstraints = [
            outputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputView.topAnchor.constraint(equalTo: view.topAnchor),
            outputView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let outputLabelConstraints = [
            outputLabel.bottomAnchor.constraint(equalTo: outputView.bottomAnchor),
            outputLabel.trailingAnchor.constraint(equalTo: outputView.trailingAnchor, constant: -20),
            outputLabel.leadingAnchor.constraint(equalTo: outputView.leadingAnchor, constant: 20)
        ]
        
        let stackViewConstraints = [
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: outputView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
                
        
        let constraints =
        outputViewConstraints +
        outputLabelConstraints +
        stackViewConstraints
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func numberPressed(_ sender: UIButton) {
        
        let buttonNum = sender.currentTitle ?? "0"
        if numberSequence.count == operatorSequence.count || numberSequence.count == 0 {
            numberSequence.append(buttonNum)
        } else {
            numberSequence[numberSequence.count - 1] =
            numberSequence[numberSequence.count - 1] + buttonNum
        }
        
        outputLabel.text = numberSequence[numberSequence.count - 1]
    }
    
    @objc func operationPressed(_ sender: UIButton) {
        let buttonOperator = sender.currentTitle ?? "+"
        if(numberSequence.isEmpty) {
            numberSequence.append(outputLabel.text!)
        }
        switch buttonOperator {
        case "=":
            consumeSequences()
        case ",":
            numberSequence[numberSequence.count - 1] =
            numberSequence[numberSequence.count - 1] + buttonOperator
            
            outputLabel.text = numberSequence[numberSequence.count - 1]
        case "AC":
            operatorSequence = []
            numberSequence = []
            outputLabel.text = "0"
        case "+/-":
            if(numberSequence[numberSequence.count - 1] != "0") {
            numberSequence[numberSequence.count - 1] =
            (Double(numberSequence[numberSequence.count - 1])! * -1).toDisplay
            }
            outputLabel.text = numberSequence[numberSequence.count - 1]
        default:
            if numberSequence.count > operatorSequence.count || operatorSequence.count == 0 {
                operatorSequence.append(buttonOperator)
            } else {
                operatorSequence[operatorSequence.count - 1] = buttonOperator
            }
            
            outputLabel.text = "0"
        }
    }
    
    private func consumeSequences() {
        func doOperation(elementOne: Double, elementTwo: Double, operation: String) -> Double {
            switch operation {
            case "+":
                return elementOne + elementTwo
            case "%":
                return elementOne.truncatingRemainder(dividingBy: elementTwo)
            case "/":
                return elementOne / elementTwo
            case "X":
                return elementOne * elementTwo
            case "-":
                return elementOne - elementTwo
            default:
                return elementOne + elementTwo
            }
        }
        
        if numberSequence.count >= 2 {
            var result = doOperation(
                elementOne: numberSequence[0].toDouble(),
                elementTwo: numberSequence[1].toDouble(),
                operation: operatorSequence[0]
            )
            
            for (num, oper) in zip(numberSequence.dropFirst(2), operatorSequence.dropFirst(1)) {
                result = doOperation(elementOne: result, elementTwo: Double(num)!, operation: oper)
            }
            
            outputLabel.text = result.toDisplay
            
            numberSequence = []
            operatorSequence = []
        }
    }
}

extension Double {
    var toDisplay: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension String {
    func toDouble() -> Double {
        let formater = NumberFormatter()
        formater.decimalSeparator = ","
        
        return formater.number(from: self)!.doubleValue
    }
}

