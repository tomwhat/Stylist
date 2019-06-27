//
//  UIViewSwizzle.swift
//  Stylist
//
//  Created by Yonas Kolb on 22/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    class func setupSwizzling() {
        struct Static {
            static var swizzled = false
        }

        if Static.swizzled {
            return
        } else {
            Static.swizzled = true
        }

        if self !== UIView.self { return }

        let originalSelector = #selector(didMoveToSuperview)
        let swizzledSelector = #selector(stylist_didMoveToSuperview)

        let originalMethod = class_getInstanceMethod(UIView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    @objc func stylist_didMoveToSuperview() {
        stylist_didMoveToSuperview()
        if self.superview != nil {
            Stylist.shared.style(self)
        }
    }
}

extension UIViewController {

    class func setupSwizzling() {
        struct Static {
            static var swizzled = false
        }

        if Static.swizzled {
            return
        } else {
            Static.swizzled = true
        }

        if self !== UIViewController.self { return }

        let originalSelector = #selector(viewDidLoad)
        let swizzledSelector = #selector(stylist_viewDidLoad)

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    @objc func stylist_viewDidLoad() {
        stylist_viewDidLoad()
        Stylist.shared.style(self)
    }
}
