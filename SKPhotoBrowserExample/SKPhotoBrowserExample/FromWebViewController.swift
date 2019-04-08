//
//  FromWebViewController.swift
//  SKPhotoBrowserExample
//
//  Created by suzuki_keishi on 2015/10/06.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

import SDWebImage

class FromWebViewController: UIViewController, SKPhotoBrowserDelegate {
    var images = [SKPhotoProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKCache.sharedCache.imageCache = CustomImageCache()
        let url = URL(string: "https://placehold.jp/150x150.png")
        let complated: SDWebImageCompletionBlock = { (image, error, cacheType, imageURL) -> Void in
            guard let url = imageURL?.absoluteString else { return }
            SKCache.sharedCache.setImage(image!, forKey: url)
        }
    }
    
    @IBAction func pushButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
}

// MARK: - SKPhotoBrowserDelegate

extension FromWebViewController {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

// MARK: - private

private extension FromWebViewController {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<10).map { (i: Int) -> SKPhotoProtocol in
            var url = "https://s-ec.bstatic.com/images/hotel/max1024x768/812/81255410.jpg"
            switch i {
            case 1:
                url = "https://upload.wikimedia.org/wikipedia/commons/e/e0/Great_view.jpg"
            case 2:
                url = "https://pictures.luxuryretreats.com/106964/jamaica_greatview_03.jpg"
            case 3:
                url = "https://www.publichotels.com/content/slides/013018-early-check-in1.jpg"
            case 4:
                url = "https://wallimpex.com/data/out/803/snowy-winter-scenes-wallpaper-11487975.jpg"
            case 5:
                url = "https://previews.123rf.com/images/leonidtit/leonidtit1410/leonidtit141000027/32175148-great-view-on-the-pizes-de-cir-ridge-valley-gardena-national-park-dolomites-south-tyrol-location-ort.jpg"
            case 6:
                url = "https://pictures.luxuryretreats.com/106964/jamaica_greatview_04.jpg"
            case 7:
                url = "https://pix10.agoda.net/hotelImages/237/237518/237518_16091517420046511770.jpg"
            case 8:
                url = "https://s-ec.bstatic.com/images/hotel/max1024x768/466/46697971.jpg"
            case 9:
                url = "http://railaygreatview.com/images/617x800x600.jpg"
            default: break
            }
            let photo = SKPhoto.photoWithImageURL(url)
            photo.caption = caption[i%10]
//            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }
}

class CustomImageCache: SKImageCacheable {
    var cache: SDImageCache
    
    init() {
        let cache = SDImageCache(namespace: "com.suzuki.custom.cache")
        self.cache = cache!
    }

    func imageForKey(_ key: String) -> UIImage? {
        guard let image = cache.imageFromDiskCache(forKey: key) else { return nil }
        
        return image
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.store(image, forKey: key)
    }

    func removeImageForKey(_ key: String) {}
    
    func removeAllImages() {}
    
}
