//
//  CollageViewController.swift
//  Readdle-iOS Intern Documents
//
//  Created by MacBook on 29.05.2021.
//

import UIKit

class CollageViewController: UIViewController {

    
    @IBOutlet weak var imageCollageView: UIImageView!
    var image: UIImage?
    var imagesFromCollectionView: [UIImage]?
    override func viewDidLoad() {
        super.viewDidLoad()
     draw()
     
    }
    
    
    @IBAction func selectImages(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    
    func draw() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        var images:[UIImage] = []
        guard (imagesFromCollectionView != nil) else { return }
        for image in imagesFromCollectionView! {
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderWidth = 10
            imageView.layer.borderColor = UIColor.white.cgColor
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                imageView.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            images.append(image)
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 374, height: 658), true, 1)
        
        
        
        var x = 0
        var y = 0
        let columnHeight = 150
        var columnInView = 0
        var image = 0
        var width = Int.random(in: 70...280)
        var widthForThreeimages: [Int] = [Int.random(in: 70...140), Int.random(in: 70...140), 0]
        widthForThreeimages[2] = 374 - (widthForThreeimages[0] + widthForThreeimages[1])
       
        while image < images.count  {
           
            let numberInRow = Int.random(in: 0...2)
            
            var itemInRow = 0
            var item = 0
           
            while itemInRow <= numberInRow {
           
                if image == images.count {
                    break
                }
                if numberInRow == 0 {
                images[image].draw(in: CGRect(x: x, y: y, width: 374, height: columnHeight))
                }
                if numberInRow == 1 {
                images[image].draw(in: CGRect(x: x, y: y, width: width, height: columnHeight))
        
                x = width
                width = 374 - width
                    
                }
                
                if numberInRow == 2 {
                    images[image].draw(in: CGRect(x: x, y: y, width: widthForThreeimages[item], height: columnHeight))
                    print(x)
                    print(widthForThreeimages[item])
                    x += widthForThreeimages[item]
                    
                    item += 1
                }
                image += 1
                itemInRow += 1
               // width = Int.random(in: 70...140)
                
//                switch numberInRow {
//
//                case 0:
//                    images[image].draw(in: CGRect(x: x, y: y, width: 374, height: columnHeight))
//                    image += 1
//
//                case 1:
//                    images[image].draw(in: CGRect(x: x, y: y, width: width, height: columnHeight))
//                    x += width
//                    width = 374 - width
//                    image += 1
//                case 2:
//                  //  var item = 0
//                    width = Int.random(in: 70...140)
//                    images[image].draw(in: CGRect(x: x, y: y, width: width, height: columnHeight))
//                    x = width
//
//                    tempWidth += width
//
////                        if item == 2 {
////                            width = 374 - tempWidth
////                            x = tempWidth
////                            break
////                        }
//  //                  image += 1
//
////                    var thirdWidth = width
////                    if width > 140 {
////                    width = Int.random(in: 70...140)
////                    thirdWidth += width
////                    }
////                    images[image].draw(in: CGRect(x: x, y: y, width: width, height: columnHeight))
////                    x += width
////                    print(width)
////                    if x >= 140 {
////                        width = 374 - thirdWidth
////                    } else {
////                    width = Int.random(in: 70...140)
////                    thirdWidth += width
////                    }
//                    image += 1
//                default:
//                    break
//                }
                
            }
            if image < images.count {
             columnInView += 1
             y = columnHeight + y
    
             x = 0
                
            }
        }
        
        imageCollageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
