//
//  ViewController.swift
//  MemeMe
//
//  Created by Abhishek Singh on 4/5/18.
//  Copyright © 2018 vibha. All rights reserved.
//

import UIKit

class AddMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
     var isDefaultText: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareClicked))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClicked))
       // self.navigationItem.
        
        self.view.backgroundColor = UIColor.black
        setTextField(topTextField, withText: "TOP")
        setTextField(bottomTextField,  withText: "BOTTOM")
    }

    let memetextAttributes: [String : Any] = [
        
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0,
       // NSAttributedStringKey.backgroundColor.rawValue: UIColor.clear
    ]

    
    func setTextField(_ textField: UITextField, withText: String){
    
        textField.defaultTextAttributes = memetextAttributes
        textField.backgroundColor = UIColor.clear
      //  textField.textColor = UIColor.white
        textField.textAlignment = .center
        textField.text = withText
        textField.delegate = self
      
    }
    
    
    // Sign up to be notified when the keyboard appears
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribetoKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:.UIKeyboardWillHide , object: nil)
        
    }
    
    
    func unsubscribetoKeyboardNotifications(){
        
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    //MARK: - Keyboard notification
    
    @objc func keyboardWillShow(_ notification : Notification){
        
        if bottomTextField.isEditing{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
        
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        
        view.frame.origin.y = 0
        
    }
    
    
    func generateMemedImage() -> UIImage {
        
        
        self.navigationController?.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
         self.navigationController?.navigationBar.isHidden = false
         self.toolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let mImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: mImage)
        let object = UIApplication.shared.delegate as! AppDelegate
        object.memes.append(meme)
        let notification = Notification(name: .init("memeDidUpdate"))
        NotificationCenter.default.post(notification)
        print("\(object.memes.count)")
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @objc func
        shareClicked(){
        
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .assignToContact, .copyToPasteboard, .openInIBooks]
        activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        


        present(activityVC, animated: true, completion: nil)
        
        
    }
    
    
    
    @objc func
        cancelClicked(){
        
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage){
            
            imagePickerView.image = image
        
           dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    
    
}

extension AddMemeViewController: UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isDefaultText {
            textField.text = ""
            isDefaultText = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
