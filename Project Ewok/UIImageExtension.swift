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
    
    public func setImageFromAttachedID(ID: Int, model: String){
        //PRE: the ID of the attached model and the name of the attached model (farm, geolocation, etc.)
        //POST: sets the image of the UIImageView to the first image found from that model
        let interface = ApiInterface();
        interface.getPicture(itemID: ID, model: model, completion: setImageFromData);
    }
    
    public func setImageFromPictureID(pictureID: Int){
        //PRE: the picture ID must match a picture in the DB
        //POST: sets the image to the image of the picture with the ID specified
        let interface = ApiInterface();
        interface.getPicture(pictureID, completion: setImageFromData);
    }
    
    public func setImageFromPictureModel(picture: PictureModel){
        //PRE: the picture model must have been grabbed from the DB
        //POST: sets the image to the image of the picture model specified
        setImageFromPictureID(picture.pictureID);
    }
    
    public func setImageFromData(data: NSData){
        self.image = UIImage(data: data);
    }
}

extension UIImage {
    internal func upload(attachedModel: String, attachedID: Int){
        let interface = ApiInterface();
        interface.createNewPicture(image: self, attachedModel: attachedModel, attachedID: attachedID);
    }
}