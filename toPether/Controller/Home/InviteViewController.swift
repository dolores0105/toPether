//
//  InviteViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/25.
//

import UIKit
import AVFoundation

class InviteViewController: UIViewController {
    
    convenience init(pet: Pet) {
        self.init()
        self.pet = pet
    }
    private var pet: Pet!
    private var invitedMemberId: String!
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else {
            self.presentErrorAlert(message: "Fail to get camara, please try again")
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
            
        } catch {
            print(error)
            self.presentErrorAlert(message: error.localizedDescription + " Please try again")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Scan QR Code"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white, titleTextSize: 20)

        self.tabBarController?.tabBar.isHidden = true
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    // MARK: - UI properties
    
    private lazy var qrCodeBounds: UIView = {
        let qrCodeBounds = UIView()
        qrCodeBounds.layer.borderColor = UIColor.mainBlue.cgColor
        qrCodeBounds.layer.borderWidth = 3
        view.addSubview(qrCodeBounds)
        view.bringSubviewToFront(qrCodeBounds)
        return qrCodeBounds
    }()
    
    private lazy var loadingAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieLoading")
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension InviteViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeBounds.frame = CGRect.zero
            print("No QRCode is detected")
            return
        }
        
        guard let metaDataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metaDataObject.type == AVMetadataObject.ObjectType.qr {
            if let barCodeObject = previewLayer?.transformedMetadataObject(for: metaDataObject) {
                qrCodeBounds.frame = barCodeObject.bounds
                
                if metaDataObject.stringValue != nil, let stringValue = metaDataObject.stringValue {
                    invitedMemberId = stringValue
                    
                    configLoadingAnimation()
                    
                    MemberManager.shared.queryMember(id: invitedMemberId) { member in
                        guard let member = member else { return }
                        self.showScannedResult(member: member)
                    }
                }
            }
        }
    }
    
    private func showScannedResult(member: Member) {

        LottieAnimation.shared.stopAnimation(lottieAnimation: loadingAnimationView)
        
        let scanResultViewController = ScanResultViewController(pet: pet, scannedMemberId: invitedMemberId)
        scanResultViewController.modalTransitionStyle = .crossDissolve
        scanResultViewController.modalTransitionStyle = .coverVertical
        scanResultViewController.delegate = self
        present(scanResultViewController, animated: true, completion: nil)
        
        captureSession.stopRunning()
    }
    
    private func configLoadingAnimation() {
        view.addSubview(loadingAnimationView)
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            loadingAnimationView.heightAnchor.constraint(equalTo: loadingAnimationView.widthAnchor)
        ])
    }
}

// MARK: - ScanResultViewControllerDelegate

extension InviteViewController: ScanResultViewControllerDelegate {
    func backToHomeVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dismissScanResult() {
        self.captureSession.startRunning()
        qrCodeBounds.frame = CGRect.zero
    }
}
