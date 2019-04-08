//
//  VisualEffectView.swift
//  VisualEffectView
//
//  Created by Lasha Efremidze on 5/26/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

//swiftlint:disable force_cast
//swiftlint:disable force_unwrapping

private func encodeText(_ string: String, _ key: Int) -> String {
    var result = ""
    for c in string.unicodeScalars {
        result.append(Character(UnicodeScalar(UInt32(Int(c.value) + key))!))
    }
    return result
}

open class VisualEffectView: UIVisualEffectView {
    private let blurEffect = (NSClassFromString(encodeText("`VJDvtupnCmvsFggfdu", -1)) as! UIBlurEffect.Type).init()
    
    var colorTint: UIColor? {
        get { return _value(forKey: encodeText("dpmpsUjou", -1)) as? UIColor }
        set { _setValue(newValue, forKey: encodeText("dpmpsUjou", -1)) }
    }
    
    var colorTintAlpha: CGFloat {
        get { return _value(forKey: encodeText("dpmpsUjouBmqib", -1)) as! CGFloat }
        set { _setValue(newValue, forKey: encodeText("dpmpsUjouBmqib", -1)) }
    }
    
    var blurRadius: CGFloat {
        get { return _value(forKey: encodeText("cmvsSbejvt", -1)) as! CGFloat }
        set { _setValue(newValue, forKey: encodeText("cmvsSbejvt", -1)) }
    }
    
    var scale: CGFloat {
        get { return _value(forKey: encodeText("tdbmf", -1)) as! CGFloat }
        set { _setValue(newValue, forKey: encodeText("tdbmf", -1)) }
    }
    
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        scale = 1
    }
    
    private func _value(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }
    
    private func _setValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.effect = blurEffect
    }
    
}

//swiftlint:enable force_cast
//swiftlint:enable force_unwrapping
