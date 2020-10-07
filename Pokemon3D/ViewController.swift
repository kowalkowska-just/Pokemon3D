//
//  ViewController.swift
//  Pokemon3D
//
//  Created by Justyna Kowalkowska on 03/10/2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main){
            
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images successfully added.")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        sceneView.autoenablesDefaultLighting = true
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let namePoke = imageAnchor.referenceImage.name!
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -Float.pi / 2
            
            node.addChildNode(planeNode)
            
            showPoke(in: planeNode, namePoke: namePoke)
        
        }
        return node
    }
    
    func showPoke(in planeNode: SCNNode, namePoke: String) {
        
        let poke3D: String = "art.scnassets/\(namePoke).scn"
        
        if let pokeScene = SCNScene(named: poke3D) {
            
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                
                pokeNode.eulerAngles.x = Float.pi/2
                
                if namePoke == "Oddish" {
                    pokeNode.eulerAngles.x = Float.pi
                }
                
                planeNode.addChildNode(pokeNode)
                
            }
        }

    }
    
}

