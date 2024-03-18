//
//  File.swift
//  
//
//  Created by Edhem Silajdzic on 18. 3. 2024..
//

import Foundation
import UIKit

extension UIView {
    func addShadow(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 14
    }
    
    func fadeOut(duration: Double = 0.3, _ finished: @escaping () -> Void = {}) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            finished()
        }
    }
    
    func fadeOut(alpha: CGFloat, duration: Double = 0.3, _ finished: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }) { _ in
            finished()
        }
    }
    
    func fadeIn(duration: Double = 0.3, _ finished: @escaping () -> Void = {}) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }) { _ in
            finished()
        }
    }
}
