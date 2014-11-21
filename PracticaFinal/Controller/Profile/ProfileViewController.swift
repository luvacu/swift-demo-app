//
//  ProfileViewController.swift
//  PracticaFinal
//
//  Created by Luis Valdés on 16/11/14.
//  Copyright (c) 2014 Luis Valdés. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate {
    var isPickingAPhoto = false
    var originalContentInsets = UIEdgeInsetsZero
    
    @IBOutlet var navigationBarItem: UINavigationItem!
    
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var labelGender: UILabel!
    
    @IBOutlet var viewEditProfilePhoto: UIVisualEffectView!
    @IBOutlet var buttonEditProfileGender: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.showEditingMode(editing: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShowNotification:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHideNotification:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // If the user left the view while editing, exit editing mode. Unless she is picking a photo
        if (!self.isPickingAPhoto) {
            self.showEditingMode(editing: false)
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    
    
    
    
    
    // MARK: - Navigation bar buttons
    
    func setUpNavigationBar(#editing: Bool) {
        if (editing) {
            let saveEditProfileButton   = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("saveEditProfileButtonClicked:"))
            navigationBarItem.rightBarButtonItem    = saveEditProfileButton
        } else {
            let editProfileButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("editProfileButtonClicked:"))
            navigationBarItem.rightBarButtonItem    = editProfileButton
        }
    }
    
    @IBAction func editProfileButtonClicked(sender: UIBarButtonItem!) {
        self.showEditingMode(editing: true)
    }
    
    @IBAction func saveEditProfileButtonClicked(sender: UIBarButtonItem!) {
        self.showEditingMode(editing: false)
    }
    
    // MARK: - Editing mode
    
    func showEditingMode(#editing: Bool) {
        self.setUpNavigationBar(editing: editing)
        if (editing) {
            self.viewEditProfilePhoto.hidden    = false
            self.buttonEditProfileGender.hidden = false
            self.textFieldName.enabled      = true
        } else {
            self.viewEditProfilePhoto.hidden    = true
            self.buttonEditProfileGender.hidden = true
            self.textFieldName.enabled      = false
        }
    }
    
    @IBAction func editProfilePhotoButtonClicked(sender: UIButton) {
        let pickerController        = UIImagePickerController()
        pickerController.sourceType = .PhotoLibrary
        pickerController.delegate   = self
        
        self.isPickingAPhoto = true
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func editGenderButtonClicked(sender: UIButton) {
        UIAlertView(title: "Gender", message: "Select gender", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Male", "Female")
            .show()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Retrieved the edited image first, if any, or the original image if the image was not edited by the user before returning
        var image: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        } else  if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
        }
        self.imageViewProfile.image = image
        
        self.isPickingAPhoto = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.isPickingAPhoto = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            self.labelGender.text = "Male"
        case 1:
            self.labelGender.text = "Female"
        default:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboardButtonClicked(nil)
        return true
    }
    
    // MARK: - Keyboard
    
    @IBAction func dismissKeyboardButtonClicked(sender: UIButton!) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard Notifications
    
    func keyboardDidShowNotification(notification: NSNotification) {
        let scrollview = self.view as UIScrollView
        if let kbSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size {
            self.originalContentInsets  = scrollview.contentInset
            let keyboardContentInsets   = UIEdgeInsetsMake(self.originalContentInsets.top, self.originalContentInsets.left, kbSize.height, self.originalContentInsets.right)
            scrollview.contentInset             = keyboardContentInsets;
            scrollview.scrollIndicatorInsets    = keyboardContentInsets;
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        let scrollview = self.view as UIScrollView
        scrollview.contentInset             = self.originalContentInsets;
        scrollview.scrollIndicatorInsets    = self.originalContentInsets;
    }
    
}
