//
//  ViewController.swift
//  CircleActivityIndicator
//
//  Created by James Rochabrun on 12/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var circleLayer: CAShapeLayer?
    let urlString  = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    let percentageLabel : UILabel = {
        let l = UILabel()
        l.text = "Start"
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 32)
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        
        /// 1 define a circlePath
        let circlePath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        /// 2 create track layer the one that shows the path
        let tracklayer = configureShape(with: circlePath, strokeColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), in: self.view)
        view.layer.addSublayer(tracklayer)
        
        /// 3 drawing a circle uploader
        circleLayer = self.configureShape(with: circlePath, strokeColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), in: self.view)
        guard let circleLayer = circleLayer  else { return }
        
        /// 4 this is just to rotate the circle layer
        circleLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        /// strokeEnd is what will create the upload effect starting from 0
        circleLayer.strokeEnd = 0
        view.layer.addSublayer(circleLayer)
        
        configureTap()
    }
    
    private func configureTap() {
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func configureShape(with circlePath: UIBezierPath, strokeColor: UIColor, in view: UIView)  -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.position = view.center
        return shapeLayer
    }
    
    private func beginDownloadingFile() {
        
        circleLayer?.strokeEnd = 0
        
        let config = URLSessionConfiguration.default
        let queue = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    //    fileprivate func animateCircle() {
    //
    //        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    //        basicAnimation.toValue = 1
    //        basicAnimation.duration = 2
    //        basicAnimation.fillMode = kCAFillModeForwards
    //        basicAnimation.isRemovedOnCompletion = false
    //        circleLayer.add(basicAnimation, forKey: "strokeEnd")
    //    }
    
    @objc private func handleTap() {
        beginDownloadingFile()
        //  animateCircle()
    }
}

extension ViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish downloading file")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.circleLayer?.strokeEnd = CGFloat(percentage)
            self.percentageLabel.text = "\(Int(CGFloat(percentage) * 100)) %"
        }
        print(percentage)
    }
    
}
