//
//  ViewController.swift
//  ramp-up-arkit
//
//  Created by Arsalan majlesi on 7/8/21.
//

import UIKit
import SceneKit
import ARKit

class MainVC: UIViewController, ARSCNViewDelegate ,UIPopoverPresentationControllerDelegate{

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var rampIconBtn: UIButton!
    
    var rampName: String?
    var rampObj :SCNNode?
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var controllers: UIStackView!
    
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
        
        controllers.isHidden = false
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRec(_:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRec(_:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRec(_:)))
        
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

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @objc func longPressGestureRec(_ gesture:UIGestureRecognizer){
        if let obj = rampObj {
            if gesture.state == .ended {
                obj.removeAllActions()
            }
            if gesture.state == .began {
                if gesture.view === rotateBtn {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    obj.runAction(rotate)
                }
                if gesture.view === upBtn {
                    let moveUp = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    obj.runAction(moveUp)
                }
                if gesture.view === downBtn {
                    let moveDown = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    obj.runAction(moveDown)
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touche = touches.first else { return }
        
        let results = sceneView.hitTest(touche.location(in: sceneView), types: [.featurePoint])
        
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3(hitTransform.m41,hitTransform.m42,hitTransform.m43)
        
        placeRamp(position: hitPosition)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func rampSelected(rampName:String){
        self.rampName = rampName
        controllers.isHidden = false
    }
    
    @IBAction func rampIconPressed(_ sender: UIButton) {
        let rampPickerVc = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVc.modalPresentationStyle = .popover
        rampPickerVc.popoverPresentationController?.delegate = self
        rampPickerVc.mainVc = self
        present(rampPickerVc, animated: true, completion: nil)
        rampPickerVc.popoverPresentationController?.sourceView = sender
        rampPickerVc.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func placeRamp(position:SCNVector3){
        guard let objName = rampName else {return}
        let obj = Ramp.getRamp(byName: objName)
        obj.scale = SCNVector3(0.01, 0.01, 0.01)
        obj.position = position
        sceneView.scene.rootNode.addChildNode(obj)
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        rampObj?.removeFromParentNode()
        rampName = ""
        rampObj = nil
    }
    
    
}
