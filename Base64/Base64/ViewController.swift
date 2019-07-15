//
//  ViewController.swift
//  Base64
//
//  Created by 刘春奇 on 2018/10/26.
//  Copyright © 2018 cloudnapps. All rights reserved.
//

import Cocoa
import Quartz
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pictaker = IKPictureTaker.pictureTaker()
        
        
        pictaker?.begin(withDelegate: self, didEnd: #selector(selectEnd(sheet:returnCode:)), contextInfo: nil)
        
        
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    @objc func selectEnd(sheet: IKPictureTaker, returnCode:NSInteger){
        
        let image = sheet.outputImage()
        
        if returnCode == NSApplication.ModalResponse.OK.rawValue {
            let imageTiffData = image?.tiffRepresentation
            
            let imageRep = NSBitmapImageRep.init(data: imageTiffData!)
            
            let pngData = imageRep?.representation(using: .png, properties: [:])
            
            
            let base64String = pngData?.base64EncodedString() ?? "none base 64 string"
            
            let pasteBoard = NSPasteboard.general
            pasteBoard.writeObjects([base64String as NSPasteboardWriting])
            
            
            pasteBoard.clearContents()
            
            let success =  pasteBoard.setString(base64String, forType: .string)
            
            
            
            
            let alert = NSAlert.init()
            alert.alertStyle = .informational
            
            if success {
                alert.messageText = "复制成功"
            }else{
                alert.messageText = "复制失败"
            }
            
            alert.addButton(withTitle: "确定")
            alert.beginSheetModal(for: self.view.window!) { (response : NSApplication.ModalResponse) in
                if response.rawValue == NSApplication.ModalResponse.alertFirstButtonReturn.rawValue{
                    print("first btn click")
                }
            }
        }
        
    }
    
    
    
}

