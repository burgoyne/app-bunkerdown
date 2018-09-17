//
//  BunkerPickerVC.swift
//  BunkerDown
//
//  Created by Andre Burgoyne on 2018-09-17.
//  Copyright © 2018 Andre Burgoyne. All rights reserved.
//

import UIKit
import SceneKit

class BunkerPickerVC: UIViewController {
    
    var sceneView: SCNView!
    var size: CGSize!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        let scene = SCNScene(named: "art.scnassets/bunkers.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let obj = SCNScene(named: "art.scnassets/PSP.dae")
        let node = obj?.rootNode.childNode(withName: "race", recursively: true)!
        node?.scale = SCNVector3Make(0.10, 0.10, 0.10)
        node?.position = SCNVector3Make(-1.7, 0.6, -1)
        scene.rootNode.addChildNode(node!)
        preferredContentSize = size
    }
}
