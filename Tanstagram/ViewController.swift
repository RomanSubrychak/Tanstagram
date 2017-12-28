//
//  ViewController.swift
//  Tanstagram
//
//  Created by Roman Subrychak on 12/27/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var images: [UIImageView]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createGesture()
	}
	
	func renderImage() {
		let render = UIGraphicsImageRenderer(size: view.bounds.size)
		let image = render.image { goTo in
			view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		}
		
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(ViewController.renderComplete), nil)
	}
	
	@objc func renderComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		
		if let error = error {
			let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Photo Saved!", message: "Your image has been saved", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func saveToPhotosTapGesture(_ sender: UITapGestureRecognizer) {
		renderImage()
	}
	
	//set Gestures
	
	func pinchGesture(imageView: UIImageView) -> UIPinchGestureRecognizer {
		return UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handePinch))
	}
	
	func panGesture(imageView: UIImageView) -> UIPanGestureRecognizer {
		return UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan))
	}
	
	func rotationGesture(imageView: UIImageView) -> UIRotationGestureRecognizer {
		return UIRotationGestureRecognizer(target: self, action: #selector(ViewController.handleRotation))
	}
	
	//handle Gestures
	
	@objc func handePinch(sender: UIPinchGestureRecognizer) {
		sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
		sender.scale = 1
	}
	
	@objc func handlePan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self.view)
		if let view = sender.view {
			view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
		}
		sender.setTranslation(CGPoint.zero, in: self.view)
	}
	
	@objc func handleRotation(sender: UIRotationGestureRecognizer) {
		sender.view?.transform = (sender.view?.transform)!.rotated(by: sender.rotation)
		sender.rotation = 0
	}
	
	//Create Gestures
	
	func createGesture() {
		for shape in images {
			let pinch = pinchGesture(imageView: shape)
			shape.addGestureRecognizer(pinch)
			
			let pan = panGesture(imageView: shape)
			shape.addGestureRecognizer(pan)
			
			let rotation = rotationGesture(imageView: shape)
			shape.addGestureRecognizer(rotation)
		}
	}
}

extension ViewController: UIGestureRecognizerDelegate {
	
}
