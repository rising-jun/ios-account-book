//
//  BaseClasses.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/04.
//

import Foundation
import UIKit
import RxSwift

class BaseView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .white
    }
}

class BaseViewController: UIViewController{
    
    
    
    override func loadView() {
        super.loadView()
        setup()
        bindViewModel()
    }
    
    public func setup() {
        
    }
    
    public func bindViewModel(){
        
    }
    
}

extension UILabel{
    func introLabel(text: String, lineHeightMultiply: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = lineHeightMultiply
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attributedText = attrString
        lineBreakMode = NSLineBreakMode.byTruncatingTail
        numberOfLines = 4
        textAlignment = .left
    }
}


//protocol ViewModelType: class {
//    associatedtype Input
//    associatedtype Output
//
//    func transform(input: Input) -> Output
//}

extension UIView {
    func addSubViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    final func animate(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.default)
        animation.subtype = CATransitionSubtype.fromBottom
        animation.type = CATransitionType.moveIn
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.reveal.rawValue)
    }
    
    final func setShadow(){
        layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.cornerRadius = 15
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
}

extension UINavigationBar{
    final func setColorWithView(){
        barTintColor = .systemGray6
        isTranslucent = false
        shadowImage = UIImage()
    }
}

extension UIScrollView{
    final func setDefalutView(){
        contentSize.width = frame.width
        contentSize.height = frame.height * 2
        isScrollEnabled = true
        alwaysBounceVertical = true
        
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 47, width: frame.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)
            
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            
        default: do {}
        }
        
        border.backgroundColor = color.cgColor
        
        addSublayer(border)
    }
}

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(self.name).map { $0.object }
    }
    
    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        guard hex.hasPrefix("#") && hex.count == 9 else { return nil }

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) == true else { return nil }

        let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hexNumber & 0x000000ff) / 255

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImage{
    
    func crop(to: CGSize) -> UIImage {
        
        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)

        guard let newCgImage = contextImage.cgImage else { return self }

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height

        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height

        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? self
      }
    
}



extension UITextField{
    func setError(){
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let errorImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        errorImg.image = UIImage(named: "error")
        errorImg.contentMode = .scaleAspectFit
        rightView.addSubview(errorImg)
        let rightPadding: CGFloat = 20 //--- change right padding
        rightView.frame = CGRect(x: 0, y: 0, width: errorImg.frame.size.width + rightPadding , height: errorImg.frame.size.height)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    func reomoveErrorImg(){
        rightView = nil
    }
    
}
