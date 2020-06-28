//
//  RegisterViewController.swift
//  IChat
//
//  Created by yasmin mohsen on 6/26/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {
   private let spinner=JGProgressHUD(style: .dark)
    var imagePicker: ImagePicker!
    private let scrollView:UIScrollView = {
        
        let scrollView=UIScrollView()
        
        scrollView.clipsToBounds=true
        return scrollView
    }()
    
    
    private  let firstNameField:UITextField = {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth=1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder="First Name ...."
        field.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        
        return field
        
    }()
    
    
    
    private  let lastNameField:UITextField = {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth=1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder="Last Name...."
        field.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        
        return field
        
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
    
    
    private let register:UIButton={
        
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        
        button.backgroundColor=UIColor(cgColor: #colorLiteral(red: 1, green: 0.8160473704, blue: 0.3901621103, alpha: 1).cgColor)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius=12
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    
    
    
    
    private let imageView:UIImageView = {
        
        let imageView=UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .redraw
        imageView.layer.masksToBounds=true
        imageView.layer.borderColor=UIColor.gray.cgColor
        imageView.layer.borderWidth=2
        
        return imageView
    }()
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        
        if scoreText == firstNameField
        {
            lastNameField.becomeFirstResponder()
        }
        
        if scoreText == lastNameField
        {
            emailField.becomeFirstResponder()
        }
        
        if scoreText == emailField
        {
            passwordField.becomeFirstResponder()
        }
        
        
        if scoreText == passwordField
        {
            registerBtnTapped()
        }
        return true
    }
    
    
    // function to enable dimiss key board(touch any where )
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Register"
        
        
        emailField.delegate=self
        passwordField.delegate=self
        
        view.backgroundColor = .white
        
        
        
        register.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
        
        //Add subView
        view .addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(register)
        
        // to add geasture to pick a profile picture
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedProfilePic))
    
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired=1
        
        scrollView.isUserInteractionEnabled=true
        imageView.isUserInteractionEnabled=true
        
        imageView.addGestureRecognizer(gesture)
     
     imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame=view.bounds
        
        
        
        let size=scrollView.width/3
        imageView.frame=CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
        firstNameField.frame=CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        lastNameField.frame=CGRect(x: 30, y: firstNameField.bottom+10, width: scrollView.width-60, height: 52)
        
        emailField.frame=CGRect(x: 30, y: lastNameField.bottom+10, width: scrollView.width-60, height: 52)
        
        
        passwordField.frame=CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        
        register.frame=CGRect(x: 30, y: passwordField.bottom+20, width: scrollView.width-60, height: 52)
        
        
    }
    
    
    
    
    // selectors :
    
    @objc private func didTapRegister(){
        
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
 
    
    @objc private func didTappedProfilePic(_ sender: UIButton){
        
        self.imagePicker.present(from: sender as UIView)
        
    }
    
    @objc private func registerBtnTapped(){
        
        
        if firstNameField.text == nil || firstNameField.text!.isEmpty   {
                   alert(message: "Please Enter First Name")
               }
        
        if lastNameField.text == nil || lastNameField.text!.isEmpty   {
                   alert(message: "Please Enter Last Name")
               }
        
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
            
            
            
            DatabaseManager.shared.userExists(with: emailField.text!) {[weak self](exists) in
                
                guard let strongSelf = self else{
                              
                              return
                          }
                            
                guard !exists else{
                    
                    strongSelf.alert(message: "email is already exisits")
                    //user already exisis
                    return
                }
                
                
                
            }
            
            spinner.show(in: view)
            
            signUp(email: emailField.text!, password: passwordField.text!)
           
        }
    }
    
    
    
    // firebase func :
    
    
    
    
    
    func alert (message : String){
        
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel, handler: nil))
        
        present (alert,animated: true)
        
    }
    
    
    
    
    
    func signUp(email:String , password:String){
        
        
          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
          
              if let x = error {
                  let err = x as NSError
                  switch err.code {
                  case AuthErrorCode.wrongPassword.rawValue:
                      print("wrong password")
                    
                  case AuthErrorCode.invalidEmail.rawValue:
                      print("invalid email")
                  case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                      print("accountExistsWithDifferentCredential")
                  case AuthErrorCode.emailAlreadyInUse.rawValue:
                      print("Email is already exist")
          
                  default:
                      print("unknown error: \(err.localizedDescription)")
                   
                  }
                  
              }
              else if authResult != nil {
                
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, email: self.emailField.text!, profilePic: ""))
                
                DispatchQueue.main.async {
                                      self.spinner.dismiss()
                                  }
                  self.navigationController?.dismiss(animated: true, completion: nil)
               print("UserCreated")
              }
          }
        
    }
    
    
}



extension RegisterViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        imageView.image=image
    }
    
    
    
    
 

    
}

