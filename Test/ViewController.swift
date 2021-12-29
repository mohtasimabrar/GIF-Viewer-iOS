//
//  ViewController.swift
//  Test
//
//  Created by BS236 on 27/12/21.
//

import UIKit
import JellyGif

class ViewController: UIViewController {
    //creating gif model object
    var gifData = GIF()
    //creating new path for storing
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("gifData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking if data exists
        if let storedData = FileManager.default.contents(atPath: self.path.path){
            //if the data exists, we load the gif and show toast
            self.gifData.data = storedData
            loadGif(self.gifData)
            showToast(message: "Data from local storage")
            
        } else {
            //checking network connection
            if NetworkMonitor.shared.isConnected {
                
                //fetching gif data
                let url = URL(string: "https://media1.giphy.com/media/zdt4666BOT6ktcfGvM/giphy.gif?cid=5222c33b4keq3hc4aygbhkaovbdcvvo5tax7ewvb7jqieptr&rid=giphy.gif&ct=g")
                let Data = try? Data(contentsOf: url!)
                
                
                //updating object with fetched data
                self.gifData.data = Data
                
                //storing data in path
                try? Data!.write(to: self.path)
                
                //loading gif and showing toast
                loadGif(self.gifData)
                showToast(message: "Data from internet")
                
            } else {
            
                //showing failed network toast
                showToast(message: "Network Error")
                
            }
            
        }
        
    }
    
    func loadGif(_ Data: GIF) {
        //creating imageView and adding toast to it
        let imageView = JellyGifImageView(frame: CGRect(x: 20.0, y: 300.0, width: self.view.frame.size.width - 40, height: 200.0))
        imageView.startGif(with: .data(Data.data))
        view.addSubview(imageView)
    }
    
}


extension UIViewController {
    func showToast(message: String) {
        
        //Creating Toast
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 18)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        toastLbl.numberOfLines = 0
        
        //Resizing Toast
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / self.view.frame.size.width ) * 30
        let labelWidth = min(textSize.width, self.view.frame.size.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        //Placing Toast
        toastLbl.frame = CGRect(x: 20, y: (self.view.frame.size.height - 90 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLbl.center.x = self.view.center.x
        toastLbl.layer.cornerRadius = 15
        toastLbl.layer.masksToBounds = true
        
        view.addSubview(toastLbl)
        
        
        //Animating Toast
        UIView.animate(withDuration: 5.0, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
}
