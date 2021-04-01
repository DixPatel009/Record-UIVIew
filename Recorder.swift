//
//  Recorder.swift
//  recordUIVIew
//
//  Created by Dixit Akabari on 3/25/21.
//  Copyright © 2020 Dixit Akabari. All rights reserved.
//

import UIKit

@objc public class Recorder: NSObject {
    
    var displayLink : CADisplayLink?
    var outputPath : NSString?
    var referenceDate : NSDate?
    var imageCounter = 0
    
    public var view : UIView?
    public var name = "image"
    public var outputJPG = false
    
    var imagesArray = [URL]()
    
    public func start() {
        
        if (view == nil) {
            NSException(name: NSExceptionName(rawValue: "No view set"), reason: "You must set a view before calling start.", userInfo: nil).raise()
        }
        else {
            
            self.removeAllFileFromDocumentDirectory()
            self.imageCounter = 0
            
            displayLink = CADisplayLink(target: self, selector: #selector(self.handleDisplayLink(displayLink:)))
            displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            referenceDate = NSDate()
        }
    }
    
    public func stop(completion: @escaping (_ saveURL: String) -> Void) {
        
        displayLink?.invalidate()
        
        let seconds = referenceDate?.timeIntervalSinceNow
        if (seconds != nil) {
                        
            let animator = ImageAnimator(renderSettings: RenderSettings(), imagearr: self.imagesArray)
            
            animator.render {
                let u: String = tempurl
                completion(u)
            }
                
        }
        
    }
    
    func removeAllFileFromDocumentDirectory(){
                
        let fileManager = FileManager.default
        let documentsUrl =  self.applicationDocumentsDirectory
        let documentsPath = documentsUrl.path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            
            for fileName in fileNames {
                if (fileName.hasSuffix(".jpg")) {
                    let filePathName = "\(documentsPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                }
            }
            
            try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        
        self.imagesArray.removeAll()
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as URL
        
    }()
    
    @objc func handleDisplayLink(displayLink : CADisplayLink) {
        if (view != nil) {
            createImageFromView(captureView: view!)
        }
    }
    
    func outputPathString() -> String {
        if (outputPath != nil) {
            return outputPath! as String
        }
        else {
            return applicationDocumentsDirectory.absoluteString
        }
    }
    
    func createImageFromView(captureView : UIView) {
        
        UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, false, 0)
        captureView.drawHierarchy(in: captureView.bounds, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        let fileExtension = "jpg"
        let data : Data? = image?.jpegData(compressionQuality: 1)
        
        var path = outputPathString()
        path = path + "/\(name)-\(imageCounter).\(fileExtension)"
        
        imageCounter = imageCounter + 1
        
        self.imagesArray.append(URL(string: path)!)
        
        if let imageRaw = data {
            do {
                try imageRaw.write(to: URL(string: path)!, options: .atomic)
            } catch {
            }
        }
        
        UIGraphicsEndImageContext()
        
    }
    
}
