//
//  ViewController.swift
//  PromieKitStockCode
//
//  Created by James Rochabrun on 7/24/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController {

    @IBOutlet weak var giphyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeGiphy(self)
    }
    
    @IBAction func changeGiphy(_ sender: Any) {
        GiphyManager.sharedInstance.fetchRandomGifUrl(forSearchQuery: "SNES").then { imageUrlString in
            GiphyManager.sharedInstance.fetchImage(forImageUrl: imageUrlString)
            }.then { imageData in
                self.attachImage(withImageData: imageData)
            }.catch { error in
                print(error)
        }
    }

    //MARK: Helper method
    func attachImage(withImageData imageData: Data) -> Void {
        let image = UIImage(gifData: imageData)
        self.giphyImageView.setGifImage(image)
    }

}
