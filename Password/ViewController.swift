//
//  ViewController.swift
//  Password
//
//  Created by Emerson Sampaio on 25/04/23.
//

import UIKit

class ViewController: UIViewController{
    typealias CustomValidation = PasswordTextField.CustomValidation
    
    let stackView = UIStackView()
    let newPasswordTextField = PasswordTextField(placeHolderText: "New Password")
    let statusView = passwordStatusView()
    let confirmPasswordTextField = PasswordTextField(placeHolderText: "Re-enter new password")
    let resetButon = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension ViewController {
    func setup(){
        setupNewPassword()
        setupConfirmPassword()
        setupDismissKeyboardGesture()
    }
    
    private func setupNewPassword() {
        let newPasswordValidation: CustomValidation = { text in
            
            guard let text = text, !text.isEmpty else {
                self.statusView.shouldResetCriteria = true
                self.statusView.reset()
                return (false, "enter password")
            }
            
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVXWYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                self.statusView.reset()
                return (false, "Enter valid special chars")
            }
            
            self.statusView.updateDisplay(text)
            if !self.statusView.validate(text){
                self.statusView.reset()
                return (false, "Your pass must meet the requirements below")
            }
            
            return (true, "")
        }
        
        newPasswordTextField.customValidation = newPasswordValidation
    }
    
    private func setupConfirmPassword(){
        let confirmPasswordValidation: CustomValidation = { text in
            
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password")
            }
            
            guard text == self.newPasswordTextField.text else{
                return (false, "Paswords do not match")
            }
            
            return (true, "")
        }
        
        confirmPasswordTextField.customValidation = confirmPasswordValidation
    }
    
    
    private func setupDismissKeyboardGesture(){
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func style(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.delegate = self
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 5
        statusView.clipsToBounds = true
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.delegate = self
        
        resetButon.translatesAutoresizingMaskIntoConstraints = false
        resetButon.configuration = .filled()
        resetButon.setTitle("Reset password", for: [])
        
    }
    
    func layout(){
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetButon)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ViewController: PasswordTextFieldDelegate {
    func editingDidEnd(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            _ = newPasswordTextField.validate()
        }
    }
    
    func editingChanged(_ sender: PasswordTextField) {
        if sender === newPasswordTextField {
            statusView.shouldResetCriteria = false
            statusView.updateDisplay(sender.textField.text ?? "")
        } else if sender == confirmPasswordTextField {
            _ = confirmPasswordTextField.validate()
        }
    }
}
