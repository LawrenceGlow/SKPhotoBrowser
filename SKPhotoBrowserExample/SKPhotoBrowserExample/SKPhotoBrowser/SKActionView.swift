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
    var imageView: UIImageView!
    var captionLabel: LTMorphingLabel!
    var shareButton: UIButton!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
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
        countLabel.numberOfLines = 0
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        topBlurView.contentView.addSubview(countLabel)
        
        moreButton = UIButton(type: .custom)
        if style == .default {
            moreButton.setImage(UIImage(named: "browser_more_icon"), for: .normal)
            moreButton.addTarget(browser, action: #selector(SKPhotoBrowser.moreButtonPressed), for: .touchUpInside)
        } else {
            moreButton.setImage(UIImage(named: "browser_delete_icon"), for: .normal)
            moreButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        }
        
        topBlurView.contentView.addSubview(moreButton)
        
        imageView = UIImageView()
        imageView.backgroundColor = .orange
        bottomBlurView.contentView.addSubview(imageView)
        
        captionLabel = LTMorphingLabel()
//        captionLabel.clipsToBounds = true
//        captionLabel.layerBased = true
//        captionLabel.layoutTool.groupType = .char
//        captionLabel.animationDuration = 0.25
//        captionLabel.animationDelay = 0.02
        captionLabel.font = UIFont.systemFont(ofSize: 14)
        captionLabel.textColor = .white
//        captionLabel.numberOfLines = 2
        captionLabel.lineBreakMode = .byTruncatingTail
        captionLabel.textAlignment = .left
        bottomBlurView.contentView.addSubview(captionLabel)
        
        shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "browser_delete_icon"), for: .normal)
        shareButton.addTarget(browser, action: #selector(SKPhotoBrowser.shareButtonPressed), for: .touchUpInside)
        bottomBlurView.contentView.addSubview(shareButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.33) {
            self.update(browser.currentPageIndex)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if closeButton.frame.contains(point) || moreButton.frame.contains(point) {
                return view
            }
            let bottomPoint = convert(point, to: bottomBlurView)
            if shareButton.frame.contains(bottomPoint) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
        topBlurView.frame = CGRect(x: 0, y: 0, width: frame.width, height: UIApplication.safeInsets.top+44)
        closeButton.frame = CGRect(
            x: UIApplication.safeInsets.left+16.0,
            y: UIApplication.safeInsets.top,
            width: 44.0, height: 44.0)
        countLabel.frame = CGRect(x: (topBlurView.contentView.frame.width-200)/2, y: UIApplication.safeInsets.top, width: 200, height: 44)
        moreButton.frame = CGRect(
            x: topBlurView.contentView.frame.width-44-UIApplication.safeInsets.right-6,
            y: UIApplication.safeInsets.top,
            width: 44, height: 44)
        
        var bottomHeight: CGFloat = 88
        if UIApplication.isLandscape {
            bottomHeight = 64
        }
        bottomBlurView.frame = CGRect(
            x: 0,
            y: frame.height-UIApplication.safeInsets.bottom-bottomHeight,
            width: frame.width,
            height: UIApplication.safeInsets.bottom+bottomHeight)
        shareButton.frame = CGRect(
            x: (bottomBlurView.contentView.frame.width-100)/2,
            y: bottomBlurView.contentView.frame.height-UIApplication.safeInsets.bottom-44,
            width: 100,
            height: 44
        )
        imageView.frame = CGRect(
            x: UIApplication.safeInsets.left+16,
            y: 8,
            width: 30,
            height: 30
        )
        captionLabel.frame = CGRect(
            x: UIApplication.safeInsets.left+16+imageView.frame.width+8,
            y: 8,
            width: bottomBlurView.contentView.frame.width-imageView.frame.width-32-8,
            height: bottomBlurView.contentView.frame.height-UIApplication.safeInsets.bottom-shareButton.frame.height-8
        )
//        setNeedsDisplay()
    }
    
    func update(_ currentPageIndex: Int, date: Date? = Date()) {
        guard let browser = browser else { return }
        
        var count: String = ""
        if browser.photos.count > 1 {
            count = "\(currentPageIndex + 1)/\(browser.photos.count)"
        }
        
        if style == .default {
            if let date = date {
                let dateString = formatter.string(from: date) + "\n"
                let attr = NSMutableAttributedString(string: dateString, attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 17),
                    .foregroundColor: UIColor.white
                    ])
                let counter = NSAttributedString(string: count, attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 14),
                    .foregroundColor: UIColor.white
                    ])
                attr.append(counter)
                countLabel.attributedText = attr
            } else {
                countLabel.text = count
            }
        } else {
            countLabel.text = count
        }
        
        let caption = createCaption(currentPageIndex)
        captionLabel.text = caption
//        captionLabel.attributedString = formatted(caption)
//        captionLabel.startAppearAnimation()
    }
    
    func animate(hidden: Bool) {
//        let closeFrame: CGRect = hidden ? closeButton.hideFrame : closeButton.showFrame
//        let deleteFrame: CGRect = hidden ? deleteButton.hideFrame : deleteButton.showFrame
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.closeButton.alpha = alpha
            self.moreButton.alpha = alpha
            self.countLabel.alpha = alpha
            self.topBlurView.blurRadius = hidden ? 0 : 10
            self.topBlurView.colorTint = hidden ? .clear : .black
            
            self.shareButton.alpha = alpha
            self.imageView.alpha = alpha
            self.captionLabel.alpha = alpha
            self.bottomBlurView.blurRadius = hidden ? 0 : 10
            self.bottomBlurView.colorTint = hidden ? .clear : .black
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
}

extension SKActionView {
    func createCaption(_ index: Int) -> String {
        if let delegate = self.browser?.delegate,
            let caption = delegate.captionForPhoto?(at: index) {
            return caption
        }
        guard let photo = browser?.photoAtIndex(index),
            let caption = photo.caption else {
            return ""
        }
        return caption
    }
    
    func formatted(_ text: String) -> NSAttributedString {
        let style = NSParagraphStyle.style(lineHeight: 15, .left)
//        let image = NSTextAttachment()
//        image.image = UIImage(named: "browser_close_button")
////        image.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
//        let attachment = NSAttributedString(attachment: image)
//        let attr = NSMutableAttributedString(attributedString: attachment)
        
        let text = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .paragraphStyle: style,
            .foregroundColor: UIColor.white
            ]
        )
        
//        attr.append(text)
        return text
    }
}
