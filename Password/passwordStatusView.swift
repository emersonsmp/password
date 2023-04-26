//
//  passwordStatusView.swift
//  Password
//
//  Created by Emerson Sampaio on 26/04/23.
//

import Foundation
import UIKit

class passwordStatusView: UIView{
    
    let stackView = UIStackView()
    
    let passwordCriteriaView1 = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let criteriaLabel = UILabel()
    let passwordCriteriaView2 = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let passwordCriteriaView3 = PasswordCriteriaView(text: "lowercase letter (a-z)")
    let passwordCriteriaView4 = PasswordCriteriaView(text: "digit (0-9)")
    let passwordCriteriaView5 = PasswordCriteriaView(text: "special character (e.g. !@#$%ˆ)")
    
    private var shouldResetCriteria: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension passwordStatusView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        
        passwordCriteriaView1.translatesAutoresizingMaskIntoConstraints = false
        
//        criteriaLabel.text = "Use at least 3 of these 4 criteria when sething your password:"
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
        criteriaLabel.attributedText = makeCriteriaMessage()
        
        passwordCriteriaView2.translatesAutoresizingMaskIntoConstraints = false
        passwordCriteriaView3.translatesAutoresizingMaskIntoConstraints = false
        passwordCriteriaView4.translatesAutoresizingMaskIntoConstraints = false
        passwordCriteriaView5.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        
        stackView.addArrangedSubview(passwordCriteriaView1)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(passwordCriteriaView2)
        stackView.addArrangedSubview(passwordCriteriaView3)
        stackView.addArrangedSubview(passwordCriteriaView4)
        stackView.addArrangedSubview(passwordCriteriaView5)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        //tratando problemas com ambiguidade em stackview com 3 abordagens diferentes
        //- sete o tamanho na constraint (height)
        //- altere o intrinsicContentSize
        //- nao pine sua stackview em bottom
        //- set stack.distribuition
        
    }
    
    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)

        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))

        return attrText
    }
}

extension passwordStatusView {
    func updateDisplay(_ text: String){
        let lengthAndNoSpaceMet = PasswordCriteria.lenghtAndNoSpaceMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialMet = PasswordCriteria.specialCharacterMet(text)
        
        if shouldResetCriteria{
            lengthAndNoSpaceMet ? passwordCriteriaView1.isCriteriaMet = true :
            passwordCriteriaView1.reset()
            
            uppercaseMet ? passwordCriteriaView2.isCriteriaMet = true :
            passwordCriteriaView2.reset()
            
            lowercaseMet ? passwordCriteriaView3.isCriteriaMet = true :
            passwordCriteriaView3.reset()
            
            digitMet ? passwordCriteriaView4.isCriteriaMet = true :
            passwordCriteriaView4.reset()
            
            specialMet ? passwordCriteriaView5.isCriteriaMet = true :
            passwordCriteriaView5.reset()
        }
    }
}
