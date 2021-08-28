//
//  RampPickerVC.swift
//  ramp-up-arkit
//
//  Created by Arsalan majlesi on 7/8/21.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var size :CGSize!
    var sceneView : SCNView!
    weak var mainVc :MainVC!
    
    init(size:CGSize){
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.frame = CGRect(origin: .zero, size: size)
        sceneView = SCNView(frame: view.bounds)
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRec(_:))))
        
        view.insertSubview(sceneView, at: 0)
        preferredContentSize = size
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene

        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        
        let pipe = Ramp.getRamp(byName: RampType.pipe.rawValue)
        Ramp.rotateObject(object: pipe)
        scene.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getRamp(byName: RampType.pyramid.rawValue)
        Ramp.rotateObject(object: pyramid)
        scene.rootNode.addChildNode(pyramid)

        let quarter = Ramp.getRamp(byName: RampType.quarter.rawValue)
        Ramp.rotateObject(object: quarter)
        scene.rootNode.addChildNode(quarter)

        
    }
    
   
    
    @objc func tapGestureRec(_ gestureRec:UIGestureRecognizer){
        let position = gestureRec.location(in: sceneView)
        let hitResults = sceneView.hitTest(position, options: nil)
        
        if hitResults.count > 0 {
            mainVc.rampSelected(rampName: hitResults[0].node.name!)
            dismiss(animated: true, completion: nil)
        }
    }

}
