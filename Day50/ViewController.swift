//
//  ViewController.swift
//  Day50
//
//  Created by Sultan Ali on 28/06/2020.
//  Copyright © 2020 Sultan Ali. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var pics = [Pic]()
    var textFT: String?
    static var transImage: UIImage?
    static var transText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(picker))
        navigationItem.leftBarButtonItem = leftButton
        getSaved()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let path = getDocumentsDirectory().appendingPathComponent(pics[indexPath.row].image)
        cell.cellImage.image = UIImage(contentsOfFile: path.path)
        cell.cellLabel.text = pics[indexPath.row].desc
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transImageString = getDocumentsDirectory().appendingPathComponent(pics[indexPath.row].image)
        ViewController.transImage = UIImage(contentsOfFile: transImageString.path)
        ViewController.transText = pics[indexPath.row].desc
        
        performSegue(withIdentifier: "DetailsVC", sender: nil)
    }
    
    @objc func picker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
    
        dismiss(animated: true)
        
        let dG = DispatchGroup()
        
        let ac = UIAlertController(title: "Add Description", message: "Say some words about the image", preferredStyle: .alert)
        ac.addTextField()
        let ok = UIAlertAction(title: "OK", style: .default){ [weak self , weak ac] _ in
            let text = ac?.textFields?.first?.text
            self?.textFT = text ?? ""
            dG.leave()
        }
        ac.addAction(ok)
        dG.enter()
        present(ac, animated: true)

        dG.notify(queue: .main){
            let pic = Pic(image: imageName, desc: (self.textFT)!)
            self.pics.append(pic)
            self.save()
            self.tableView.reloadData()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pics){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pics")
        }
    }
    
    func getSaved(){
        let jsonDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "pics") as? Data{
            do {
                pics = try jsonDecoder.decode([Pic].self, from: savedData)
            } catch {
                print("Cant Decode Data")
            }
        }
    }
}

