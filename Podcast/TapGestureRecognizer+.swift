//
//  TapGestureRecognizer+.swift
//  Podcast
//
//  Created by Mindy Lou on 10/30/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    
    /// Note: This was taken from Stack Overflow
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        guard let attributedText = label.attributedText else { return false }
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)

        let lineModifier = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostFirstLinePoint = CGPoint(x: labelSize.width, y: 0)
        let charsPerLine = layoutManager.characterIndex(for: rightMostFirstLinePoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let adjustedRange = indexOfCharacter + (lineModifier * charsPerLine)

        return NSLocationInRange(adjustedRange, targetRange)
    }
}
