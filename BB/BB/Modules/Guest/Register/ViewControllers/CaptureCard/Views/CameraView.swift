//
//  CameraView.swift
//  BB
//

import UIKit
import AVFoundation

class CameraView: UIView {
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var movieFileOutput: AVCapturePhotoOutput?

    var didCaptureImageCallback: ((UIImage) -> Void)?
    
    // MARK: - LifeCycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Functions
    func setupViews() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        // Configure the video input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error)
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        // Configure the video output
        
        movieFileOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(movieFileOutput!) {
            captureSession.addOutput(movieFileOutput!)
        }

        // Configure the video preview layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = self.bounds
        self.layer.addSublayer(videoPreviewLayer!)

        // Add a capture button
        let captureButton = UIButton(frame: CGRect(x: self.frame.midX - 50, y: self.frame.maxY - 100, width: 100, height: 50))
        captureButton.setTitle("Capture", for: .normal)
        captureButton.backgroundColor = .blue
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        self.addSubview(captureButton)

        // Start the capture session
        captureSession.startRunning()

    }
    
    @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true

        self.movieFileOutput?.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        
        didCaptureImageCallback?(image)
        
        // Do something with the captured image, e.g., display it in a UIImageView:
//        let imageView = UIImageView(image: image)
//        imageView.frame = self.bounds
//        self.addSubview(imageView)
    }
}
