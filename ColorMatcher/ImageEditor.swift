//
//  ImageEditor.swift
//  ColorMatcher
//
//  Created by vdab cursist on 27/10/2017.
//  Copyright © 2017 vdab cursist. All rights reserved.
//

import UIKit

class ImageEditor: UIViewController {
    
    var editedImage:UIImage!
    @IBOutlet weak var myEditableImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myEditableImage.image = editedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
