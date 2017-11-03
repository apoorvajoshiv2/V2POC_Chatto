//
//  FNSPhotoMessageViewModel.swift
//  V2POC_Chatto
//
//  Created by apoorva on 03/11/17.
//  Copyright © 2017 apoorva. All rights reserved.
//

import Foundation
import ChattoAdditions

class FNSPhotoMessageViewModel: PhotoMessageViewModel<FNSPhotoMessageModel>, FNSMessageViewModelProtocol {
    let photoImage: UIImage
    override init(photoMessage: FNSPhotoMessageModel, messageViewModel: MessageViewModelProtocol) {
        self.photoImage = photoMessage.image
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
        if photoMessage.isIncoming {
            self.image.value = nil
        }
    }
    
    public var messageModel: V2MessageModelProtocol {
        return self._photoMessage
    }
    
    override func willBeShown() {
        self.progress()
    }
    
    func progress() {
        if [TransferStatus.success, TransferStatus.failed].contains(self.transferStatus.value) {
            return
        }
        if self.transferProgress.value >= 1.0 {
            if arc4random_uniform(100) % 2 == 0 {
                self.transferStatus.value = .success
                self.image.value = self.photoImage
            } else {
                self.transferStatus.value = .failed
            }
            
            return
        }
        self.transferStatus.value = .transfering
        let delaySeconds: Double = Double(arc4random_uniform(600)) / 1000.0
        let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            guard let sSelf = self else { return }
            let deltaProgress = Double(arc4random_uniform(15)) / 100.0
            sSelf.transferProgress.value = min(sSelf.transferProgress.value + deltaProgress, 1)
            sSelf.progress()
        }
    }
    
}


class FNSPhotoMessageViewModelBuilder: ViewModelBuilderProtocol {
    
    let messageViewModelBuilder = MessageViewModelDefaultBuilder()
    
    func createViewModel(_ model: FNSPhotoMessageModel) -> FNSPhotoMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(model)
        let photoMessageViewModel = FNSPhotoMessageViewModel(photoMessage: model, messageViewModel: messageViewModel)
        photoMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        return photoMessageViewModel
    }
    
    func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is FNSPhotoMessageModel
    }
    
}
