//
//  HCColorRender.swift
//  MetalDemo
//
//  Created by Charlotte on 2020/11/19.
//

import Foundation
import Metal
import MetalKit
class HCColorRender: NSObject , MTKViewDelegate{
    
    var mtkView: MTKView?
    
    var device : MTLDevice?
    
    var commondQueue : MTLCommandQueue?
    
    
    convenience init(mtkView: MTKView) {
        self.init()
        self.mtkView = mtkView
        self.device = mtkView.device
        self.commondQueue = device?.makeCommandQueue()
    }
    
    struct Color {
        var red,green,blue,alpha : Double
    }
    
    var colorChannels : [Double] = [0.0, 0.0, 0.0, 1.0]
    var primaryChannel : UInt = 0
    var growing = true

    func makeFuncyColor() -> Color {
        
        
        
        
        let dynamicColorRate : Double = 0.015
        
        if growing{
            let dynamicChannelIndex = (primaryChannel+1)%3
            colorChannels[Int(dynamicChannelIndex)] += dynamicColorRate
            
            if colorChannels[Int(dynamicChannelIndex)] >= 1.0{
                growing = false
                primaryChannel = dynamicChannelIndex
            }
        }else{
            let dynamicChannelIndex = (primaryChannel+2)%3
            colorChannels[Int(dynamicChannelIndex)] -= dynamicColorRate
            if colorChannels[Int(dynamicChannelIndex)] <= 0.0{
                growing = true
            }
        }
        
        return Color(red: colorChannels[0], green: colorChannels[1], blue: colorChannels[2], alpha: colorChannels[3])
        
        
    }
    
    
    /// 当mtkview 视图发生大小变化，或重新布局时调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("视图大小变化或重新布局")
    }
    /// 当视图渲染时调用
    func draw(in view: MTKView) {
        
        let color = self.makeFuncyColor()
        
        
        view.clearColor = MTLClearColor(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
        
        let commondBuffer = self.commondQueue?.makeCommandBuffer()
        
        guard let descriptor = self.mtkView?.currentRenderPassDescriptor else {
            print("判断渲染描述符是否创建成功，否则跳过渲染")
            return
        }
        let renderEncoder = commondBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        renderEncoder?.label = "hc render encoder"
        renderEncoder?.endEncoding()
        
            /*
             当编码器结束之后,命令缓存区就会接受到2个命令.
             1) present
             2) commit
             因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.
            */
        
        
        if let drawable = self.mtkView?.currentDrawable{
            commondBuffer?.present(drawable)
            
            commondBuffer?.commit()
        }
        

    }
    
    
}

