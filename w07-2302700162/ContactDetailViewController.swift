//
//  ContactDetailViewController.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit
import Photos
import SVProgressHUD

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    var selectedPhoto: Photo?
    var isFullScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        if let photo = selectedPhoto {
            SVProgressHUD.show(withStatus: "Loading image...")
            wallpaperImageView.loadImage(from: photo.largeImageURL, placeholder: UIImage(systemName: "photo")) {
                SVProgressHUD.dismiss()
            }
            title = photo.user
        }
        wallpaperImageView.contentMode = .scaleAspectFit
        wallpaperImageView.clipsToBounds = true
    }
    
    // MARK: - Button 1: Back (handled by Navigation Controller automatically)
    
    // MARK: - Button 2: Save Image to Camera Roll
    @IBAction func saveImageTapped(_ sender: UIButton) {
        guard let image = wallpaperImageView.image else {
            showAlert(title: "Error", message: "No image to save")
            return
        }
        
        // Request permission
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    self?.showAlert(title: "Permission Denied", message: "Please allow photo access in Settings.")
                }
            }
        }
    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        } else {
            SVProgressHUD.showSuccess(withStatus: "Saved!")
        }
    }
    
    // MARK: - Button 3: Share Image
    @IBAction func shareImageTapped(_ sender: UIButton) {
        guard let image = wallpaperImageView.image else { return }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
        present(activityVC, animated: true)
    }
    
    // MARK: - Button 4: Toggle Full Screen
    @IBAction func fullScreenTapped(_ sender: UIButton) {
        isFullScreen.toggle()
        
        navigationController?.setNavigationBarHidden(isFullScreen, animated: true)
        
        if isFullScreen {
            wallpaperImageView.contentMode = .scaleAspectFill
            wallpaperImageView.frame = view.bounds
        } else {
            wallpaperImageView.contentMode = .scaleAspectFit
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Helper
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
