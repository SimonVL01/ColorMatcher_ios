//
//  ImageEditor.swift
//  ColorMatcher
//
//  Created by vdab cursist on 27/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import UIKit
import CoreGraphics

class ImageEditor: UIViewController {
    
    @IBOutlet weak var originalImage: UIImageView!
    var prevImage:UIImage!
    @IBOutlet weak var editedImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let button = sender as UIButton
        
        editedImage.image = button.backgroundImage(for: UIControlState.normal)
    }
    
    /*override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage.image = prevImage
        
        self.navigationItem.backBarButtonItem?.title = "cancel"
        
        var xCoord:CGFloat = 5
        let yCoord:CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight:CGFloat = 70
        let gapBetweenButtons:CGFloat = 5
        
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(origin: CGPoint(x: xCoord, y: yCoord), size: CGSize(width: buttonWidth, height: buttonHeight))
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(ImageEditor.filterButtonTapped(_:)), for: .touchUpInside)
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            
            //Make correction to loading time
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            xCoord += buttonWidth + gapBetweenButtons
            scrollView.addSubview(filterButton)
        }
        
        scrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount + 2), height: yCoord)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePicButton(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(editedImage.image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Filters",
                                      message: "Your image has been saved to your library",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in print("Ok button pressed") }))
        
        present(alert, animated: true, completion: nil)
        
        //Return segue
    }
    
    /*@IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {

    }*/
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterAdded" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.myImageView = editedImage
            }
        }
    }*/

}

var CIFilterNames = [
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone"
]
