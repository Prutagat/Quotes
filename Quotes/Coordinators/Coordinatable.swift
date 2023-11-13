//
//  Coordinatable.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func presentAlert(title: String, message: String)
    func presentImagePicker(imagePickerController: UIImagePickerController)
}

extension Coordinatable {
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "ОК", style: .default)
        alertController.addAction(okBtn)
        navigationController.present(alertController, animated: true)
    }
    func presentImagePicker(imagePickerController: UIImagePickerController) {
        navigationController.present(imagePickerController, animated: true)
    }
}
