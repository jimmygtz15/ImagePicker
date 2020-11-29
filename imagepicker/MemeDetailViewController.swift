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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        memeImageView.image = memedImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
