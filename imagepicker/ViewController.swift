//
//  ViewController.swift
//  imagepicker
//
//  Created by Jimmy Gutierrez on 10/11/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeColor: UIColor.black,
        .strokeWidth: -3.0,
        .foregroundColor: UIColor.white
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemeTextField(textField: topTextField, text: "TOP")
        configureMemeTextField(textField: bottomTextField, text: "BOTTOM")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardHideNotifications()
    }
            
    func configureMemeTextField(textField: UITextField, text: String) {
            textField.delegate = self
            textField.text = text
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
        }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let items = [generatedMemedImage()]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
            // User completed activity
            self.save()
        }

        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        imagePickerView.image = .none
        configureMemeTextField(textField: topTextField, text: "TOP")
        configureMemeTextField(textField: bottomTextField, text: "BOTTOM")
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField {
        topTextField.text = ""
        } else {
        bottomTextField.text = ""
            subscribeToKeyboardNotifications()
            subscribeToKeyboardHideNotifications()
        }  
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == bottomTextField {
            unsubscribeFromKeyboardNotifications()
            unsubscribeFromKeyboardHideNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func pickImage(_ sender: Any) {
        pickAnImageFrom(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFrom(sourceType: .camera)
    }
    
    func pickAnImageFrom(sourceType: UIImagePickerController.SourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
        }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        print(keyboardSize.cgRectValue.height)
        return keyboardSize.cgRectValue.height

    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0//getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardHideNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardHideNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generatedMemedImage() -> UIImage {
        toolBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        shareButton.isHidden = true
        cancelButton.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        shareButton.isHidden = false
        cancelButton.isHidden = false
        return memedImage
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generatedMemedImage())
        
        let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
        
        print("MEME SAVED")
        print("\(appDelegate.memes.count)")
        self.dismiss(animated: true, completion: nil)
    }
}
