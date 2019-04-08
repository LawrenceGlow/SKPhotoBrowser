//
//  SKDetectingImageView.swift
//  SKPhotoBrowser
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@objc protocol SKDetectingImageViewDelegate {
    func handleImageViewSingleTap(_ touchPoint: CGPoint)
    func handleImageViewDoubleTap(_ touchPoint: CGPoint)
}

class SKDetectingImageView: ASNetworkImageNode {
    weak var aDelegate: SKDetectingImageViewDelegate?
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
    override init(cache: ASImageCacheProtocol?, downloader: ASImageDownloaderProtocol) {
        super.init(cache: cache, downloader: downloader)
        setup()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        aDelegate?.handleImageViewDoubleTap(recognizer.location(in: view))
    }
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        aDelegate?.handleImageViewSingleTap(recognizer.location(in: view))
    }
}

private extension SKDetectingImageView {
    func setup() {
        isUserInteractionEnabled = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.require(toFail: doubleTap)
        view.addGestureRecognizer(singleTap)
    }
}
