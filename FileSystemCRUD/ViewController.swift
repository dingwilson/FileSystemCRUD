//
//  ViewController.swift
//  FileSystemCRUD
//
//  Created by Wilson on 5/31/18.
//  Copyright © 2018 Wilson Ding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let applicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    
    let fileName = "sampleImageData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImageFrom(URL(string: "https://iphonewalls.net/wp-content/uploads/2016/08/Dreamy%20Underwater%20Bubbles%20Sun%20Light%20iPhone%206+%20HD%20Wallpaper.jpg"))
    }
    
    func getImageFrom(_ url: URL?) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.saveFile(data, to: self.applicationSupportDirectory, named: self.fileName)
        }.resume()
    }
    
    func saveFile(_ data: Data, to path: URL?, named name: String) {
        guard let url = path?.appendingPathComponent(name) else { return }
        
        do {
            try data.write(to: url)
            
            fetchFile(from: path, named: fileName)
        } catch {
            print("Save Error: \(error)")
        }
    }
    
    func fetchFile(from path: URL?, named name: String) {
        guard let url = path?.appendingPathComponent(name) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        } catch {
            print("Fetch Error: \(error)")
        }
    }
}
