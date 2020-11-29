//
//  MemeDetailViewController.swift
//  imagepicker
//
//  Created by Jimmy Gutierrez on 11/28/20.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    var memedImage: UIImage?
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object
        return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        memeImageView.image = memedImage
    }

}
