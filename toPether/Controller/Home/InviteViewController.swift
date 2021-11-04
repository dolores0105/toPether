//
//  InviteViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/25.
//

import UIKit
import AVFoundation
import Lottie

class InviteViewController: UIViewController {
    
    convenience init(pet: Pet) {
        self.init()
        self.pet = pet
    }
    private var pet: Pet!
    private var invitedMemberId: String!
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var qrCodeBounds: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else {
            print("fail to get camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            guard let previewLayer = previewLayer else { return }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.layer.frame
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
            
            qrCodeBounds = UIView()
            
            if let qrCodeBounds = qrCodeBounds {
                qrCodeBounds.layer.borderColor = UIColor.mainBlue.cgColor
                qrCodeBounds.layer.borderWidth = 3
                view.addSubview(qrCodeBounds)
                view.bringSubviewToFront(qrCodeBounds)
            }
            
        } catch {
            print(error)
        }
        
//        animationView = .init(name: "LottieDone")
//        animationView.contentMode = .scaleAspectFit
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.isHidden = true
//        view.addSubview(animationView)
//        NSLayoutConstraint.activate([
//            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
//        ])
    }
    
    // MARK: functions
    @objc func tapOK(sender: UIButton) {
        // check the invitedMemberId that user inputs is existing
//        MemberModel.shared.queryMember(id: invitedMemberId) { [weak self] member in
//            guard let self = self else { return }
//            if let member = member {
//                print("the member is existing", member.id)
                // add petId to member's petIds
//                if !member.petIds.contains(self.pet.id) {
//                    member.petIds.append(self.pet.id)
//                    MemberModel.shared.updateMember(member: member)
//                }
                
                // add invitedMemberId to pet's memberIds
//                if !self.pet.memberIds.contains(member.id) {
//                    self.pet.memberIds.append(member.id)
//                    PetModel.shared.updatePet(id: self.pet.id, pet: self.pet)
//
//                    self.animationView.isHidden = false
//                    self.animationView?.play(completion: { _ in
//                        self.navigationController?.popViewController(animated: true)
//                    })
                    
//                } else {
//                    self.idTextField.text = ""
//                    self.idTextField.becomeFirstResponder()
//                    self.wrongInputLabel.isHidden = false
//                    self.wrongInputLabel.text = "You've toPether \(self.pet.name)."
//                    self.okButton.isEnabled = false
//                    self.okButton.backgroundColor = .lightBlueGrey
//                }

//            } else {
//                print("NOT existing")
//                self.idTextField.text = ""
//                self.idTextField.becomeFirstResponder()
//                self.wrongInputLabel.isHidden = false
//                self.okButton.isEnabled = false
//                self.okButton.backgroundColor = .lightBlueGrey
//            }
//        }
    }
}

extension InviteViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeBounds?.frame = CGRect.zero
            print("No QRCode is detected")
            return
        }
        
        guard let metaDataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metaDataObject.type == AVMetadataObject.ObjectType.qr {
            if let barCodeObject = previewLayer?.transformedMetadataObject(for: metaDataObject) {
                qrCodeBounds?.frame = barCodeObject.bounds
                
                if metaDataObject.stringValue != nil, let stringValue = metaDataObject.stringValue {
                    invitedMemberId = stringValue
                    
                    MemberModel.shared.queryMember(id: invitedMemberId) { member in
                        guard let member = member else { return }
                        self.showScannedResult(member: member)
                    }
                }
            }
        }
    }
    
    func showScannedResult(member: Member) {

        let scanResultViewController = ScanResultViewController(pet: pet, scannedMemberId: invitedMemberId)
        scanResultViewController.modalTransitionStyle = .crossDissolve
        scanResultViewController.modalTransitionStyle = .coverVertical
        scanResultViewController.delegate = self
        present(scanResultViewController, animated: true, completion: nil)
        
        captureSession.stopRunning()
    }
    
}

extension InviteViewController: ScanResultViewControllerDelegate {
    func dismissScanResult() {
        self.captureSession.startRunning()
        qrCodeBounds?.frame = CGRect.zero
    }
}
