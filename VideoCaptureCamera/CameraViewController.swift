//
//  CameraViewController.swift
//  VideoCaptureCamera
//
//  Created by Muto Nobuhito on 2014/09/21.
//  Copyright (c) 2014年 Muto Nobuhito. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary


class CameraViewController: UIViewController {

    var sessionQueue : dispatch_queue_t?
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoDevice:AVCaptureDevice?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureCamera()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCamera() -> Bool{
        //init camera device
        var captureDevice: AVCaptureDevice?
        var devices: NSArray = AVCaptureDevice.devices()
        
        // find back camera
        for device: AnyObject in devices {
            if device.position == AVCaptureDevicePosition.Back {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        if (captureDevice != nil) {
            // Debug
            println(captureDevice!.localizedName)
            println(captureDevice!.modelID)
        } else {
            println("Missing Camera")
            return false
        }
        
        
        // TODO: Handle errors
        var error:NSError?
        videoDevice = CameraViewController.device(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back)
        let videoDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice!, error: &error) as AVCaptureDeviceInput
        
        self.stillImageOutput = AVCaptureStillImageOutput()
        
        // init session
        self.session = AVCaptureSession()
        self.session!.sessionPreset = AVCaptureSessionPresetPhoto
        self.session!.addInput(videoDeviceInput as AVCaptureInput)
        self.session!.addOutput(self.stillImageOutput)
        
        // layer for preview
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as? AVCaptureVideoPreviewLayer
        previewLayer?.frame = self.view.bounds
        PreviewView.layer.addSublayer(previewLayer)
        
        self.session!.startRunning()
        
        return true
        
    }
    
    func takePict(sender: AnyObject){

        var layer : AVCaptureVideoPreviewLayer = previewLayer! as AVCaptureVideoPreviewLayer
        
        self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo).videoOrientation = layer.connection.videoOrientation
        
        var error:NSError
        
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo), completionHandler: {
            (imageDataSampleBuffer,error) -> Void in
            if ((imageDataSampleBuffer) != nil) {
                var imageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                var image : UIImage = UIImage(data: imageData)
                ALAssetsLibrary().writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation.fromRaw(image.imageOrientation.toRaw())!, completionBlock: nil)
            }
        })

    }
    
    func processImage(img:UIImage){
        
    }
    
    
    @IBOutlet weak var PreviewView: UIView!

    @IBAction func CancelButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func PictButton(sender: AnyObject) {
        self.takePict(sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Preview" {
            //キャプチャした画像をここで次のsegueに渡すとか？
        }
    }
    
    class func device(mediaType: NSString!, position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        var devices = AVCaptureDevice.devicesWithMediaType(mediaType) as [AVCaptureDevice]
        
        if devices.isEmpty {
            return nil
        }
        
        var captureDevice = devices[0]
        for device in devices {
            if device.position == position {
                captureDevice = device
                break
            }
        }
        return captureDevice
    }
    

}
