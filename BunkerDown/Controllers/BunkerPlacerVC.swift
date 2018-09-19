//
//  ViewController.swift
//  BunkerDown
//
//  Created by Andre Burgoyne on 2018-09-17.
//  Copyright © 2018 Andre Burgoyne. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class BunkerPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    //outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var selectedBunkerName: String?
    var selectedBunker: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeBunker(position: hitPosition)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func onBunkerBtnPressed(_ sender: UIButton) {
        let bunkerPickerVC = BunkerPickerVC(size: CGSize(width: 250, height: 500))
        bunkerPickerVC.bunkerPlacerVC = self
        bunkerPickerVC.modalPresentationStyle = .popover
        bunkerPickerVC.popoverPresentationController?.delegate = self
        present(bunkerPickerVC, animated: true, completion: nil)
        bunkerPickerVC.popoverPresentationController?.sourceView = sender
        bunkerPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func onBunkerSelected(_ bunkerName: String) {
        selectedBunkerName = bunkerName
    }
    
    func placeBunker(position: SCNVector3) {
        if let bunkerName = selectedBunkerName {
            controls.isHidden = false
            let bunker = Bunker.getBunkerForName(bunkerName: bunkerName)
            selectedBunker = bunker
            bunker.position = position
            bunker.scale = SCNVector3Make(0.5, 0.5, 0.5)
            sceneView.scene.rootNode.addChildNode(bunker)
        }
    }
    
    @IBAction func onRemovePressed(_ sender: Any) {
        if let bunker = selectedBunker {
            bunker.removeFromParentNode()
            selectedBunker = nil
        }
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        if let bunker = selectedBunker {
            if gesture.state == .ended {
                bunker.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateBtn {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    bunker.runAction(rotate)
                } else if gesture.view === upBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    bunker.runAction(move)
                } else if gesture.view === downBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    bunker.runAction(move)
                }
            }
        }
    }
}
