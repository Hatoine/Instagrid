//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by antoineantoniol on 08/03/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}

