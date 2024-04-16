import AVFoundation
import UIKit

class ViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraButton: UIButton!
    var photoOutput: AVCapturePhotoOutput?
    var previewImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLiveCameraView()
        setupCameraButton()
        setupPreviewImageView()
    }
    
    func setupPreviewImageView() {
        previewImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        previewImageView.contentMode = .scaleAspectFit
        view.addSubview(previewImageView)
        view.bringSubviewToFront(previewImageView)
    }
    
    

    func setupLiveCameraView() {
        captureSession = AVCaptureSession()
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession?.addInput(input)
            photoOutput = AVCapturePhotoOutput()
            if let photoOutput = photoOutput {
                if captureSession!.canAddOutput(photoOutput) {
                    captureSession!.addOutput(photoOutput)
                    photoOutput.isHighResolutionCaptureEnabled = true
                    photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
                }
            }
        } catch {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        captureSession?.startRunning()
    }
    
    func setupCameraButton() {
           cameraButton = UIButton(type: .custom)
           cameraButton.backgroundColor = .systemBlue
           cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
           cameraButton.tintColor = .white
           cameraButton.layer.cornerRadius = 35
           cameraButton.translatesAutoresizingMaskIntoConstraints = false
           cameraButton.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
           view.addSubview(cameraButton)
           view.bringSubviewToFront(cameraButton) // Make sure button is on top of the camera preview

           NSLayoutConstraint.activate([
               cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
               cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               cameraButton.widthAnchor.constraint(equalToConstant: 70),
               cameraButton.heightAnchor.constraint(equalToConstant: 70)
           ])
       }

    @objc func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        
        if let photoOutput = photoOutput {
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }

        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            print("Photo captured successfully")
            DispatchQueue.main.async {
                self.previewImageView.image = image
                
            }
        } else {
            print("Failed to convert photo data to UIImage")
        }
    }
}

