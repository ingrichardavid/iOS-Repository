//
//  VCMixDetail.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import UIKit
import AlamofireImage

class VCMixDetail: UIViewController {
    
    //MARK: - Variables and Constants.

    private var bounceCycle: Bool = true
    var entitiesMixMovieSerie: EntityMixMovieSerie = EntityMixMovieSerie()
    
    //MARK: - @IBOutlet.
    
    @IBOutlet weak var imgPoster: UIImageView!
    
    //MARK: - UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgPoster.af_setImage(withURL: URL(string: self.entitiesMixMovieSerie.poster!)!,
                                   placeholderImage: UIImage(named: String().placeholderImageName))
        
        self.animation()
    }
    
    private func animation() {
        let expandTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.8, y: 0.8);
 
        self.imgPoster.transform = expandTransform
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.40,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations:
        {
            self.imgPoster.transform = expandTransform.inverted()
        }, completion: { finish in
            if self.bounceCycle {
                self.animation()
                self.bounceCycle = false
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
