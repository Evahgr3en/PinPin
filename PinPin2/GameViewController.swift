//
//  GameViewController.swift
//  PinPin2
//
//  Created by Everlaynne Melo on 25/02/19.
//  Copyright © 2019 Everlaynne Melo. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    var ballNode:SCNNode!
    var stabilizerNode:SCNNode!
    var groundNode:SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    var sounds:[String:SCNAudioSource] = [:]
    
    
    override func viewDidLoad() {
        setupScene()
        setupNodes()
        setupSounds()
        self.sceneView.debugOptions = SCNDebugOptions.showPhysicsShapes
        self.sceneView.debugOptions = SCNDebugOptions.showBoundingBoxes
    }
    
    func setupScene(){
        sceneView = self.view as! SCNView
        sceneView.allowsCameraControl = true
        scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    func setupNodes () {
        ballNode = scene.rootNode.childNode(withName: "Ball", recursively: true)!
        stabilizerNode = scene.rootNode.childNode(withName: "Stabilizer", recursively: true)!
        groundNode = scene.rootNode.childNode(withName: "ground", recursively: true)!
    }
    
    func setupSounds() {
        let jumpSound = SCNAudioSource(fileNamed: "jump.wav")!
        let hitSound = SCNAudioSource(fileNamed: "hiting.wav")!
        let rollSound = SCNAudioSource(fileNamed: "rolling.wav")!
        jumpSound.load()
        hitSound.load()
        rollSound.load()
        jumpSound.volume = 0.4
        hitSound.volume = 0.4
        rollSound.volume = 0.3
        
        sounds["jump"] = jumpSound
        sounds["hit"] = hitSound
        sounds["roll"] = rollSound
        
        let bgSound = SCNAudioSource(fileNamed: "background.mp3")!
        bgSound.volume = 0.1
        bgSound.loops = true
        bgSound.load()
        
        let musicPlayer = SCNAudioPlayer(source: bgSound)
        ballNode.addAudioPlayer(musicPlayer)
        
        
    }
    
    @objc func sceneViewTapped (recognizer:UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node{
                if node.name == "Ball" {
                    let jumpSound = sounds["jump"]!
                    ballNode.runAction(SCNAction.playAudio(jumpSound, waitForCompletion: false))
                    ballNode.physicsBody?.applyForce(SCNVector3(0, 4, -2), asImpulse: true)
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
