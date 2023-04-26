//
//  AddNoteViewController.swift
//  ExampleCoreDataNotes
//
//  Created by Mohan K on 17/03/23.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var ViewBgnote: UIView!
    @IBOutlet weak var Labelnote: UILabel!
    @IBOutlet weak var TextViewnote: UITextView!
    @IBOutlet weak var labelPriority: UILabel!
    @IBOutlet weak var PriorityViewlow: UIView!
    @IBOutlet weak var PriorityViewmedium: UIView!
    @IBOutlet weak var PriorityViewhigh: UIView!
    @IBOutlet weak var  updateBtn: UIButton!
    private var KeyBoardShown: Bool = false
    private var noteViewAlreadyAnimated : Bool = false
    private var ViewBgnoteOriginY: CGFloat = 0
    private var ViewBgnoteOriginYWithKeyboard : CGFloat = 0
    private var allowTapBgToClose: Bool? = true
    class var identifier: String { return String (describing: self) }

    var saveNote: ((_ noteText: String, _ priorityColor: UIColor) -> Void)?
        private var savedNote: String?
        private var selectedPriority: UIColor?
        
    func setNote(text: String = "", priorityColor: UIColor = .clear) {
        savedNote = text
        selectedPriority = priorityColor
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func initView() {
        // View
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Tap Gesture for closing the pop up when you tap outside
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBaseTapOnly))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        // Open & Close Keyboard Notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        self.ViewBgnote.backgroundColor = .gray
        self.ViewBgnote.layer.cornerRadius = 12
        self.ViewBgnote.clipsToBounds = true
        
        self.Labelnote.text = "Note"
        self.Labelnote.font = UIFont.systemFont(ofSize: 17,weight: .bold)
        self.Labelnote.textColor = .blue
        
        self.TextViewnote.text = savedNote
        self.TextViewnote.clipsToBounds = true
        self.TextViewnote.layer.borderColor = UIColor.white.cgColor
        self.TextViewnote.layer.borderWidth = 2.0
        self.TextViewnote.layer.cornerRadius = 12
        self.TextViewnote.autocorrectionType = .no
        self.TextViewnote.font = UIFont.systemFont(ofSize: 14)
        self.TextViewnote.tintColor = .blue
        self.TextViewnote.textColor = .blue
        self.TextViewnote.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 2, right: 1)
        self.labelPriority.text = "Priority"
        self.labelPriority.textColor = .blue
        self.labelPriority.font = UIFont.systemFont(ofSize: 17, weight: .bold)
      
        self.PriorityViewlow.backgroundColor = .green
        self.PriorityViewmedium.backgroundColor = .orange
        self.PriorityViewhigh.backgroundColor = .red
        
        let priorityViews = [PriorityViewhigh, PriorityViewmedium, PriorityViewlow]
        for i in 0 ..< priorityViews.count {
            guard let priorityView = priorityViews[i] else {return }
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(selectPriority(_:)))
            tapGes.numberOfTapsRequired = 1
            priorityView.tag = i
            priorityView.addGestureRecognizer(tapGes)
            priorityView.clipsToBounds = true
            priorityView.layer.cornerRadius = 15
            priorityView.layer.backgroundColor = UIColor.white.cgColor
        }
        
        setSelectedPriority()
        self.updateBtn.setTitleColor(.white, for: .normal)
        self.updateBtn.setTitle("Update", for: .normal)
        self.updateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.updateBtn.backgroundColor = .cyan
        self.updateBtn.layer.cornerRadius = 22.5
        self.updateBtn.addTarget(self, action: #selector(self.addNoteButtonTapped), for: .touchUpInside)
    }
    func setSelectedPriority() {
        guard let selectedPriority = selectedPriority else { return }
        switch selectedPriority {
        case .green:
            labelPriority.text = "Low priority"
            PriorityViewlow.layer.borderWidth = 2
        case .orange:
            labelPriority.text = "Medium priority"
            PriorityViewmedium.layer.borderWidth = 2
        case .red:
            labelPriority.text = "High priority"
            PriorityViewhigh.layer.borderWidth = 2
        default:
            break
        }
    }
    
    @objc func selectPriority(_ sender: UITapGestureRecognizer) {
        if sender.view!.tag == 0 { // Low priority
            selectedPriority = PriorityViewlow.backgroundColor
            labelPriority.text = "Low priority"
            PriorityViewlow.layer.borderWidth = 2
            PriorityViewmedium.layer.borderWidth = 0
            PriorityViewhigh.layer.borderWidth = 0
        } else if sender.view!.tag == 1 { // Medium priority
            selectedPriority = PriorityViewmedium.backgroundColor
            labelPriority.text = "Medium priority"
            PriorityViewlow.layer.borderWidth = 0
            PriorityViewmedium.layer.borderWidth = 2
            PriorityViewhigh.layer.borderWidth = 0
        } else if sender.view!.tag == 2 { // High priority
            selectedPriority =  PriorityViewhigh.backgroundColor
            labelPriority.text = "High priority"
            PriorityViewlow.layer.borderWidth = 0
            PriorityViewmedium.layer.borderWidth = 0
            PriorityViewhigh.layer.borderWidth = 2
        }
    }
    
    @objc func addNoteButtonTapped() {
        self.dismissKeyboard()
        // Check if the note is empty
        if !TextViewnote.text.trimmingCharacters(in: .whitespaces).isEmpty, selectedPriority != nil {
            // Save note and close the current view.
            self.dismiss(animated: true) {
                self.saveNote?(self.TextViewnote.text, self.selectedPriority!)
            }
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        // Avoid to fire keyboardWillShow when the user taps textview again and again.
        let userInfo = notification.userInfo!
        let beginFrameValue = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!
        let beginFrame = beginFrameValue.cgRectValue
        let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!
        let endFrame = endFrameValue.cgRectValue

        if beginFrame.equalTo(endFrame) {
            return
        }

        // Move the view is hidden behind the keyboard.
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.KeyBoardShown = true
            self.moveViewForKeyboard(frame: keyboardFrame)
        }
    }
    
    func moveViewForKeyboard(frame: NSValue) {
        let keyboardRectangle = frame.cgRectValue
        let distance = self.ViewBgnote.frame.maxY - keyboardRectangle.minY
        if distance >= -8 { // Move view only if the view is hidding behind keyboard or is very close.
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    let bottomSafeAreaPadding = self.view?.window?.safeAreaInsets.bottom
                    let bottomPadding: CGFloat = -45 + (bottomSafeAreaPadding ?? 0.0)
                    self.ViewBgnote.frame.origin.y -= distance - bottomPadding
                    self.ViewBgnoteOriginYWithKeyboard = self.ViewBgnote.frame.origin.y
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.KeyBoardShown = false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.ViewBgnote.frame.origin.y = self.ViewBgnoteOriginY
                self.view.layoutIfNeeded()
            })
        }
    }

    func closeAnim() {
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.ViewBgnote.frame = CGRect(x: self.view.frame.width / 2 - self.ViewBgnote.frame.width / 2, y: self.view.frame.height + self.ViewBgnote.frame.height, width: self.ViewBgnote.frame.width, height: self.ViewBgnote.frame.height)
            self.ViewBgnote.superview?.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.noteViewAlreadyAnimated {
            self.ViewBgnote.frame = CGRect(x: self.view.frame.width / 2 - self.ViewBgnote.frame.width / 2, y: self.view.frame.height + self.ViewBgnote.frame.height, width: self.ViewBgnote.frame.width, height: self.ViewBgnote.frame.height)
            self.ViewBgnote.superview?.layoutIfNeeded()

            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.ViewBgnote.frame = CGRect(x: self.view.frame.width / 2 - self.ViewBgnote.frame.width / 2, y: self.view.frame.height / 2 - self.ViewBgnote.frame.height / 2, width: self.ViewBgnote.frame.width, height: self.ViewBgnote.frame.height)
                self.ViewBgnote.superview?.layoutIfNeeded()
            })
            // Save the current origin y for later, when the keyboard is hidden to return the view back to the previous position.
            self.ViewBgnoteOriginY = self.ViewBgnote.frame.origin.y
            self.noteViewAlreadyAnimated = true
        }

        // Every time you press a priority color circle, the view goes to the center of the screen, no matter what. The following line keeps the view in the proper position every time(with the keyboard closed or open).
        self.ViewBgnote.frame.origin.y = self.KeyBoardShown ? self.ViewBgnoteOriginYWithKeyboard : self.ViewBgnoteOriginY
    }
}

extension AddNoteViewController: UIGestureRecognizerDelegate {
    @objc func onBaseTapOnly(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let allowTapToClose = allowTapBgToClose, allowTapToClose {
                if self.KeyBoardShown {
                    self.dismissKeyboard()
                } else {
                    DispatchQueue.main.async {
                        self.closeAnim()
                    }
                }
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.ViewBgnote))! {
            // If the keyboard appears, you can hide it even when you press the noteBgView.
            return self.KeyBoardShown
        }
        return true
    }
}
