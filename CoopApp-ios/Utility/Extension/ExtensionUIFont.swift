//
//  ExtensionUIFont.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/20/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    /*
     * Created by: cuongkt
     * Description: Get font with new symbolic traits
     */
    func withTraits(_ traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }

    /*
     * Created by: cuongkt
     * Description: Font with bold
     */
    func bold() -> UIFont {
        return withTraits(UIFontDescriptorSymbolicTraits.traitBold)
    }

    /*
     * Created by: cuongkt
     * Description: Font with italic
     */
    func italic() -> UIFont {
        return withTraits(UIFontDescriptorSymbolicTraits.traitItalic)
    }

    /*
     * Created by: cuongkt
     * Description: Font with bold and italic
     */
    func boldItalic() -> UIFont {
        return withTraits(UIFontDescriptorSymbolicTraits.traitBold, UIFontDescriptorSymbolicTraits.traitItalic)
    }
}
