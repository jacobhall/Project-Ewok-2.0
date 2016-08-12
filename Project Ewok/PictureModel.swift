//
//  PictureModel.swift
//  Project Ewok
//
//  Created by asap on 8/12/16.
//  Copyright © 2016 ASAP. All rights reserved.
//

import Foundation

public class PictureModel {
    //Properties
    let pictureID: Int;         //The ID in the database
    let attachedModel: String;  //The model this is attached to
    let attachedID: Int;        //The ID of the model this is attached to
    var filePath: String;       //The filePath. DO NOT LET VAR DECEIVE YOU; YOU SHOULD NOT CHANGE THIS MANUALLY!
    
    //Constructors
    init(pictureID: Int, attachedModel: String, attachedID: Int, filePath: String){
        self.pictureID = pictureID;
        self.attachedID = attachedID;
        self.attachedModel = attachedModel;
        self.filePath = filePath;
    }
    
    //Functions
}