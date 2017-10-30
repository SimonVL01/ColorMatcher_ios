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
    var firstTitleColor:UIColor!
    
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
            print("Camera clicked")
    }
    
    @IBAction func imageMaker(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openPhotoLibraryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        buttonRef.backgroundColor = pix.getPixelColorAtPoint(point: location, sourceView: myImageView)
        print(buttonRef.backgroundColor as Any)
        
        buttonRef.tintColor = UIColor.white
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ColorSegue" {
            if let destinationVC = segue.destination as? CosmeticsList {
                //destinationVC.colorValue = buttonRef.backgroundColor
                destinationVC.colorName = "Matches for your color"
                destinationVC.colorValue = buttonRef.backgroundColor
                destinationVC.firstTitleColor = self.navigationController!.navigationBar.barTintColor
            }
        }
        
        if segue.identifier == "photoTransfer" {
            if let destinationVC = segue.destination as? UINavigationController {
                if let targetController = destinationVC.topViewController as? ImageEditor {
                targetController.originalImage.image = myImageView.image
                    
                }
            }
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
     }
    
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.myImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
}
