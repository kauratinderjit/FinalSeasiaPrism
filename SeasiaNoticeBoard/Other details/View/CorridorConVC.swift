//
//  CorridorConVC.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//
var str_Role = ""
var userIdOther = 0
 
import UIKit
var dataArr = NSMutableArray()
var showDataArr : [QuestionListData]?

class CorridorConVC: BaseUIViewController {
    var viewModel:QuestionAnswerViewModel?
    
    var dict = [String:Any]()

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblViewCorr: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Corridor Conversations"
        setBackButton()
        tblViewCorr?.rowHeight = UITableView.automaticDimension
        tblViewCorr?.estimatedRowHeight = 100
       tblViewCorr?.tableFooterView = UIView()
       self.viewModel = QuestionAnswerViewModel.init(delegate: self)
       self.viewModel?.attachView(view: self)
        self.viewModel?.getQuestionList(userId: userIdOther)
        tblViewCorr?.separatorColor = UIColor.clear

        if str_Role == "other" {
                   btnSubmit.isHidden = true
               }
              else{
             btnSubmit.isHidden = false
                    }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dataArr.removeAllObjects()
        showDataArr?.removeAll()
        
    }
    

    @IBAction func submitaction(_ sender: UIButton) {
        
        if checkInternetConnection() {
               initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                     self.yesNoAlertView.delegate = self
                     yesNoAlertView.lblResponseDetailMessage.text = "Would you like to share this update on the wall?"
           }
              else{
               self.showAlert(Message: Alerts.kNoInternetConnection)
           }
    }
    
    
    

}
extension CorridorConVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showDataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CorridorCellTableViewCell
        cell.txtView.tag = indexPath.row
        cell.lblQues.text = "Q:\(indexPath.row + 1) " + " " +  (showDataArr?[indexPath.row].Question ?? "")
        
        dict["QuestionId"] =  showDataArr?[indexPath.row].QuestionId

        if showDataArr?[indexPath.row].Answer != nil && showDataArr?[indexPath.row].Answer != "" {
                cell.lblPlaceholder.isHidden = true
               cell.txtView.text = showDataArr?[indexPath.row].Answer
            dict["Answer"] = showDataArr?[indexPath.row].Answer

        }
           else{
               cell.lblPlaceholder.isHidden = false
            dict["Answer"] = ""

           }
        
        
        
        
        dataArr.add(dict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
              
    }
 
    
    ///MARK:- View Delegate
    extension CorridorConVC : ViewDelegate{
        func showAlert(alert: String){
        self.showAlert(Message: alert)
    //        initializeCustomOkAlert(self.view, isHideBlurView: true)
    //        okAlertView.delegate = self
    //        okAlertView.lblResponseDetailMessage.text = alert

        }
        func showLoader() {
            ShowLoader()
        }
        func hideLoader() {
            HideLoader()
        }
    }


extension CorridorConVC : QuestionAnswerDelegate {
   
    func GetSearchResult(data: GetSearchResultModel) {
        
    }
        
        func QuestionAnswerSuccess(message: String) {
            
        }
        
        func GetQuestionAnswerSuccess(data: GetQuestionsModel) {
            showDataArr = data.resultData
            tblViewCorr?.reloadData()
        }
        
        func GetMultipleQuestionSuccess(data: QuestionsChoiceModel) {
          
        }
        
        func DidFailed() {
            
        }
    }


extension CorridorCellTableViewCell : UITextViewDelegate {
    
    func  textViewDidBeginEditing(_ textView: UITextView) {
             lblPlaceholder.isHidden = true

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         let str = textView.text.trimmingCharacters(in: .whitespaces)
        
                 if str == ""
                 {
                     textView.text = ""
                     lblPlaceholder.isHidden = false
                 }
                 else{
                     txtView.text = textView.text
                 }
        if dataArr.count > 0 {
        
        for (index,value) in (dataArr.enumerated()) {
            let dict = value as? [String:Any]
            if dict?["QuestionId"] as? Int == showDataArr?[textView.tag].QuestionId {
                       dataArr.remove(value)
                   }
                   
               }
               
          var dict = [String:Any]()
               dict["QuestionId"] =  showDataArr?[textView.tag].QuestionId
               dict["Answer"] =  txtView.text
               dataArr.add(dict)
        
        }
              
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

         if text == "\n"
         {
             textView.resignFirstResponder()
         }
          let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
                  let numberOfChars = newText.count
                  return numberOfChars < 200

     }
     

}

extension CorridorConVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            
          self.viewModel?.saveQuestionAnswer(userId: userIdOther, arrQues: dataArr,TypeId: 1)
        }
            
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
              self.viewModel?.saveQuestionAnswer(userId: userIdOther, arrQues: dataArr,TypeId: 0)

              }
                  
              else{
                  self.showAlert(Message: Alerts.kNoInternetConnection)
              }
    }
}
