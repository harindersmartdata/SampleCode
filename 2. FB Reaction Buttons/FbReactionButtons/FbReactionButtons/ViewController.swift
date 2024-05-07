//
//  ViewController.swift
//  FbReactionButtons
//
//  Created by Harinder Rana on 07/01/24.
//


import UIKit
import Lottie

class ViewController: UIViewController {

    let defaultLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Long press anywhere on screen..."
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    
    let loveView = LottieAnimationView()
    let sadView = LottieAnimationView()
    let angryView = LottieAnimationView()
    let laughView = LottieAnimationView()
    
    lazy var reactionsContainterView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        
        loveView.backgroundColor = .clear
        loveView.addSubview(LottieAnimationView(name: "love"))
        loveView.loopMode = LottieLoopMode.loop
        loveView.play()
        
        sadView.backgroundColor = .clear
        sadView.addSubview(LottieAnimationView(name: "sad"))
        sadView.loopMode = LottieLoopMode.loop
        sadView.play()
        
        angryView.backgroundColor = .clear
        angryView.addSubview(LottieAnimationView(name: "angry"))
        angryView.loopMode = LottieLoopMode.loop
        angryView.play()
        
        laughView.backgroundColor = .clear
        laughView.addSubview(LottieAnimationView(name: "laugh"))
        laughView.loopMode = LottieLoopMode.loop
        laughView.play()

        let arrangedSubViews = [loveView , laughView , sadView , angryView ]
        
    
        let padding:CGFloat = 8
        let iconHeight:CGFloat = 65
        
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        v.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubViews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        let height = iconHeight + 2 * padding
        
        v.frame = CGRect(x: 0, y: 0, width: width, height: height)
        stackView.frame = v.frame
        v.layer.cornerRadius = height / 2
        
        v.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowRadius = 10
        v.layer.shadowOpacity = 1
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(defaultLabel)
        setUpConstraints()
        setUpLongPressGesture()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            defaultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            defaultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setUpLongPressGesture(){
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(hangeLongPress)))
    }
    
    @objc func hangeLongPress(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            handleGestureEnded(gesture: gesture)
        } else if gesture.state == .changed {
            handleGestureChanges(gesture:gesture)
        }
        
    }
    
    func handleGestureBegan(gesture: UILongPressGestureRecognizer){
        view.addSubview(reactionsContainterView)
        
        loveView.play()
        laughView.play()
        angryView.play()
        sadView.play()
        
        let centerX = (view.frame.width - reactionsContainterView.frame.width) / 2
        let location = gesture.location(in: self.view)
        
        reactionsContainterView.transform = CGAffineTransform(translationX: centerX, y: location.y)
        
        reactionsContainterView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.reactionsContainterView.alpha = 1
            self.reactionsContainterView.transform = CGAffineTransform(translationX: centerX, y: location.y - self.reactionsContainterView.frame.height)
        }, completion: nil)
    }
    
    func handleGestureEnded(gesture: UILongPressGestureRecognizer){
        let centerX = (view.frame.width - reactionsContainterView.frame.width) / 2
        let location = gesture.location(in: self.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.reactionsContainterView.alpha = 0
            self.reactionsContainterView.transform = CGAffineTransform(translationX: centerX, y: location.y)
            let stackView = self.reactionsContainterView.subviews.first
            stackView?.subviews.forEach({ (AnimationView) in
                AnimationView.transform = .identity
            })
        }, completion: { finished in
            self.reactionsContainterView.removeFromSuperview()
        })
        
    }
    
    func handleGestureChanges(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self.reactionsContainterView)
        let hitTestView = reactionsContainterView.hitTest(pressedLocation, with: nil)
        if hitTestView is LottieAnimationView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                
                let stackView = self.reactionsContainterView.subviews.first
                stackView?.subviews.forEach({ (AnimationView) in
                    AnimationView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -60)
            }, completion: nil)
        }
    }

}

