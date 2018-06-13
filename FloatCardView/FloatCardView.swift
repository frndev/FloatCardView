//
//  FloatCardView.swift
//  FloatCardView
//
//  Created by frndev on 11/06/2018.
//  Copyright © 2018 frndev All rights reserved.
//

import UIKit

public class FloatCardView: UIView {
    
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var frontView: UIView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private var view: UIView!
    private var frontImage: UIImage!
    
    private var defaultFooterHeight: CGFloat = 100
    private var topCornerRadius : CGFloat = 10
    private var bottomCornerRadius : CGFloat = 10
    private var maskLayer: CAShapeLayer!
    private var isFlipped: Bool = false
    private var gradient: CAGradientLayer!
    public var bottomRadius: CGFloat  {
        set(radius) {
            bottomCornerRadius = radius
            roundCorners(topRadius: topRadius, bottomRadius: bottomCornerRadius)
            createShadows()
            
        }
        get {
            return self.bottomCornerRadius
        }
    }
    
    public var topRadius: CGFloat {
        set(radius) {
            topCornerRadius = radius
            roundCorners(topRadius: topCornerRadius, bottomRadius: bottomRadius)
            createShadows()
            
        }
        get {
            return self.topCornerRadius
        }
    }
    
    public var footerViewHeight: CGFloat {
        
        set {
            
            let x     = footerView.frame.origin.x
            let y     = footerView.frame.origin.y
            let width = footerView.frame.size.width
            
            footerView.frame = CGRect(x:  x, y: y, width: width, height: newValue)
            
            footerView.addConstraint(NSLayoutConstraint(item: footerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: newValue))
        }
        
        get {
            return footerView.frame.size.height
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        roundCorners(topRadius: topCornerRadius, bottomRadius: bottomCornerRadius)
        self.footerViewHeight = defaultFooterHeight
        createShadows()
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        roundCorners(topRadius: topCornerRadius, bottomRadius: bottomCornerRadius)
        self.footerViewHeight = defaultFooterHeight
        createShadows()
        setup()
        
    }
    
    private func setup() {
        
        self.autoresizesSubviews = false
        
    }
    
    private func xibSetup() {
        view = loadViewFromNib()

        view.frame = bounds
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "FloatCardView", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func roundCorners(topRadius: CGFloat, bottomRadius: CGFloat) {
        
        let minx = self.bounds.minX
        let miny = self.bounds.minY
        let maxx = self.bounds.maxX
        let maxy = self.bounds.maxY
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:minx + topRadius,y:miny))
        path.addLine(to: CGPoint(x:maxx - topRadius,y: miny))
        path.addArc(withCenter: CGPoint(x:maxx - topRadius,y: miny + topRadius), radius: topRadius, startAngle:CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
    
        path.addLine(to: CGPoint(x:maxx, y:maxy - bottomRadius))
        path.addArc(withCenter: CGPoint(x:maxx - bottomRadius,y: maxy - bottomRadius), radius: bottomRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        
        path.addLine(to: CGPoint(x:minx + bottomRadius, y:maxy))
        path.addArc(withCenter: CGPoint(x:minx + bottomRadius,y: maxy - bottomRadius), radius: bottomRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        
        path.addLine(to: CGPoint(x:minx,y: miny + topRadius))
        path.addArc(withCenter: CGPoint(x:minx + topRadius,y: miny + topRadius), radius: topRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        path.close()
        
        
        maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
        

        
        
    }
    
    private func setProfileImageView() {
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        
    }
    
    private func createShadows() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        self.layer.shadowPath = maskLayer.path!
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        
    }
    
    private func doFlip() {
        
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft,.showHideTransitionViews]
        self.layer.shadowPath = nil
        if isFlipped {
            
            UIView.transition(from: self.backView, to: self.frontView, duration: 0.3, options: transitionOptions) { (finished) in
                self.isFlipped = false
                
                self.createShadows()
            }
        }else {
           self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
            UIView.transition(from: self.frontView, to: self.backView, duration: 0.3, options: transitionOptions) { (finished) in
                self.isFlipped = true
                
                self.createShadows()
            }
        }
        
        
    }
    
    
    @objc private func didTap(sender: UITapGestureRecognizer) {
        
        self.doFlip()
        
    }
    
    public func  setCardGestureRecognizers() {
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        self.addGestureRecognizer(tap)
        
    }
    
    public func set(image img:UIImage) {
        self.thumbImageView.image = img
    }
    
    public func set(title tlt: String) {
        self.titleLabel.text = tlt
    }
    public func set(location loc: String) {
        self.locationLabel.text = loc
    }
    public func set(profileImage img: UIImage) {
        
        self.profileImageView.image = img
        
    }
    
    public func setGradientForFooterView(leftColor: UIColor, rightColor: UIColor) {
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x:1, y: 0)
        self.setGradientForFooterView(leftColor: leftColor, rightColor: rightColor, startPoint: startPoint, endPoint: endPoint)
        
    }
    
    public func setGradientForFooterView(leftColor: UIColor, rightColor: UIColor,startPoint:CGPoint,endPoint:CGPoint) {
        
        gradient = CAGradientLayer()
        gradient.frame = self.footerView.bounds
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.footerView.layer.insertSublayer(gradient, at: 0)
        
    }
    
    public func setSimpleBackgroundColorForFooterView(color: UIColor) {
        
        
        for layer in self.footerView.layer.sublayers! {
            if layer == gradient {
                layer.removeFromSuperlayer()
            }
        }
        
        self.footerView.backgroundColor = color
        
    }
}
