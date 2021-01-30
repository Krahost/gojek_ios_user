//
//  CourierAddAddressController.swift
//  GoJekUser
//
//  Created by Sudar on 10/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierAddAddressController: UIViewController {
    
    @IBOutlet weak var receiverNameTextfield:CustomTextField!
    @IBOutlet weak var receiverPhoneTextfield:CustomTextField!
    @IBOutlet weak var deliveryInstructionTextfield:CustomTextField!
    @IBOutlet weak var packageTypeTextfield:CustomTextField!
    @IBOutlet weak var packageDetailsTextfield:CustomTextField!
    @IBOutlet weak var repeatLastButton:UIButton!
    @IBOutlet weak var resetButton:UIButton!
    @IBOutlet weak var locationButton:UIButton!
    @IBOutlet weak var loctionLabel:UILabel!
    @IBOutlet weak var deliveryDetailsLabel:UILabel!
    @IBOutlet weak var loctionView:UIView!
    @IBOutlet weak var weightTexfield: CustomTextField!
    @IBOutlet weak var submitButton:UIButton!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var buttonUpload: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var labelUpload: UILabel!
    @IBOutlet weak var labelFragile: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var labelYes: UILabel!
    @IBOutlet weak var labelNo: UILabel!
    @IBOutlet weak var lengthTextfield: CustomTextField!
    @IBOutlet weak var breathTextfield: CustomTextField!
    @IBOutlet weak var heightTextfield: CustomTextField!
    
    var packageData : CourierPackagesList?
    var delegate : AddRequest?
    var imageData: Data!
    var selecedLocation : SourceDestinationLocation?
    var editData : CourierData? = nil
    var editIndex = Int()
    var isEdit = false
    var editPackage = Int()
    var isFragile = false {
        
        didSet {
            
            self.btnYes.setImage(isFragile == true ? #imageLiteral(resourceName: "ic_square_fill") : #imageLiteral(resourceName: "ic_square_empty"), for: .normal)
            self.buttonNo.setImage(isFragile == false ? #imageLiteral(resourceName: "ic_square_fill") : #imageLiteral(resourceName: "ic_square_empty"), for: .normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoads()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        if(editData != nil){
            setEditValue()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true

    }
    
    
    private func setEditValue(){
        
        receiverNameTextfield.text = editData?.receiver_name ?? ""
        receiverPhoneTextfield.text = editData?.receiver_mobile ?? ""
        deliveryInstructionTextfield.text = editData?.receiver_instruction ?? ""
        weightTexfield.text = editData?.weight?.toString()
        heightTextfield.text = editData?.height?.toString()
        lengthTextfield.text = editData?.length?.toString()
        breathTextfield.text = editData?.breadth?.toString()
        self.packageDetailsTextfield.text = editData?.package_details ?? ""
        imageData = editData?.picture
        if(editData?.picture != nil){
            self.selectedImage.image = UIImage(data: editData?.picture ?? Data())
            self.buttonUpload.setTitle("", for: .normal)
            self.buttonUpload.setImage(UIImage.init(named: "j"), for: .normal)
        }
//        self.selecedLocation?.locationCoordinate?.latitude = editData?.d_latitude ?? 0.00
//        self.selecedLocation?.locationCoordinate?.longitude = editData?.d_longitude ?? 0.00
        self.loctionLabel.text = editData?.d_address ?? ""
        selecedLocation = SourceDestinationLocation(address: editData?.d_address ?? "", locationCoordinate:  LocationCoordinate(latitude: editData?.d_latitude ?? 0.00, longitude: editData?.d_longitude ?? 0.00))
        if((editData?.is_fragile ?? 0) == 0){
        isFragile = false
        }
        else{
        isFragile = true
        }
        editPackage = editData?.package_type_id ?? 0
        editData = nil
    }
    
    private func validate(){
        guard let receiverName = self.receiverNameTextfield.text, !receiverName.isEmpty else{
            receiverNameTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.emptyReceiverName, state: .error)
        }
        guard let receivermobile = self.receiverPhoneTextfield.text, !receivermobile.isEmpty else{
            receiverPhoneTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.emptyReceiverMobileNUmber, state: .error)
        }
        
        guard let instruction = self.deliveryInstructionTextfield.text, !instruction.isEmpty else{
            deliveryInstructionTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.emptyInstruction, state: .error)
        }
        
        guard  let weight = self.weightTexfield.text, !weight.isEmpty else{
            weightTexfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.emptyWeight, state: .error)
        }
        if((Int(weight) ?? 0) > (Int(Double(VWeight)) )){
            weightTexfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.weightIncreaseValidation + VWeight.toString(), state: .error)
        }
        if(((Int(lengthTextfield.text ?? "0") ?? 0) > (Int(Double(VLength)))) && ((lengthTextfield.text ?? "") != "")){
            lengthTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.lengthIncreaseValidation + VLength.toString(), state: .error)
        }
        if(((Int(breathTextfield.text ?? "0") ?? 0) > (Int(Double(VBreadth) ))) && ((breathTextfield.text ?? "") != "")){
            breathTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.breadthIncreaseValidation + VBreadth.toString(), state: .error)
        }
        if(((Int(heightTextfield.text ?? "0") ?? 0) > (Int(Double(VHeight) ))) && ((heightTextfield.text ?? "") != "")){
            heightTextfield.becomeFirstResponder()
            return ToastManager.show(title: CourierConstant.heightIncreaseValidation + VHeight.toString(), state: .error)
        }
        
        if selecedLocation == nil {
            return ToastManager.show(title: CourierConstant.emptyDestinationAddress, state: .error)
        }
        
        var requestData = CourierData()
        requestData.receiver_name = receiverName
        requestData.receiver_mobile = receivermobile
        requestData.receiver_instruction = instruction
        requestData.weight = Int(weight)
        requestData.height = Int(heightTextfield.text ?? "0")
        requestData.length = Int(lengthTextfield.text ?? "0")
        requestData.breadth = Int(breathTextfield.text ?? "0")
        requestData.picture = imageData
        requestData.package_details = self.packageDetailsTextfield.text ?? ""
        requestData.d_latitude = self.selecedLocation?.locationCoordinate?.latitude
        requestData.d_longitude = self.selecedLocation?.locationCoordinate?.longitude
        requestData.d_address = self.selecedLocation?.address
        requestData.is_fragile = isFragile == true ? 1 : 0
        
        for package in self.packageData?.responseData ?? [] {
            if package.package_name == packageTypeTextfield.text {
                requestData.package_type_id = package.id
            }
        }
        requestData.distance = 8
        if(isEdit == false){
        self.delegate?.sendBackAddedValues(values:requestData, isEdited: false, editIndex: editIndex)
        }
        else{
        self.delegate?.sendBackAddedValues(values:requestData, isEdited: true, editIndex: editIndex)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(sender:UIButton){
        validate()
    }
    
    @IBAction func selectImage(sender:UIButton){
        self.showImage(with: { (image) in
            self.selectedImage.layer.cornerRadius = 8
            self.selectedImage.image = image
            if  let selectedImageData =   self.selectedImage?.image?.jpegData(compressionQuality: 0){
                self.imageData = selectedImageData
                
            }
                self.buttonUpload.setTitle("", for: .normal)
                self.buttonUpload.setImage(UIImage.init(named: "j"), for: .normal)
        })
    }
    
    @IBAction func selectAddress(sender:UIButton){
        let vc = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.LocationSelectionController) as! LocationSelectionController
        vc.locationDelegate = self
        vc.isFromCourier = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension CourierAddAddressController {
    private func initialLoads(){
        self.courierPresenter?.getCourierPackageList()
        self.setNavigationBar()
        setFont()
        setColor()
        setShadows()
        setTitle()
        locationButton.addTarget(self, action: #selector(selectAddress(sender:)), for: .touchUpInside)
        buttonUpload.addTarget(self, action: #selector(selectImage(sender:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
        btnYes.tag = 1
        buttonNo.tag = 2
        buttonNo.addTarget(self, action: #selector(fragileAction(sender:)), for: .touchUpInside)
        btnYes.addTarget(self, action: #selector(fragileAction(sender:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetAction(sender:)), for: .touchUpInside)
        selectedImage.layer.borderColor = UIColor.black.cgColor
        selectedImage.layer.borderWidth = 1
        receiverNameTextfield.delegate = self
        receiverPhoneTextfield.delegate = self
        deliveryInstructionTextfield.delegate = self
        packageTypeTextfield.delegate = self
        packageDetailsTextfield.delegate = self
        weightTexfield.keyboardType = .numberPad
        lengthTextfield.keyboardType = .numberPad
        heightTextfield.keyboardType = .numberPad
        breathTextfield.keyboardType = .numberPad
    }
    private func setShadows(){
        resetButton.cornerRadius = 5
        submitButton.cornerRadius = 5
        repeatLastButton.cornerRadius = 5
        loctionView.addShadow(radius: 0.5, color: .lightGray)
        
    }
    private func setNavigationBar() {
        self.title = CourierConstant.toAddress.localized
        setNavigationTitle()
        setLeftBarButtonWith(color: .blackColor)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setColor(){
        resetButton.setTitleColor(.white, for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        repeatLastButton.setTitleColor(.black, for: .normal)
        submitButton.backgroundColor = .courierColor
        resetButton.backgroundColor = .courierColor
        repeatLastButton.layer.borderColor = UIColor.courierColor.cgColor
        repeatLastButton.layer.borderWidth = 1

    }
    private func setTitle(){
        deliveryDetailsLabel.text = CourierConstant.deliveryDetails
        receiverNameTextfield.placeholder = CourierConstant.receiverName
        receiverPhoneTextfield.placeholder = CourierConstant.receiverPhoneNumber
        deliveryInstructionTextfield.placeholder = CourierConstant.deliveryInstruction
        packageTypeTextfield.placeholder = CourierConstant.packageType
        packageDetailsTextfield.placeholder = CourierConstant.packageDetails
        weightTexfield.placeholder = CourierConstant.weight1
        lengthTextfield.placeholder = CourierConstant.lentgh1
        breathTextfield.placeholder = CourierConstant.breath1
        heightTextfield.placeholder = CourierConstant.height1
        repeatLastButton.setTitle(CourierConstant.repeatLast, for: .normal)
        resetButton.setTitle(CourierConstant.reset, for: .normal)
        submitButton.setTitle(CourierConstant.submit, for: .normal)
        loctionLabel.text = CourierConstant.destinationAddr
    }
    
    private func setFont(){
        deliveryDetailsLabel.font = .setCustomFont(name: .bold, size: .x16)
        receiverNameTextfield.font = .setCustomFont(name: .medium, size: .x14)
        receiverPhoneTextfield.font = .setCustomFont(name: .medium, size: .x14)
        deliveryInstructionTextfield.font = .setCustomFont(name: .medium, size: .x14)
        packageTypeTextfield.font = .setCustomFont(name: .medium, size: .x14)
        packageDetailsTextfield.font = .setCustomFont(name: .medium, size: .x14)
        repeatLastButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        resetButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        loctionLabel.font = .setCustomFont(name: .medium, size: .x14)
        labelUpload.font = .setCustomFont(name: .bold, size: .x16)
        labelFragile.font = .setCustomFont(name: .bold, size: .x16)
        labelYes.font = .setCustomFont(name: .medium, size: .x14)
        labelNo.font = .setCustomFont(name: .medium, size: .x14)
        weightTexfield.font = .setCustomFont(name: .medium, size: .x14)
        lengthTextfield.font = .setCustomFont(name: .medium, size: .x14)
        breathTextfield.font = .setCustomFont(name: .medium, size: .x14)
        heightTextfield.font = .setCustomFont(name: .medium, size: .x14)
        buttonUpload.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        submitButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    @IBAction func fragileAction(sender:UIButton){
        isFragile = sender.tag == 1 ? true : false
    }
    
    @IBAction func resetAction(sender:UIButton){
        receiverNameTextfield.text = nil
        receiverPhoneTextfield.text = nil
        deliveryInstructionTextfield.text = nil
        //packageTypeTextfield.text = nil
        packageDetailsTextfield.text = nil
        weightTexfield.text = nil
        lengthTextfield.text = nil
        breathTextfield.text = nil
        heightTextfield.text = nil
        loctionLabel.text = CourierConstant.destinationAddr.localized
        self.btnYes.setImage( #imageLiteral(resourceName: "ic_square_empty"), for: .normal)
        self.buttonNo.setImage(#imageLiteral(resourceName: "ic_square_empty"), for: .normal)
        
    }
}
extension CourierAddAddressController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == packageTypeTextfield {
            if self.packageData?.responseData?.count != 0 {
                var packageTypeArr: [String]  = []
                for package in self.packageData?.responseData ?? [] {
                    packageTypeArr.append(package.package_name ?? "")
                }
                PickerManager.shared.showPicker(pickerData: packageTypeArr, selectedData: nil) { [weak self] (selectedType) in
                    guard let self = self else {
                        return
                    }
                    self.packageTypeTextfield.text = selectedType
                    
                    self.view.setNeedsUpdateConstraints()
                    self.view.layoutIfNeeded()
                }
                return false
            }
        }
        return true
    }
}

//MARK:- Location delegate

extension  CourierAddAddressController: LocationDelegate {
    
    func selectedLocation(isSource: Bool, addressDetails: SourceDestinationLocation) {
        self.selecedLocation = addressDetails
        self.loctionLabel.text = self.selecedLocation?.address
        
    }
}

extension  CourierAddAddressController: CourierPresenterToCourierViewProtocol{
    
    func courierPackageListSuccess(requestEntity: CourierPackagesList) {
        self.packageData = requestEntity
        packageTypeTextfield.text = self.packageData?.responseData?.first?.package_name ?? ""
        for package in self.packageData?.responseData ?? [] {
             if package.id == editPackage {
                  packageTypeTextfield.text = package.package_name
               }
           }
//        packageTypeTextfield.isUserInteractionEnabled = false
    }
}

protocol AddRequest {
    func sendBackAddedValues(values:CourierData, isEdited : Bool, editIndex : Int)
}
