//
//  MessageChatInputBar.swift
//  V2POC_Chatto
//
//  Created by apoorva on 27/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

public protocol ChatInputBarDelegate: class {
    func inputBarShouldBeginTextEditing(_ inputBar: MessageChatInputBar) -> Bool
    func inputBarDidBeginEditing(_ inputBar: MessageChatInputBar)
    func inputBarDidEndEditing(_ inputBar: MessageChatInputBar)
    func inputBarDidChangeText(_ inputBar: MessageChatInputBar)
    func inputBarSendButtonPressed(_ inputBar: MessageChatInputBar)
    func inputBar(_ inputBar: MessageChatInputBar, shouldFocusOnItem item: ChatInputItemProtocol) -> Bool
    func inputBar(_ inputBar: MessageChatInputBar, didReceiveFocusOnItem item: ChatInputItemProtocol)
}

class test: ChatInputBar {
    
}

open class MessageChatInputBar: ReusableXibView {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textView: ExpandableMessageTextView!
    
    public weak var delegate: ChatInputBarDelegate?
    weak var presenter: MessageChatInputBarPresenter?
    
    public var shouldEnableSendButton = { (inputBar: MessageChatInputBar) -> Bool in
        return !inputBar.textView.text.isEmpty
    }
    
    class open func loadNib() -> MessageChatInputBar {
        let view = Bundle(for: self).loadNibNamed(MessageChatInputBar.nib(), owner: nil, options: nil)!.first as! MessageChatInputBar
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect.zero
        return view
    }
    
    class func nib() -> String {
        return "MessageChatInputBar"
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
//        self.topBorderHeightConstraint.constant = 1 / UIScreen.main.scale
        self.textView.scrollsToTop = false
        self.textView.delegate = self
//        self.scrollView.scrollsToTop = false
        self.sendButton.isEnabled = false
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
    }
    
    open var showsTextView: Bool = true {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsLayout()
            self.updateIntrinsicContentSizeAnimated()
        }
    }
    
    open var showsSendButton: Bool = true {
        didSet {
            self.setNeedsUpdateConstraints()
            self.setNeedsLayout()
            self.updateIntrinsicContentSizeAnimated()
        }
    }
    
    public var maxCharactersCount: UInt? // nil -> unlimited
    
    private func updateIntrinsicContentSizeAnimated() {
        let options: UIViewAnimationOptions = [.beginFromCurrentState, .allowUserInteraction]
        UIView.animate(withDuration: 0.25, delay: 0, options: options, animations: { () -> Void in
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    open override func layoutSubviews() {
        self.updateConstraints() // Interface rotation or size class changes will reset constraints as defined in interface builder -> constraintsForVisibleTextView will be activated
        super.layoutSubviews()
    }
    
    var inputItems = [ChatInputItemProtocol]() {
        didSet {
//            let inputItemViews = self.inputItems.map { (item: ChatInputItemProtocol) -> ChatInputItemView in
//                let inputItemView = ChatInputItemView()
//                inputItemView.inputItem = item
//                inputItemView.delegate = self
//                return inputItemView
//            }
        }
    }
    
    open func becomeFirstResponderWithInputView(_ inputView: UIView?) {
        self.textView.inputView = inputView
        
        if self.textView.isFirstResponder {
            self.textView.reloadInputViews()
        } else {
            self.textView.becomeFirstResponder()
        }
    }
    
    public var inputText: String {
        get {
            return self.textView.text
        }
        set {
            self.textView.text = newValue
            self.updateSendButton()
        }
    }
    
    fileprivate func updateSendButton() {
        self.sendButton.isEnabled = self.shouldEnableSendButton(self)
    }
    
    @IBAction func sendButtonTapped(_ sender: AnyObject) {
        self.presenter?.onSendButtonPressed()
        self.delegate?.inputBarSendButtonPressed(self)
    }
    
    public func setTextViewPlaceholderAccessibilityIdentifer(_ accessibilityIdentifer: String) {
        self.textView.setTextPlaceholderAccessibilityIdentifier(accessibilityIdentifer)
    }
}

// MARK: - ChatInputItemViewDelegate
//extension MessageChatInputBar: ChatInputItemViewDelegate {
//    func inputItemViewTapped(_ view: ChatInputItemView) {
//        self.focusOnInputItem(view.inputItem)
//    }
//    
//    public func focusOnInputItem(_ inputItem: ChatInputItemProtocol) {
//        let shouldFocus = self.delegate?.inputBar(self, shouldFocusOnItem: inputItem) ?? true
//        guard shouldFocus else { return }
//        
//        self.presenter?.onDidReceiveFocusOnItem(inputItem)
//        self.delegate?.inputBar(self, didReceiveFocusOnItem: inputItem)
//    }
//}

// MARK: - ChatInputBarAppearance
extension MessageChatInputBar {
    public func setAppearance(_ appearance: MessageChatInputBarAppearance) {
        self.textView.font = appearance.textInputAppearance.font
        self.textView.textColor = appearance.textInputAppearance.textColor
        self.textView.tintColor = appearance.textInputAppearance.tintColor
//        self.textView.textContainerInset = appearance.textInputAppearance.textInsets
        self.textView.setTextPlaceholderFont(appearance.textInputAppearance.placeholderFont)
        self.textView.setTextPlaceholderColor(appearance.textInputAppearance.placeholderColor)
        self.textView.setTextPlaceholder(appearance.textInputAppearance.placeholderText)
        self.textView.layer.borderColor = appearance.textInputAppearance.borderColor.cgColor
        self.textView.layer.cornerRadius = 2.0
        self.textView.layer.borderWidth = appearance.textInputAppearance.borderWidth
//        self.sendButton.contentEdgeInsets = appearance.sendButtonAppearance.insets
        self.sendButton.titleLabel?.font = appearance.sendButtonAppearance.font
    }
}

// MARK: UITextViewDelegate
extension MessageChatInputBar: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.delegate?.inputBarShouldBeginTextEditing(self) ?? true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.presenter?.onDidEndEditing()
        self.delegate?.inputBarDidEndEditing(self)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.presenter?.onDidBeginEditing()
        self.delegate?.inputBarDidBeginEditing(self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.updateSendButton()
        self.delegate?.inputBarDidChangeText(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn nsRange: NSRange, replacementText text: String) -> Bool {
        let range = self.textView.text.bma_rangeFromNSRange(nsRange)
        if let maxCharactersCount = self.maxCharactersCount {
            let currentCount = textView.text.characters.count
            let rangeLength = textView.text.substring(with: range).characters.count
            let nextCount = currentCount - rangeLength + text.characters.count
            return UInt(nextCount) <= maxCharactersCount
        }
        return true
    }
}


private extension String {
    func bma_rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index> {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return  self.startIndex..<self.startIndex }
        return from ..< to
    }
}

