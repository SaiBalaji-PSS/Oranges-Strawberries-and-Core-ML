//
//  ViewController.swift
//  Demo
//
//  Created by saibalaji on 26/05/20.
//  Copyright © 2020 saibalaji. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    var name:String = ""
    @IBOutlet weak var fruitnamelbl: UILabel!
    @IBOutlet weak var fruitImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    
    @IBAction func classifybtnclicked(_ sender: Any) {
        
        excecuteRequest(image: fruitImageView.image!)
        
   
    }
    
  
    
    
    
    
    
    
    
    @IBAction func piclimage(_ sender: Any) {
        getimage()
    }
    
    
    
    func mlrequest() -> VNCoreMLRequest
    {   var myrequest: VNCoreMLRequest?
        
        
        
        let modelobj = ImageClassifier()
        
        
        do
        {
            let fruitmodel = try VNCoreMLModel(for: modelobj.model)
            
            
            
            myrequest = VNCoreMLRequest(model: fruitmodel, completionHandler: { (request, error) in
                self.handleResult(request: request, error: error)
                
            })
            
        }
            
        catch
        {
            print("Unable to create a request")
        }
        myrequest!.imageCropAndScaleOption = .centerCrop
        return myrequest!
    }
    
    
    
    
    
    func excecuteRequest(image: UIImage)
    {
        
        guard  let ciImage = CIImage(image: image)  else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            do
            {
                try handler.perform([self.mlrequest()])
                
            }
            catch
            {
                print("Failed to get the description")
            }
            
        }
        
        
        
        
        
    }
    
    func handleResult(request: VNRequest,error: Error?)
    {
        
        if let classificationresult = request.results as? [VNClassificationObservation]
        {
            DispatchQueue.main.async {
                self.fruitnamelbl.text = classificationresult.first!.identifier
                print(classificationresult.first!.identifier)
            }
            
        }
            
        else
        {
            print("Unable to get the results")
        }
        
        
        
        
        
    }
}


extension ViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    
    func getimage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker,animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let fimage = info[.editedImage] as! UIImage
        
        fruitImageView.image = fimage
        
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}



