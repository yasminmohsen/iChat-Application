//
//  LoginViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/26/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController ,UITextFieldDelegate{
    
    
    private let spinner=JGProgressHUD(style: .dark)
    private let scrollView:UIScrollView = {
        
       let scrollView=UIScrollView()
        
        scrollView.clipsToBounds=true
      return scrollView
    }()
    
    
    private  let emailField:UITextField = {
      let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth=1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder="Email Address ...."
        field.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
       field.backgroundColor = .white
    
        
        return field
        
    }()
    
    
    
    
    private  let passwordField:UITextField = {
         let field=UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .done
           field.layer.cornerRadius = 12
           field.layer.borderWidth=1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder="Password ...."
           field.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
          field.backgroundColor = .white
        field.isSecureTextEntry = true
           
           return field
           
       }()
    
    
    private let loginButton:UIButton={
     
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        
        button.backgroundColor=UIColor(cgColor: #colorLiteral(red: 1, green: 0.8160473704, blue: 0.3901621103, alpha: 1).cgColor)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius=12
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    private let registerButton:UIButton={
     
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        
        button.backgroundColor=UIColor(cgColor: #colorLiteral(red: 0.5176470588, green: 0.7411764706, blue: 0.5725490196, alpha: 1).cgColor)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius=12
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    
    private let imageView:UIImageView = {
        
        let imageView=UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
    return imageView
    }()
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
          if scoreText == emailField
          {
            passwordField.becomeFirstResponder()
        }
        
        
        if scoreText == passwordField
          {
           loginBtnTapped()
        }
           return true
       }
       
       
       // function to enable dimiss key board(touch any where )
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
       
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
         title="LogIn"

        
        emailField.delegate=self
        passwordField.delegate=self
        
        view.backgroundColor = .white
        
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        
        //Add subView
        view .addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame=view.bounds
        
        
        
        let size=scrollView.width/3
        imageView.frame=CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
        
        
        emailField.frame=CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        
            passwordField.frame=CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        
         loginButton.frame=CGRect(x: 30, y: passwordField.bottom+20, width: scrollView.width-60, height: 52)
        
        registerButton.frame=CGRect(x: 30, y: loginButton.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    
    @objc private func didTapRegister(){
        
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)

 
        
    }

    
    @objc private func loginBtnTapped(){
           
        if emailField.text == nil || emailField.text!.isEmpty   {
            alert(message: "Please Enter Email Address")
        }
    
       else  if passwordField.text == nil || passwordField.text!.isEmpty  {
                   alert(message: "Please Enter Password")
               }
           
        
        else if passwordField.text!.count<6 {
            alert(message: "Please Enter Password more than 6 charachter")
        }
        
        
        else{
            
            
            spinner.show(in: view)
            
            login(email: emailField.text!, password: passwordField.text!)
        }
       }

   
    // firebase func :
    
    
    
    
    
    
    
    func alert (message : String){
        
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel, handler: nil))
        
        present (alert,animated: true)
        
    }
    
    
    func login(email: String, password: String){
        

               Auth.auth().signIn(withEmail: email, password: password) { [weak self]authResult, error in
                
                guard let strongSelf = self else {
                    return
                }
                   if authResult != nil {
                       print ("Successful login")
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss()
                    }
                    
                  strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                   }
                   else {
                    DispatchQueue.main.async {
                                          strongSelf.spinner.dismiss()
                                      }
                                      
                    print ("fail")
                    strongSelf.alert(message: "invalid information")
                   }
               }
           }
        
  
    
}
