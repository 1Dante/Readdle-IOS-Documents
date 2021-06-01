//
//  ViewController.swift
//  Readdle-iOS Intern Documents
//
//  Created by MacBook on 27.05.2021.
//

import UIKit

class ViewController: UIViewController {
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createCollageButton: UIButton!
    
    
    var images: [String] = []
    var activeButton: Bool = false
    var documentsURL: URL?
    var imageCollage: UIImage?
    var imagePickedFromCollecionView: [UIImage] = []
    var activityView = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.allowsMultipleSelection = true
        createCollageButton.isEnabled = false
        createCollageButton.layer.cornerRadius = createCollageButton.frame.height / 2
        if activeButton == false {
            createCollageButton.backgroundColor = .gray
        }
        documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            // unwrap
            images = try FileManager.default.contentsOfDirectory(atPath: documentsURL!.path )
            
        } catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    @IBAction func createCollageButtonPressed(_ sender: Any) {
       
        performSegue(withIdentifier: "createCollage", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CollageViewController {
            
            vc.imagesFromCollectionView = imagePickedFromCollecionView
        }
    }
    
    @objc func load() {
        collectionView.reloadData()
        imagePickedFromCollecionView.removeAll()
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.backgroundColor = .black
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        
        cell.sendSubviewToBack(imageView)
        cell.addSubview(imageView)
        
        DispatchQueue.global(qos: .background).async {
           
            let fileURL = self.documentsURL?.appendingPathComponent(self.images[indexPath.row])
        do {
            let imageData = try Data(contentsOf: fileURL!)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: imageData)
                self.activityView.stopAnimating()
            }
        } catch {
            print(error)
        }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        cell!.bringSubviewToFront(imageView)
        cell!.addSubview(imageView)
        
        let fileURL = (documentsURL?.appendingPathComponent(images[indexPath.row]))!
            do {
               let imageData = try Data(contentsOf: fileURL)
                self.imagePickedFromCollecionView.append(UIImage(data: imageData)!)
            } catch {
                print(error)
            }
        
        
        activeButton = true
        createCollageButton.isEnabled = activeButton
        if activeButton == true {
            createCollageButton.backgroundColor = .blue
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            collectionView.reloadItems(at: [indexPath])
            self.imagePickedFromCollecionView.remove(at: indexPath.row)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsInRow))
        return CGSize(width: size, height: size)
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

