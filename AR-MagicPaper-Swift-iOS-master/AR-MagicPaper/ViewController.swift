//
//  ViewController.swift
//  AR-MagicPaper
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
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaper", bundle: Bundle.main) // To track the 2d image from assets
               {
                   //configuration.trackingImages = imageToTrack // Should use when imagetracking config is set.
                   configuration.trackingImages = imageToTrack // Should use when worldtracking config is set.
                   configuration.maximumNumberOfTrackedImages = 1 // Only tracks 2 images on AR
                   print("Images successfully added")
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    {
        let node = SCNNode()
        
        //Setting anchor as imageAnchor
        if let imageAnchor = anchor as? ARImageAnchor
        {
            
            
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4") // Creating a video node for AR.
            videoNode.play() // Playing the video
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360)) // Allows spritekit object to play in scenekit. Pixels of video size.
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2 , y: videoScene.size.height / 2) // Positioning video in center.
            
            videoNode.yScale = -1 // Flipping video from downside to upright.
            
            videoScene.addChild(videoNode)
            
            
            // Getting plane size from image asset physical image
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            let planeNode = SCNNode(geometry: plane) // Creating plane 3d object
            planeNode.eulerAngles.x = -Float.pi / 2 // Rotating plane from vertical to horizontal
            plane.firstMaterial?.diffuse.contents = videoScene // Adding video scene for 3D Object.
            //UIColor(white: 1, alpha: 0.5) // Reducing transperancy of plane color(75)
            
            node.addChildNode(planeNode)
        }
        return node
    }
    
    
    
    

    // MARK: - ARSCNViewDelegate
    

}
