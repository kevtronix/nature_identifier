import UIKit
import AVFoundation

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
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("Error capturing photo: \(error?.localizedDescription ?? "Unknown")")
            return
        }
        DispatchQueue.main.async {
            self.showProcessingScreen()
        }
        PlantAPIService.shared.uploadImage(image: image, urlString: "https://plant.id/api/v3/identification?details=common_names,url,description,taxonomy,rank,gbif_id,inaturalist_id,image,synonyms,edible_parts,watering&language=en") { response in
            DispatchQueue.main.async {
                print(response)
                self.showResultScreen(response)
            }
        }
    }

    func showProcessingScreen() {
        let processingVC = ProcessingViewController()
        self.present(processingVC, animated: true, completion: nil)
    }

    func showResultScreen(_ response: PlantIdentificationResponse?) {
        dismiss(animated: true) {
            guard let results = response?.result.classification.suggestions else { return }
            let resultsVC = ResultsViewController()
            resultsVC.plantSuggestions = results
            self.navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
}



