//
//  StartViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit
import MobileCoreServices

class StartViewController: BaseViewController {
    
    fileprivate var modelName: String!
    
    fileprivate var modelsList = [String]()
    
    fileprivate var openModels = [String]()
    
    fileprivate let logoView = UIImageView(image: #imageLiteral(resourceName: "bakalarkaLogo"))
    
    fileprivate var matlabAdapterLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "Avenir-BlackOblique", size: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        label.text = "MatlabAdapter"
        return label
    }()
    
    fileprivate let openModelButton = MAButton(title: "Open model", color: .customBlueColor(), target: self, action: #selector(openMatlabModel))
    
    fileprivate let showOpenModelsButton = MAButton(title: "Show open models", color: .customBlueColor(), target: self, action: #selector(openModelsVC))
    
    fileprivate let uploadButton = MAButton(title: "Upload model", color: .customBlueColor(), target: self, action: #selector(uploadModelFromCloud))
    
    fileprivate let startMatlabButton = MAButton(title: "Start Matlab", color: .customGreenColor(), target: self, action: #selector(startMatlabAdapter))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkMatlabStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        
        view.addSubview(logoView)
        view.addSubview(matlabAdapterLabel)
        view.addSubview(openModelButton)
        view.addSubview(showOpenModelsButton)
        view.addSubview(startMatlabButton)
        view.addSubview(uploadButton)
    }
    
    func checkMatlabStatus() {

        if MatlabService.sharedClient.isMatlabRuning() {
            
            modelsList = MatlabService.sharedClient.getModels().sorted(by: <)
            
            startMatlabButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .done, target: self, action: #selector(stopMatlabAdapter))
            self.navigationItem.rightBarButtonItem?.tintColor = .red
            
            self.navigationItem.leftBarButtonItem = nil
            uploadButton.isHidden = false
            openModelButton.isHidden = false
            showOpenModelsButton.isHidden = false
            
        }
        else {
            
            startMatlabButton.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(openSettings))
            uploadButton.isHidden = true
            openModelButton.isHidden = true
            showOpenModelsButton.isHidden = true
        }
    }
    
    override func setupConstraints() {
        
        logoView.autoPinEdge(toSuperviewEdge: .left, withInset: (UIScreen.main.bounds.size.width-logoView.bounds.size.width)/2)
        logoView.autoPinEdge(.bottom, to: .top, of: matlabAdapterLabel)
        
        matlabAdapterLabel.autoSetDimension(.height, toSize: 50)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        matlabAdapterLabel.autoPinEdge(.bottom, to: .top, of: openModelButton, withOffset: -15)
        
        openModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        openModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        openModelButton.autoPinEdge(.bottom, to: .top, of: showOpenModelsButton, withOffset: -15)
        
        showOpenModelsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        showOpenModelsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        showOpenModelsButton.autoPinEdge(.bottom, to: .top, of: uploadButton, withOffset: -15)
        
        uploadButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        uploadButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        uploadButton.autoPinEdge(.bottom, to: .top, of: startMatlabButton, withOffset: -15)
        
        startMatlabButton.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 15, bottom: 25, right: 15), excludingEdge: .top)
    }
}
    
//BUTTONS ACTIONS
extension StartViewController {
    
    @objc func openSettings() {
            self.navigationController?.pushViewController(SettingsViewController(haveConnection: true), animated: true)
    }
    
    @objc func openMatlabModel() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for enumString in modelsList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                
                self.modelName = enumString
                
                let alertController = SpinnerAlertViewController(title: " ", message: "Opening \(self.modelName as String)...", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)

                DispatchQueue.global(qos: .userInitiated).async {
                    if !MatlabService.sharedClient.isModelOpened(modelName: self.modelName) {
                        MatlabService.sharedClient.openModel(self.modelName)
                    }
                    DispatchQueue.main.async {
                        alertController.dismiss(animated: true, completion: {
                            self.navigationController?.pushViewController(ModelViewController(modelName: self.modelName), animated: true)
                        })
                    }
                }

            }
            alert.addAction(choise)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openModelsVC() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Checking...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        openModels.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            for name in self.modelsList {
                if (MatlabService.sharedClient.isModelOpened(modelName: name)) {
                    self.openModels.append(name)
                }
            }
            
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: {
                    self.navigationController?.pushViewController(OpenModelsViewController(openModels: self.openModels), animated: true)
                })
            }
        }
        
    }
    
    @objc func startMatlabAdapter() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Starting...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.startMatlab()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                self.checkMatlabStatus()
            }
        }
    }
    
    @objc func stopMatlabAdapter() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Stoping...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.stopMatlab()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                self.checkMatlabStatus()
            }
        }
    }
    
    @objc func uploadModelFromCloud() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
//    func load_image(image_url:URL, view:UIImageView) {
//
//        let image_from_url_request: URLRequest = URLRequest(url: image_url as URL)
//
//        NSURLConnection.sendAsynchronousRequest(
//            image_from_url_request as URLRequest, queue: OperationQueue.main,
//            completionHandler: {(response: URLResponse!,
//                data: Data!,
//                error: Error!) -> Void in
//
//                if error == nil && data != nil {
//                    view.image = UIImage(data: data)
//                }
//
//        })
//
//    }
}

extension StartViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        //TODO: download from iCloud
        print("\n\n \(url) \n\n")
        
//        let imageView = UIImageView()
//        self.load_image(image_url: url, view: imageView)
//        self.view.addSubview(imageView)
//        imageView.autoPinEdgesToSuperviewEdges()
    }
}





