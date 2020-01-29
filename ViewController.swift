//
//  ViewController.swift
//  MemeMe
//
//  Created by Mobolaji Moronfolu on 4/10/17.
//  Copyright © 2017 Mobolaji Moronfolu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!

    @IBOutlet weak var shareBut: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3,  ]
    topTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = .none
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
         memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        if imagePickerView.image == nil {
            shareBut.isEnabled = false
        } else {
            shareBut.isEnabled = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickAnImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(_: imagePicker, animated: true, completion: nil)
    }}

    @IBAction func sharedButton(_ sender: Any) {
        let memeI = generateMemedImage();
        let activityViewController = UIActivityViewController(activityItems: [memeI], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            
            if success{
            self.save()
            self.dismiss(animated: true, completion: nil)
            }
            }
         self.present(_:activityViewController, animated: true, completion:nil)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(_:imagePicker, animated: true, completion: nil)
                    }}

    @IBAction func savedButton(_ sender: Any) {
        let collectionView = self.storyboard!.instantiateViewController(withIdentifier: "collectionView") as! SentMemesCollectionViewController
        
           } 
    
    func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        hide()
    }
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
     func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        
        return false
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
      textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    func save() {
         //Create the meme
    let memedImage = generateMemedImage()
       let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    func generateMemedImage() -> UIImage {
        
       hide()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.navigationController?.setToolbarHidden(false, animated: true)
    
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    func hide(){
        self.navigationController?.setNavigationBarHidden(true, animated:true)
        self.navigationController?.setToolbarHidden(true, animated: true)
           }
}

