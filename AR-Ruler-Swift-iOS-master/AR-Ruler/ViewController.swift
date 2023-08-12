//
//  ViewController.swift
//  AR-Ruler
//
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate
{

    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if dotNodes.count >= 2 // Removing dots after 3 dot is pressed. Clearing screen.
        {
            for dot in dotNodes
            {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]() // Creating new empty array of dotNodes to start again.
        }
                
        //print("Touches detected")
        if let touchesLocation = touches.first?.location(in: sceneView)
        {
            let hitTestResults = sceneView.hitTest(touchesLocation, types: .featurePoint)
            if let hitResult = hitTestResults.first
            {
                addDot(at: hitResult) // Passing location results to add function
            }
        }
    }
    
    // Adding red dot where user touches
    func addDot(at hitResult: ARHitTestResult)
    {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode) // Adding new nodes to the array.
        if dotNodes.count >= 2
        {
            calculate() // Calling calculate function
        }
        
    }
    
    func calculate()
    {
        let start = dotNodes[0] // 1st array value
        let end = dotNodes[1] // 2nd array value
        
        //Formula
        //Distance = SquareRoot((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        
        //print(abs(distance)) //absolute value , to remove signs in front
        
        updateText(text: "\(abs(distance))", atPosition: start.position)
    }
    
    func updateText(text: String, atPosition: SCNVector3)
    {
        textNode.removeFromParentNode() // Clearing any previous text
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0.25)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.gray
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(atPosition.x, atPosition.y + 0.01, atPosition.z) // Giving text position from start point
        textNode.scale = SCNVector3(0.01, 0.01, 0.01) // Scaling the text to 1%
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


}
