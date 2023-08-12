//
//  ViewController.swift
//  AR-Dicee
//
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate
{
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //3D Cube
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial() // Creating a new material object
//        material.diffuse.contents = UIColor.gray // Changing material color
//        cube.materials = [material] // Adding material to the cube.
//
//        let node = SCNNode() // creating a node object
//        node.position = SCNVector3(x: 0, y: 0, z: -0.5) // Positioning the AR
//        node.geometry = cube // Adding the position to the cube
//
//        sceneView.scene.rootNode.addChildNode(node) // Adding child node as node
//        sceneView.autoenablesDefaultLighting = true // adding shadows for good image qualite with shadows
//        ---------------
//        //3D Sun
//        let sphere = SCNSphere(radius: 0.2)
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
//        sphere.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 0, z: -0.5)
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
//        sceneView.autoenablesDefaultLighting = true
        
                
        // Dice in center
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) //Optional Chaining
//        {
//        diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//        sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
        sceneView.autoenablesDefaultLighting = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] // To show points on the plane.

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal // Configuring horizontal plan detection

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //Detecting touch on the plane
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first // Only need 1st touch
        {
            let touchLocation = touch.location(in: sceneView) // Touch location inside screen
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent) // Conver touch from 2D screen into 3D AR
//            if !results.isEmpty
//            {
//                print("Touched the plane")
//            }
//            else
//            {
//                print("Tocuhed somewhere else")
//            }
            if let hitResult = results.first
            {
                // Dice positioned to the touch on the plane
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
            
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) //Optional Chaining
                {
                    diceNode.position = SCNVector3( // Dice positioning on plane based on touch location
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, // Dice above the plane
                        z: hitResult.worldTransform.columns.3.z
                    )
                    diceArray.append(diceNode)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    roll(dice: diceNode)
                }
            }
        }
    }
    
    func roll(dice: SCNNode)
      {
          // Creating random no.s and turning faces of X,Z. Y is on top so no need face change
          let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
          let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
          
              dice.runAction(SCNAction.rotateBy(
              x: CGFloat(randomX * 5), // To give more randomization on faces
              y: 0,
              z: CGFloat(randomZ * 5), // To give more randomization on faces
              duration: 0.5))
      }
    
    // To roll all the dice at once
    func rollAll()
    {
        if !diceArray.isEmpty
        {
            for dice in diceArray
            {
                roll(dice: dice)
            }
        }
    }
    
    // Roll the dice faces again
    @IBAction func rollAgain(_ sender: UIBarButtonItem)
    {
        rollAll()
    }
    
    // Roll faces when shaked
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
    {
        rollAll()
    }
    
    // Removing all dices in plane
    @IBAction func removeAllDice(_ sender: UIBarButtonItem)
    {
        if !diceArray.isEmpty
        {
            for dice in diceArray
            {
                dice.removeFromParentNode()
            }
        }
        
    }
    
    // Detecting horizontal surface and giving width and height to ARanchor
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)
    {
        //guard let planeAnchor = anchor as? ARPlaneAnchor else{return} Can be used for line 180,181,182,183
        if anchor is ARPlaneAnchor // Check if the anchor is arplaneanchor.
        {
            //print("AR Anchor Plane Detected")
            let planeAnchor = anchor as! ARPlaneAnchor // Downcasting anchor as ARPlane anchor, creating obj.
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)) //Similar to scnbox or scnshpere
            let planeNode = SCNNode()
            let planePosition = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
    
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0) //Rotate plane from hriztal to flat.
            
            // Adding Plane grid to horizontal plane
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        }
        else
        {
            return
        }
        
    }


}
