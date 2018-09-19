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
    weak var bunkerPlacerVC: BunkerPlacerVC!
    
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
        
        preferredContentSize = size
        
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 3.0
        
        let scene = SCNScene(named: "art.scnassets/bunkers.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let race = Bunker.getRace()
        Bunker.startRotation(node: race)
        scene.rootNode.addChildNode(race)
        
        let miniRace = Bunker.getMiniRace()
        Bunker.startRotation(node: miniRace)
        scene.rootNode.addChildNode(miniRace)
        
        let cakeTall = Bunker.getCakeTall()
        Bunker.startRotation(node: cakeTall)
        scene.rootNode.addChildNode(cakeTall)
        
        let cakeSmall = Bunker.getCakeSmall()
        Bunker.startRotation(node: cakeSmall)
        scene.rootNode.addChildNode(cakeSmall)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            bunkerPlacerVC.onBunkerSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
    }
}
