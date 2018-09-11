//
//  UIImage+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/29/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func centerCrop(width: Double, height: Double) -> UIImage {
        
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    
    static func getDefaultImageWithInitialName(name: String, parentView: UIView, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        parentView.draw(rect)
        var text = ""
        let words = name.split(separator: " ")
        if words.count >= 2 {
            text = "\(words[0].capitalized.first!)\(words[1].capitalized.first!)"
        }else {
            if name == "" {
                text = String(" ".capitalized.first!)
            } else {
                text = String(name.capitalized.first!)
            }
        }
        let percentRed = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let percentGreen = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let percentBlue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let nameLbl = UILabel()
        nameLbl.frame.size = size
        nameLbl.textColor = UIColor.white
        nameLbl.font = UIFont.boldSystemFont(ofSize: 16)
        nameLbl.text = text
        nameLbl.textAlignment = NSTextAlignment.center
        nameLbl.backgroundColor = UIColor(red:percentRed, green:percentGreen, blue:percentBlue, alpha:1.0)
        nameLbl.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
