//
//  ViewController.swift
//  AR-Pokemon
//
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate
{

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true // Enable light on 3D objects.
    }
    
    //Adding Image assets to image tracking
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARImageTrackingConfiguration() // Need image tracking config
        let configuration = ARWorldTrackingConfiguration() // All config is inside.
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) // To track the 2d image from assets
        {
            //configuration.trackingImages = imageToTrack // Should use when imagetracking config is set.
            configuration.detectionImages = imageToTrack // Should use when worldtracking config is set.
            configuration.maximumNumberOfTrackedImages = 2 // Only tracks 2 images on AR
            //print("Images successfully added")
            //print(imageToTrack)
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Anchor is detected(Image), Node is response in AR
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    {
        let node = SCNNode()
        
        //Setting anchor as imageAnchor
        if let imageAnchor = anchor as? ARImageAnchor
        {
            // Getting plane size from image asset physical image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            let planeNode = SCNNode(geometry: plane) // Creating plane 3d object
            planeNode.eulerAngles.x = -Float.pi / 2 // Rotating plane from vertical to horizontal
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.5) // Reducing transperancy of plane color
        
            node.addChildNode(planeNode)
            
           //MARK: - Checking card and detecting which pokemon
            
            if imageAnchor.referenceImage.name == "eevee-card"
            {
                // Creating pokemon 3d on the plane
                if let pokeScene = SCNScene(named: "art.scnassets/Eevee/Eevee.scn")
                {
                    if let pokeNode = pokeScene.rootNode.childNodes.first
                    {
                        pokeNode.eulerAngles.x = Float.pi / 2 // Rotating pokeNode to 90Degree on plane.
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "oddish-card"
            {
                // Creating pokemon 3d on the plane
                if let pokeScene = SCNScene(named: "art.scnassets/Oddish/Oddish.scn")
                {
                    if let pokeNode = pokeScene.rootNode.childNodes.first
                    {
                        pokeNode.eulerAngles.x = -Float.pi // Rotating pokeNode to 90Degree on plane.
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
        }
        return node
    }
}
