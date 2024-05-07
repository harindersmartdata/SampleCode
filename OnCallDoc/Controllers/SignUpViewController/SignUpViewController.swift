import UIKit
import SkyFloatingLabelTextField
import DropDown

class SignUpViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    @IBOutlet weak var txtGender: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEthnicity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNPI: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPracticeAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSuiteAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZipCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCredential: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtTranscribeEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    
    // MARK: Variables
    let genderDropdown = DropDown()
    let credentiaDropdown = DropDown()
    let sateDropdown = DropDown()
    let ethnicityDropdown = DropDown()
    let transcribeDropdown = DropDown()
    let datePicker = UIDatePicker()
    
    lazy var viewModel: SignUpVM = {
        let obj = SignUpVM(userService: UserService())
        self.baseVwModel = obj
        obj.controller = self
        return obj
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup(){
        txtFieldSetup()
    }
    
    func txtFieldSetup(){
        txtGender.delegate = self
        txtCredential.delegate = self
        txtState.delegate = self
        txtEthnicity.delegate = self
        txtZipCode.maxLength = 6
        
        txtGender.rightView = getRightViewForTxtField()
        txtGender.rightViewMode = .always
        txtCredential.rightView = getRightViewForTxtField()
        txtCredential.rightViewMode = .always
        txtState.rightView = getRightViewForTxtField()
        txtState.rightViewMode = .always
        txtEthnicity.rightView = getRightViewForTxtField()
        txtEthnicity.rightViewMode = .always
        txtTranscribeEmail.rightView = getInfoIconTxtField()
        txtTranscribeEmail.rightViewMode = .always
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.genderDropdownBtnTapped(_:)))
        txtGender.rightView?.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.credentialDropdownBtnTapped(_:)))
        txtCredential.rightView?.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.stateDropdownBtnTapped(_:)))
        txtState.rightView?.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.ethnicityDropdownBtnTapped(_:)))
        txtEthnicity.rightView?.addGestureRecognizer(tap4)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.transcribeInfoBtnTapped(_:)))
        txtTranscribeEmail.rightView?.addGestureRecognizer(tap5)
        
        genderDropdown.anchorView = txtGender
        genderDropdown.width = txtGender.frame.width - 40
        genderDropdown.dataSource = ["Male", "Female", "Other"]
        genderDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtGender.text = item
        }
        
        credentiaDropdown.anchorView = txtCredential
        credentiaDropdown.width = txtCredential.frame.width - 40
        credentiaDropdown.dataSource = ["MD", "DO", "NP", "PA"]
        credentiaDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtCredential.text = item
        }
        
        
        sateDropdown.anchorView = txtCredential
        sateDropdown.width = txtCredential.frame.width - 40
        sateDropdown.dataSource = kstateList
        sateDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtState.text = item
        }
        
        
        ethnicityDropdown.anchorView = txtEthnicity
        ethnicityDropdown.width = txtEthnicity.frame.width - 40
        ethnicityDropdown.dataSource = kEthnicityList
        ethnicityDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtEthnicity.text = item
        }
        
        transcribeDropdown.anchorView = txtTranscribeEmail
        transcribeDropdown.width = 300
        transcribeDropdown.direction = .top
        transcribeDropdown.dataSource = ["Lorem Ipsum is simply dummy text."]
        txtDOB.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
    
    @objc func genderDropdownBtnTapped(_ sender: UITapGestureRecognizer? = nil) {
        genderDropdown.show()
    }
    @objc func credentialDropdownBtnTapped(_ sender: UITapGestureRecognizer? = nil) {
        credentiaDropdown.show()
    }
    @objc func stateDropdownBtnTapped(_ sender: UITapGestureRecognizer? = nil) {
        sateDropdown.show()
    }
    @objc func ethnicityDropdownBtnTapped(_ sender: UITapGestureRecognizer? = nil) {
        ethnicityDropdown.show()
    }
    @objc func transcribeInfoBtnTapped(_ sender: UITapGestureRecognizer? = nil) {
        transcribeDropdown.show()
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.txtDOB.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = DateTimeUtils.mm_dd_yyyy
            self.txtDOB.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDOB.resignFirstResponder()
    }
    
    func getRightViewForTxtField()-> UIView{
        let rightView = UIView()
        rightView.backgroundColor = UIColor.clear
        
        let checkmarkImageView = UIImageView(image: UIImage(named: Images.downArrow))
        checkmarkImageView.frame = checkmarkImageView.frame.offsetBy(dx: 0, dy: -1 + txtGender.titleHeight()/2)
        rightView.frame = checkmarkImageView.frame
        rightView.addSubview(checkmarkImageView)
        return rightView
    }
    
    func getInfoIconTxtField()-> UIView{
        let rightView = UIView()
        rightView.backgroundColor = UIColor.clear

        let checkmarkImageView = UIImageView(image: UIImage(named: "info"))
        checkmarkImageView.frame = checkmarkImageView.frame.offsetBy(dx: 0, dy: -1 + txtGender.titleHeight()/2)
        rightView.frame = checkmarkImageView.frame
        rightView.addSubview(checkmarkImageView)
        return rightView
    }
    
    // MARK: - Button Action
    @IBAction func buttonActionSignUp(_ sender: Any) {
        viewModel.signUp(firstName: txtFirstName.text, lastName: txtLastName.text, email: txtEmail.text, dob: txtDOB.text, phoneNumber: txtPhone.text, password: txtPassword.text, gender: txtGender.text?.lowercased(), ethnicity: txtEthnicity.text, npi: txtNPI.text, practiceAddress: txtPracticeAddress.text, credentail: txtCredential.text?.lowercased(), suiteAddress: txtSuiteAddress.text, state: txtState.text, zipCode: txtZipCode.text, transcribeEmail: txtTranscribeEmail.text  ) { (user) in
            self.baseVwModel?.isLoading = false
            
            let dataDict = CryptoJSHelper.shared.encryptedStringToDic(encryptedData: user.data ?? "")
            
            if let token = dataDict?[Keys.token] as? String{
                UserDefaults.standard.setValue(token, forKey: UserDefaultsKeys.token)
            }
            if let userdata = dataDict?["userdata"] as? NSDictionary{
                if let email = userdata[Keys.email] as? String,
                   let id = userdata["id"] as? String{
                    UserDefaults.standard.setValue(email, forKey: UserDefaultsKeys.userEmail)
                    UserDefaults.standard.setValue(id, forKey: UserDefaultsKeys.userID)
                    UserDefaults.standard.synchronize()
                }
                if let twilioNumber = userdata["twilioNumber"] as? String{
                    UserDefaults.standard.setValue(twilioNumber, forKey: UserDefaultsKeys.onCallNumber)
                }
            }
            self.viewModel.navigateToHome()
        }

    }
    
    @IBAction func buttonActionSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonActionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtGender{
            genderDropdown.show()
            return false
        }
        if textField == txtCredential{
            credentiaDropdown.show()
            return false
        }
        if textField == txtState{
            sateDropdown.show()
            return false
        }
        if textField == txtEthnicity{
            ethnicityDropdown.show()
            return false
        }
        
        return true
    }
    
}
