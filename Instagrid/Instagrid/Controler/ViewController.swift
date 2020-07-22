//
//  ViewController.swift
//  Instagrid
//
//  Created by antoineantoniol on 23/01/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var importButton: [UIButton]!
    @IBOutlet var gridButton: [UIButton]!
    @IBOutlet var pictureView: [UIImageView]!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var viewFrame: [UIView]!
    
  
    //MARK: - var
    var grid: Grid = .pattern2 {
        didSet {
            displayDidChanged()
        }
    }
    let imagePickerController = UIImagePickerController()//pickerController
    var tag = 0//buttons tag
    var swipeGesture: UISwipeGestureRecognizer?//gesture
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(handleShareAction))
        gridView.isUserInteractionEnabled = true
        guard let swipeGesture =  swipeGesture else {return}
        setUpSwipeDirection()
        gridView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: - Actions
    @IBAction func selectGrid(_ sender: UIButton) {
        gridButton.forEach({$0.isSelected = false})
        sender.isSelected = true
        switch sender.tag {
        case 0:
            grid = .pattern1
        case 1:
            grid = .pattern2
        case 2:
            grid = .pattern3
        default:
            break
        }
    }
    
    @IBAction func importPicture(_ sender: UIButton) {
        tag = sender.tag
        showAlert()
    }
    
    @objc func swipeToShare() {
        if UIDevice.current.orientation.isPortrait {
            sharePortraitOrientation()
        } else {
           shareLandscapeOrientation()
        }
        resetAnimate()
    }
    
    @objc func setUpSwipeDirection() {
        if UIDevice.current.orientation.isPortrait {
          swipeGesture?.direction = .up
        } else {
          swipeGesture?.direction = .left
        }
    }
    
    @objc func handleShareAction() {
        if swipeGesture?.direction == .up {
           sharePortraitOrientation()
        } else {
           shareLandscapeOrientation()
        }
    }
            
    @objc func tapGesture(gesture:UITapGestureRecognizer) {
        guard let gestureTag = gesture.view?.tag else {return}
        tag = gestureTag
        showAlert()
    }
    
    //MARK: - Class Methods
    private func displayDidChanged() {
        for i in 0..<viewFrame.count {
            let value = grid.display[i]
            viewFrame[i].isHidden = value
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func convertUIviewToImage(view:UIView) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    private func sharingMenu() {
        guard let image = convertUIviewToImage(view: gridView) else {return}
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        vc.popoverPresentationController?.sourceView = self.view
        present(vc,animated:true,completion:nil)
        vc.completionWithItemsHandler = {_,_,_,_ in
            self.resetAnimate()
        }
    }
    
    private func resetAnimate() {
        UIView.animate(withDuration: 0.5) {
            self.gridView.transform = CGAffineTransform.identity
        }
    }
    
    private func sharePortraitOrientation() {
        UIView.animate(withDuration: 0.8) {
            let translation = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            self.gridView.transform = translation
            self.sharingMenu()
        }
    }
    
    private func shareLandscapeOrientation() {
        UIView.animate(withDuration: 0.8) {
            let translation = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.gridView.transform = translation
            self.sharingMenu()
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picture = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pictureView[tag].image = picture
            importButton[tag].isHidden = true
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.tapGesture(gesture: )))
            pictureView[tag].addGestureRecognizer(tapGesture)
        }
        dismiss(animated: true, completion: nil)
    }
}
    
    
        

    

    
    
    


