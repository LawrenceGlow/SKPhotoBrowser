//
//  SKOptionalActionView.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/19.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import UIKit

class SKActionView: UIView {
    var style: SKPhotoBrowser.BrowserStyle!
    weak var browser: SKPhotoBrowser?
    var topBlurView: VisualEffectView!
    var bottomBlurView: VisualEffectView!
    var closeButton: UIButton!
    var countLabel: UILabel!
    var moreButton: UIButton!
    
    // Action
    fileprivate var cancelTitle = "Cancel"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser, style: SKPhotoBrowser.BrowserStyle = .default) {
        self.init(frame: frame)
        self.browser = browser
        self.style = style
        
        topBlurView = VisualEffectView()
        topBlurView.colorTint = .black
        topBlurView.colorTintAlpha = 0.5
        topBlurView.blurRadius = 10
        
        addSubview(topBlurView)
        
        bottomBlurView = VisualEffectView()
        bottomBlurView.colorTint = .black
        bottomBlurView.colorTintAlpha = 0.5
        bottomBlurView.blurRadius = 10
        addSubview(bottomBlurView)
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "browser_close_button"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        topBlurView.contentView.addSubview(closeButton)
        
        countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 17)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        topBlurView.contentView.addSubview(countLabel)
        
        moreButton = UIButton(type: .custom)
        if style == .default {
            moreButton.setImage(UIImage(named: "browser_more_icon"), for: .normal)
            moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        } else {
            moreButton.setImage(UIImage(named: "browser_delete_icon"), for: .normal)
            moreButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        }
        
        topBlurView.contentView.addSubview(moreButton)
        
        
        let button = UIButton(type: .detailDisclosure)
        //        UIButton(type: .system)
        //        button.setImage(UIImage(named: "browser_share_icon"), for: .normal)
        button.frame = CGRect(
            x: (frame.width-100)/2,
            y: (frame.height-35)/2,
            width: 100,
            height: 35
        )
        button.addTarget(browser, action: #selector(SKPhotoBrowser.shareButtonPressed), for: .touchUpInside)
        addSubview(button)
        shareButton = button
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if closeButton.frame.contains(point) || moreButton.frame.contains(point) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
        topBlurView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 88)
        bottomBlurView.frame = CGRect(x: 0, y: frame.height-130, width: frame.width, height: 130)
        closeButton.frame = CGRect(x: 16.0, y: UIApplication.safeInsets.top, width: 44.0, height: 44.0)
        countLabel.frame = CGRect(x: (topBlurView.contentView.frame.width-200)/2, y: UIApplication.safeInsets.top, width: 200, height: 44)
        moreButton.frame = CGRect(x: topBlurView.contentView.frame.width-44-6, y: UIApplication.safeInsets.top, width: 44, height: 44)
        setNeedsDisplay()
    }
    
    func animate(hidden: Bool) {
//        let closeFrame: CGRect = hidden ? closeButton.hideFrame : closeButton.showFrame
//        let deleteFrame: CGRect = hidden ? deleteButton.hideFrame : deleteButton.showFrame
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in
                        self.closeButton.alpha = alpha
                        self.moreButton.alpha = alpha
                        self.topBlurView.blurRadius = hidden ? 0 : 10
                        self.topBlurView.colorTint = hidden ? .clear : .black
        }, completion: nil)
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        browser?.determineAndClose()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        guard let browser = self.browser else { return }
        browser.delegate?.removePhoto?(browser, index: browser.currentPageIndex) { [weak self] in
            self?.browser?.deleteImage()
        }
    }
    
    @objc func moreButtonPressed(_ sender: UIButton) {
        browser?.moreButtonPressed(sender)
    }
}
