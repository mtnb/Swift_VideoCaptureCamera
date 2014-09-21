//
//  RootViewController.swift
//  VideoCaptureCamera
//
//  Created by Muto Nobuhito on 2014/09/20.
//  Copyright (c) 2014年 Muto Nobuhito. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if segue.identifier == "Camera" {

        }
    }


}

