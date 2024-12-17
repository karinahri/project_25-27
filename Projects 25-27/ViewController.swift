//
//  ViewController.swift
//  Projects 25-27
//
//  Created by Karina Dolmatova on 15.12.2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var topText: String?
    var bottomText: String?
    var isMemeCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        // picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
        showTextAlert(title: "Top text") { text in
            self.topText = text
        }
    }
    
    @IBAction func setBottomText(_ sender: Any) {
        showTextAlert(title: "Bottom text") { text in
            self.bottomText = text
        }
    }
    
    @IBAction func createMeme(_ sender: Any) {
        guard let image = imageView.image else { return }
        if isMemeCreated {
            let alert = UIAlertController(title: "Existing Meme Detected", message: "You already created this meme. Do you want to replace it?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.applyMeme(to: image)
                self.isMemeCreated = true
            })
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            applyMeme(to: image)
            isMemeCreated = true
        }
    }
    
    
    func applyMeme(to image: UIImage) {
        let memeImage = generateMemeImage(image: image, topText: topText, bottomText: bottomText)
        imageView.image = memeImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
    
    func showTextAlert(title: String, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: "Enter the text", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion(alert.textFields?.first?.text)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func generateMemeImage(image: UIImage, topText: String?, bottomText: String?) -> UIImage {
        print("Generating meme with top text: \(topText ?? "nil") and bottom text: \(bottomText ?? "nil")")
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let memeImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: image.size.width / 10),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3,
                .paragraphStyle: paragraphStyle
            ]
            
            if let topText = topText, !topText.isEmpty {
                let topRect = CGRect(x: 0, y: image.size.height * 0.05, width: image.size.width, height: image.size.height * 0.2)
                topText.uppercased().draw(in: topRect, withAttributes: attributes)
            }
            
            if let bottomText = bottomText, !bottomText.isEmpty {
                let bottomRect = CGRect(x: 0, y: image.size.height * 0.8, width: image.size.width, height: image.size.height * 0.2)
                bottomText.uppercased().draw(in: bottomRect, withAttributes: attributes)
            }
        }
        
        return memeImage
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activity, animated: true)
    }
}

