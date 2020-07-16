//
//  SignUpViewController.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SDWebImage
import JJFloatingActionButton



class SignUpViewController: BaseUIViewController {
    
    //MARK:-  Properties
    @IBOutlet weak var viewMail: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var txtFieldDOB: UITextField!
    var gender = KConstants.KMale
    @IBOutlet weak var logoutbtn: UIButton!
    @IBOutlet weak var lblFN: UILabel!
    @IBOutlet weak var lblLN: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPh: UILabel!
    @IBOutlet weak var lblGen: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var topHeightEmail: NSLayoutConstraint!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtfieldStatus: KMPlaceholderTextView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    fileprivate let actionButton = JJFloatingActionButton()
    //MARK:- Variables
    var viewModel:SignUpViewModel?
    var blurView = UIView()
    private var datePickerView:UIDatePicker!
    private var viewDatePickerView:UIView!
    var byteArrayofImages = Data()
    var selectedImageURl : URL?
    var email = ""
    var edit = ""
    var selectedDOB = ""
    var DOBselected = false
    var ageYears : Int?
    var updatedUser = ""
    var viewprofile = ""
    var emailOtheruser = ""
    var role = ""
    var otherUserId = 0
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMail.text = email
        self.title = "Sign Up"
        SetView()
        setData()
        SetpickerView(self.view)
        setDatePickerView(self.view, type: .date)
       
        hideNavigationBackButton()
        BackButton()
        self.txtfieldStatus.contentInset = UIEdgeInsets(top: 8, left: 5, bottom: 5, right: 5);

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
      
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        //role = ""
    }
    
    func setData() {
        if viewprofile == "true"
              {
                  topHeightEmail.constant = 105
                  self.title = "Profile"
                  getUserByPhoneNumber()
                  btnSave.isHidden = true
                  //btnedit.isHidden = false
                   if emailOtheruser !=  "" {
                  self.btnAdd.isHidden = false
                  txtFirstName.isUserInteractionEnabled = false
                  txtLastName.isUserInteractionEnabled = false
                  txtPhoneNo.isUserInteractionEnabled = false
                  btnAddImage.isUserInteractionEnabled = false
                  viewGender.isUserInteractionEnabled = false
                  btnDOB.isUserInteractionEnabled = false
                  actionButton.isHidden = true
                  self.txtfieldStatus.isEditable = false

                  //self.btnedit.setImageColor(color: UIColor.black)
                 // self.btnAdd.setImageColor(color: UIColor.black)
                   self.lblStatus.isHidden = false

                  }
                  
              }
              else
              {
                   topHeightEmail.constant = 13
                  self.btnAdd.isHidden = true
                  actionButton.isHidden = true
                  self.btnedit.isHidden = true
                  self.lblStatus.isHidden = true
                  txtfieldStatus.isHidden = true
                  
              }
    }
    
    func getUserByPhoneNumber(){
        if checkInternetConnection(){
            
            if emailOtheruser !=  "" {
                self.viewModel?.getUserByPhoneNumber(Phone: "", Email: emailOtheruser)
                
            }
            else{
                self.viewModel?.getUserByPhoneNumber(Phone: "", Email: AppDefaults.shared.userEmail)
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    
    @IBAction func actionOtherDetails(_ sender: UIButton) {
//       if self.checkInternetConnection(){
//                           self.showLoader()
//                           let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//                           let newViewController = storyBoard.instantiateViewController(withIdentifier: "OtherDetailsVC") as! OtherDetailsVC
//                           newViewController.modalPresentationStyle = .fullScreen
//                          newViewController.strRole = role
//                           self.navigationController?.pushViewController(newViewController, animated: true)
//                       }
//                       else{
//                           self.showAlert(Message: Alerts.kNoInternetConnection)
//                       }
        
        if checkInternetConnection(){
                     initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                             self.yesNoAlertView.delegate = self
                             yesNoAlertView.lblResponseDetailMessage.text = Alerts.kLogOutAlert
                     }
                            else{
                                self.showAlert(Message: Alerts.kNoInternetConnection)
             
                            }
    }
    
    
    @IBAction func actionEdit(_ sender: UIButton) {
        

        
    }
    
    
    @IBAction func SaveAction(_ sender: Any){
        view.endEditing(true)
        if viewprofile == "true"
        {
            updateData()
        }
        else
        {
            submitButtonAction()}
    }
    
    func updateData() {
        if checkInternetConnection(){
            self.viewModel?.signUpUser(firstName: txtFirstName.text, lastName: txtLastName.text,  email: txtMail.text, phoneNo: txtPhoneNo.text,  imgUrl: selectedImageURl,  gender: gender,dob: selectedDOB, userId: UserDefaultExtensionModel.shared.currentUserId,Bio: txtfieldStatus.text)
            
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func AddImageAction(_ sender: Any){

        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
    }
    
    //Save Button Action
    func submitButtonAction(){
        if checkInternetConnection(){
            self.viewModel?.signUpUser(firstName: txtFirstName.text, lastName: txtLastName.text,  email: txtMail.text, phoneNo: txtPhoneNo.text,  imgUrl: selectedImageURl, gender: gender,dob: selectedDOB,  userId: 0, Bio: "")
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func actionLogout(_ sender: UIButton) {
        
        initializeCustomYesNoAlert(self.view, isHideBlurView: true)
        self.yesNoAlertView.delegate = self
        yesNoAlertView.lblResponseDetailMessage.text = Alerts.kLogOutAlert
        
        
    }
    
    
    @IBAction func selectGender(_ sender: UIButton) {
        
        view.endEditing(true)
        selectGender(btn : sender)
    }
    
    
    @IBAction func selectDOB(_ sender: UIButton) {
        
        if txtFieldDOB.text != "" {
          let Date =   CommonFunctions.sharedmanagerCommon.convertStringIntoDateWithDDMMYYYY(Str: txtFieldDOB.text ?? "")
            print(Date)
            showDatePickerDB(datePickerDelegate: self, date: Date as NSDate)
        }
        else {
            showDatePicker(datePickerDelegate: self) }
    }
    
    
    //Select gender
    func selectGender(btn : UIButton){
//        if role == "" && viewprofile == "true"
//               {
//            actionButton.isHidden = false }
        if(btn.tag == 0) {
            btnmale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KMale
        }
        else if (btn.tag == 1){
            btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KFemale
        }
        else{
            btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            gender = KConstants.KNA
        }
    }
    
    func SetView(){
        //Set View Model Delegates and view
        self.viewModel = SignUpViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        actionButton.addItem(title: "", image: UIImage(named: "upload")) { item in
//
//                     self.btnSave.isHidden = false
//                     self.btnAddImage.isHidden = false
//                     self.btnSave.setTitle("Update", for: .normal)
//                     self.txtFirstName.isUserInteractionEnabled = true
//                     self.txtLastName.isUserInteractionEnabled = true
//                     self.txtPhoneNo.isUserInteractionEnabled = true
//                     self.btnAddImage.isUserInteractionEnabled = true
//                     self.viewGender.isUserInteractionEnabled = true
//                     self.btnDOB.isUserInteractionEnabled = true
//                     self.txtfieldStatus.isEditable = true
            self.updateData()
            
            
            
              }
        
           actionButton.buttonColor  = UIColor.init(red: 48/255, green: 181/255, blue: 85/255, alpha: 1)
           actionButton.display(inViewController: self)
             DispatchQueue.main.async {
            
            self.txtLastName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kLastName)
            self.txtFirstName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kFirstName)
            self.txtFirstName.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            self.txtLastName.txtfieldPadding(leftpadding: 10, rightPadding: 0)
              //self.txtfieldStatus.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            self.txtMail.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kEmail)
            self.txtPhoneNo.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPhoneNumber)
            self.txtMail.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            self.txtPhoneNo.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            
            self.cornerButton(btn: self.btnAddImage,radius: 18)
            self.cornerImage(image: self.imgViewProfile)
            
            
        }
    }
    
    func AutoTextDataTextField(data: GetUserDetailByPhoneEmail)
    {
        let userDetail = data
        userIdOther = userDetail.resultData?.userId ?? 0
        if userDetail.resultData?.userId !=  UserDefaultExtensionModel.shared.currentUserId {
            role = "other"
//            btnedit.isHidden = true
//            btnedit.frame = CGRect(x: self.btnedit.frame.origin.x, y: btnedit.frame.origin.y, width: 0, height: 0)
            //  btnAdd.frame = CGRect(x: btnAdd.frame.origin.x + 30 , y: btnAdd.frame.origin.y, width: btnAdd.frame.size.width + 50, height: btnAdd.frame.size.height)
            txtPhoneNo.isSecureTextEntry = true
            lblFN.text = "First Name"
            lblLN.text = "Last Name"
            lblEmail.text = "Email"
            lblPh.text = "Phone Number"
            lblGen.text = "Gender"
            lblDOB.text = "DOB"
            txtMail.backgroundColor = UIColor.clear
            btnAddImage.isHidden = true
            actionButton.isHidden = true

        }
        else{
            
          //  btnedit.isHidden = false
            btnAddImage.isHidden = false
            btnSave.isHidden = false
            btnSave.setTitle("Update", for: .normal)
            role = ""
            actionButton.isHidden = true
        }
        
        //        Show Pic Of User
        if let imgProfileUrl = userDetail.resultData?.imageUrl
        {
            
            imgViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgViewProfile.contentMode = .scaleAspectFill
            let url = imgProfileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""

            imgViewProfile.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else
        {
            selectedImageURl = URL(string: "")
            imgViewProfile.image = UIImage.init(named: kImages.kProfileImage)
        }
 
        
        if let email = userDetail.resultData?.email{
            txtMail.text = email
        }
        if let firstName = userDetail.resultData?.firstName{
            txtFirstName.text = firstName
        }
        
        if let lastName = userDetail.resultData?.lastName{
            txtLastName.text = lastName
        }
        
        if let phoneNo = userDetail.resultData?.phoneNo{
            txtPhoneNo.text = phoneNo
        }
        
        if let bio = userDetail.resultData?.Bio{
                   txtfieldStatus.text = bio
              self.txtfieldStatus.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5);
               }
        else {
             if userDetail.resultData?.userId !=  UserDefaultExtensionModel.shared.currentUserId {
                txtfieldStatus.text = "No Status Available"
            }
        }
        
        if let dob = userDetail.resultData?.DOB{
            selectedDOB = dob
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let dateFinal =  dateFormatter.date(from: dob) {
                let dd = formatter.string(from: dateFinal)
                txtFieldDOB.text = dd
            }                 }
        if let parmGender = userDetail.resultData?.gender{
            gender = parmGender
            
            if(gender == "M") {
                btnmale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            }
            else if (gender == "F"){
                btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            }
            else{
                btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            }
            
        }
        
    }
    
    
    
    
}
extension SignUpViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if role == "" && viewprofile == "true" {
//            actionButton.isHidden = false }
        if textField == txtFirstName || textField == txtLastName {
            if string == " " {
                return false
            }
        }
        return true
    }
   
}

extension SignUpViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
//           if role == "" && viewprofile == "true" {
//        actionButton.isHidden = false }
        
        if textView.text == "" {
            self.txtfieldStatus.contentInset = UIEdgeInsets(top: 8, left: 5, bottom: 5, right: 5);}
        else{
          self.txtfieldStatus.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5);}
       
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
          let numberOfChars = newText.count
          return numberOfChars < 121
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}



//MARK:- SignUp Delegates
extension SignUpViewController:SignUpDelegate{
    func GetUserDetailSuccess(data: GetUserDetailByPhoneEmail) {
        AutoTextDataTextField(data: data)
        
    }
    
    func DidFailedRoleMenu() {
        
    }
    
    
    
    func signUpSuccess(message: String) {
        if message == "User registered successfully"  {
            DOBselected = true
        }
        else if message == "User profile updated successfully" {
            updatedUser = "Updated"
        }
        
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = message
    }
    
    
    func getDataFalied(message: String){
        self.showAlert(Message: message)
    }
}


//MARK:- UIImagePickerView Delegate
extension SignUpViewController:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
        selectedImageURl = url
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        self.imgViewProfile.contentMode = .scaleAspectFill
        self.imgViewProfile.image = image
//        if role == "" && viewprofile == "true" {
//             actionButton.isHidden = false }
        CommonFunctions.sharedmanagerCommon.println(object: "Byte Array count:- \(byteArrayofImages)")
    }
}

//MARK:- Custom Gallery Alert
extension SignUpViewController : GalleryAlertCustomViewDelegate{
    func galleryBtnAction() {
        self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
        CommonFunctions.sharedmanagerCommon.println(object: "Gallery")
        galleryAlertView.removeFromSuperview()
    }
    func cameraButtonAction() {
        self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
        CommonFunctions.sharedmanagerCommon.println(object: "Camera")
        galleryAlertView.removeFromSuperview()
    }
    func cancelButtonAction() {
        galleryAlertView.removeFromSuperview()
    }
}
///MARK:- View Delegate
extension SignUpViewController : ViewDelegate{
    func showAlert(alert: String){
        //        self.showAlert(Message: alert)
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
        
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}
extension SignUpViewController : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        
        
        if DOBselected == true {
            DOBselected = false
            let storyboard = UIStoryboard.init(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewsLetterAndFeedVC") as? NewsLetterAndFeedVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = UINavigationController(rootViewController: vc!)
            appDelegate.window?.rootViewController = nav
        }
        else if updatedUser != "" {
            updatedUser = ""
//            if role == "" && viewprofile == "true" {
//               actionButton.isHidden = true }
//            btnedit.isUserInteractionEnabled = false
//            self.btnedit.setImageColor(color: UIColor.black)
//            btnSave.isHidden = true
//            txtFirstName.isUserInteractionEnabled = false
//            txtLastName.isUserInteractionEnabled = false
//            txtPhoneNo.isUserInteractionEnabled = false
//            btnAddImage.isUserInteractionEnabled = false
//            viewGender.isUserInteractionEnabled = false
//            btnDOB.isUserInteractionEnabled = false
//            btnAddImage.isHidden = true
            
        }
        
    }
}

extension SignUpViewController : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            
          //  CommonFunctions.sharedmanagerCommon.setRootLogin()
             self.viewModel?.logout(userId:  UserDefaultExtensionModel.shared.currentUserId, deviceType:3)
        }
            
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
//MARK:- UIDatePickerDelegates
extension SignUpViewController : SharedUIDatePickerDelegate{
    func doneButtonClicked(datePicker: UIDatePicker) {
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        CommonFunctions.sharedmanagerCommon.println(object: "String Converted Date:- \(strDate)")
        selectedDOB = strDate
        
        let years = CommonFunctions.sharedmanagerCommon.getYearsBetweenDates(startDate: datePicker.date, endDate: Date())
        if let intYear = years{
            if intYear < 18{
                self.showAlert(alert: Alerts.kUnderAge)
                //DOBselected = true
                return
            }else{
//                if role == "" && viewprofile == "true" {
//                   actionButton.isHidden = false }
                txtFieldDOB.text = strDate
                ageYears = intYear
            }
        }
    }
}
extension UIButton {
    func setImageColor(color: UIColor) {
        let templateImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.imageView?.image = templateImage
        self.tintColor = color
    }
}
func serverToLocal(date:String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let localDate = dateFormatter.date(from: date)
    
    return localDate
}
