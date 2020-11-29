//
//  MemeModel.swift
//  imagepicker
//
//  Created by Jimmy Gutierrez on 11/27/20.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
}

extension NSNotification.Name {
    static let memeArrayChanged = NSNotification.Name("memeArrayChanged")
}
