//
//  UIView+SafeArea.swift
//  SKPhotoBrowserExample
//
//  Created by Hanguang on 2019/4/3.
//  Copyright © 2019 suzuki_keishi. All rights reserved.
//

import UIKit

extension UIApplication {
    static var safeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = shared.keyWindow?.safeAreaInsets {
                return safeAreaInsets
            }
        }
        return .zero
    }
    
    static var isLandscape: Bool {
        return shared.statusBarOrientation.isLandscape
    }
    
    static var isPortrait: Bool {
        return shared.statusBarOrientation.isPortrait
    }
}

public func generateTintedImage(image: UIImage?, color: UIColor, backgroundColor: UIColor? = nil) -> UIImage? {
    guard let image = image else {
        return nil
    }
    
    let imageSize = image.size
    
    UIGraphicsBeginImageContextWithOptions(imageSize, backgroundColor != nil, image.scale)
    if let context = UIGraphicsGetCurrentContext() {
        if let backgroundColor = backgroundColor {
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(origin: CGPoint(), size: imageSize))
        }
        
        let imageRect = CGRect(origin: CGPoint(), size: imageSize)
        context.saveGState()
        context.translateBy(x: imageRect.midX, y: imageRect.midY)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: -imageRect.midX, y: -imageRect.midY)
        context.clip(to: imageRect, mask: image.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(imageRect)
        context.restoreGState()
    }
    
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return tintedImage
}
