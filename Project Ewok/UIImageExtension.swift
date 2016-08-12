//
//  UIImageExtension.swift
//  Project Ewok
//
//  Created by asap on 8/12/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    /**
     This extension allows you to simply call setImageFromID(pictureID) to set the image to that picture in the DB asynchronously
     
     Example:
     var image = UIImageView
     image.setImageFromID(3);
     */
    
    public func setImageFromID(pictureID: Int){
        //PRE: the picture ID must match a picture in the DB
        //POST: sets the image to the image of the picture with the ID specified
        let interface = ApiInterface();
        interface.getPicture(pictureID, completion: setImageFromData);
    }
    
    public func setImageFromModel(picture: PictureModel){
        //PRE: the picture model must have been grabbed from the DB
        //POST: sets the image to the image of the picture model specified
        setImageFromID(picture.pictureID);
    }
    
    public func setImageFromData(data: NSData){
        self.image = UIImage(data: data);
    }
}