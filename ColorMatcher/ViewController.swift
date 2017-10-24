//
//  ViewController.swift
//  ColorMatcher
//
//  Created by vdab cursist on 23/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var buttonRef: UIButton!
    @IBOutlet var myImageView: UIImageView!
    let picker = UIImagePickerController()
    var pix:PixelExtractor!
    var touchX:Int!
    var touchY:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        
        pix = PixelExtractor(img: (myImageView.image?.cgImage)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func imagePicked(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(picker, animated: true, completion: nil)
            
            /*imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)*/
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Your gallery isn't available.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo info: [NSObject : AnyObject]!) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageView.contentMode = .scaleAspectFit
        myImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }*/
    
    func imagePickerController(_picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageView.contentMode = .scaleAspectFit
        myImageView.image = chosenImage
        print(myImageView)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAct(_ sender: UIButton) {
        //buttonRef.backgroundColor = UIColor.black
        /*let newColor = pix.colorAt(x: 250, y: 250)
        buttonRef.backgroundColor = newColor
        buttonRef.tintColor = UIColor.white*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        print(location.x)
        print(location.y)
        let newColor = pix.colorAt(x: Int(location.x), y: Int(location.y))
        buttonRef.backgroundColor = newColor
        buttonRef.tintColor = UIColor.white
    }
    
}

