//
//  DetailViewController.swift
//  Recipe on Demand
//
//  Created by Prasad Kumar on 6/25/16.
//  Copyright © 2016 Aadya. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nDish: UILabel!
    var dishName: String?
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var imgpick = [String : String]()
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var preperationTextView: UITextView!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if objects.count == 0 {
           return
        }
        if let label = self.preperationTextView {
            print(label.text!)
            label.text = objects[currentIndex]
            if label.text == BLANK_RECIPE {
                label.text = ""
            }
        }
    }
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            //let img = UIImage() //Change to be from UIPicker
            let data = UIImagePNGRepresentation(pickedImage)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: preperationTextView.text!)
            NSUserDefaults.standardUserDefaults().synchronize()
            //print(text)
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    // Function to cancel if user cancels to pick a photo
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        detailViewController = self
        // Enable keyboad to popout
        preperationTextView.becomeFirstResponder()
        if dishName != nil{
            nDish.text = dishName
        }
        self.configureView()
        if let imgData = NSUserDefaults.standardUserDefaults().objectForKey(preperationTextView.text!) as? NSData {
            let retrievedImg = UIImage(data: imgData)
            print(retrievedImg)
            imageView.image=retrievedImg
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if objects.count == 0 {
            return
        }
        // Specify that a recipe is blank if no data is entered
        objects[currentIndex] = preperationTextView.text
        if preperationTextView.text == "" {
            objects[currentIndex] = BLANK_RECIPE
        }
    saveAndUpdate()
    }
    
    // Function to save and update individual recipes
    func saveAndUpdate() {
    masterView?.save()
    masterView?.tableView.reloadData()
    }

}

