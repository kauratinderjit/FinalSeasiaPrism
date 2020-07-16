//
//  ThisThatVC.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit
import WMSegmentControl

class ThisThatVC: BaseUIViewController {
    
    @IBOutlet weak var tblViewThisThat: UITableView!
    var viewModel:QuestionAnswerViewModel?
    var showDataArr : [QuestionChoiceListData]?
    var datasendArr = NSMutableArray()
    var dict = [String:Any]()
    @IBOutlet weak var btnSubmit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        self.title = "Corridor Conversations"
        setBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          if str_Role == "other" {
                  btnSubmit.isHidden = true
              }
              else{
                  btnSubmit.isHidden = false
              }
    }
    
    func setView() {
               tblViewThisThat.reloadData()
               tblViewThisThat.tableFooterView = UIView()
               self.viewModel = QuestionAnswerViewModel.init(delegate: self)
               self.viewModel?.attachView(view: self)
              self.viewModel?.getMutipleQuestionList(userId: userIdOther)
    }
    

    @IBAction func actionSubmit(_ sender: UIButton) {
        
//           if checkInternetConnection() {
//            self.viewModel?.saveMultipleQuestionAnswer(userId: userIdOther, arrQues: datasendArr)
//
//        }
//           else{
//            self.showAlert(Message: Alerts.kNoInternetConnection)
        // }
        if checkInternetConnection() {
                    initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                          self.yesNoAlertView.delegate = self
                          yesNoAlertView.lblResponseDetailMessage.text = "Would you like to share this update on the wall?"
                }
                   else{
                    self.showAlert(Message: Alerts.kNoInternetConnection)
                }
        
    }
    
    
    @IBAction func valueChanged(_ sender: WMSegment) {
        //titleForSegment(at: sender.selectedSegmentIndex)
        
        if datasendArr.count > 0 {
        for (index,value) in datasendArr.enumerated() {
            let dict = value as? [String: Any]
            if dict?["ChoiceQuestionId"] as? Int == showDataArr?[sender.tag].ChoiceQuestionId {
                datasendArr.removeObject(at: index)
            }
        }
        
       
        dict["ChoiceQuestionId"] =  showDataArr?[sender.tag].ChoiceQuestionId
        let index = sender.selectedSegmentIndex
        let vv = sender.buttonTitles
        let pointsArr = vv.components(separatedBy: ",")
        let title = pointsArr[index]
        
        dict["Option"] = title
        datasendArr.add(dict)
        print(datasendArr)
            
            
            if  dict["Option"] as? String == "" {
                            sender.selectorColor = UIColor.clear
                                   sender.selectorTextColor = .white
                            sender.SelectedFont = UIFont.systemFont(ofSize: 15)

                       }
                       else{
                           sender.selectorColor =  UIColor.init(red: 24/255, green: 174/255, blue: 122/255, alpha: 1)
                            sender.selectorTextColor = .white
                           sender.SelectedFont = UIFont.boldSystemFont(ofSize: 15)

                       }
        }
        
    }
    

}

extension ThisThatVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showDataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThisThatCell
        cell.customSegment.tag = indexPath.row
        let opt1 = showDataArr?[indexPath.row].Option1
        let opt2 = showDataArr?[indexPath.row].Option2
        if opt1 != "" && opt1 != nil {
            cell.customSegment.buttonTitles = "\(String(describing: opt1!)),\(String(describing: opt2!))"
              let vv = cell.customSegment.buttonTitles
              let pointsArr = vv.components(separatedBy: ",")
            for (index,value) in pointsArr.enumerated() {
                if value == showDataArr?[indexPath.row].Selected {
                    cell.customSegment.selectedSegmentIndex = index
                }
            }
           dict["ChoiceQuestionId"] =  showDataArr?[indexPath.row].ChoiceQuestionId
           dict["Option"] = showDataArr?[indexPath.row].Selected
           datasendArr.add(dict)
            
            if  dict["Option"] as? String == "" {
                 cell.customSegment.selectorColor = UIColor.clear
                                    //set font for selcted segment value
                        cell.customSegment.selectorTextColor = .white
                 cell.customSegment.SelectedFont = UIFont.systemFont(ofSize: 15)

            }
            else{
                 cell.customSegment.selectorColor =  UIColor.init(red: 24/255, green: 174/255, blue: 122/255, alpha: 1)
                      //set font for selcted segment value
                cell.customSegment.selectorTextColor = .white
                cell.customSegment.SelectedFont = UIFont.boldSystemFont(ofSize: 15)

            }
            
        }
        
        return cell
              
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 73
    }
    
}
///MARK:- View Delegate
extension ThisThatVC : ViewDelegate{
    func showAlert(alert: String){
        self.showAlert(Message: alert)

    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}


extension ThisThatVC : QuestionAnswerDelegate {
    
    func GetSearchResult(data: GetSearchResultModel) {
        
    }
    
    func QuestionAnswerSuccess(message: String) {
        
    }
    
    func GetQuestionAnswerSuccess(data: GetQuestionsModel) {
        
       
        
    }
    
    func GetMultipleQuestionSuccess(data: QuestionsChoiceModel) {
        showDataArr = data.resultData
               tblViewThisThat.reloadData()
    }
    
    func DidFailed() {
        
    }
}
extension ThisThatVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
   
}

extension ThisThatVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            
         self.viewModel?.saveMultipleQuestionAnswer(userId: userIdOther, arrQues: datasendArr, TypeId: 2)
        }
            
        else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
             self.viewModel?.saveMultipleQuestionAnswer(userId: userIdOther, arrQues: datasendArr, TypeId: 0)

              }
                  
              else{
                  self.showAlert(Message: Alerts.kNoInternetConnection)
              }
    }
}
