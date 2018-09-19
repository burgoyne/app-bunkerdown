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

    @IBOutlet var sceneView: ARSCNView!
    
    var selectedBunker: String?
    
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
        selectedBunker = bunkerName
    }
    
    func placeBunker(position: SCNVector3) {
        if let bunkerName = selectedBunker {
            let bunker = Bunker.getBunkerForName(bunkerName: bunkerName)
            bunker.position = position
            bunker.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(bunker)
        }
    }
}
