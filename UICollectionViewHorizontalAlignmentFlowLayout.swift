import Foundation
import UIKit

enum SZAlignment {
    case center
    case left
    case right
}

class UICollectionViewHorizontalAlignmentFlowLayout: UICollectionViewFlowLayout {
    var alignment:SZAlignment = .center
    var padding:CGFloat = 1

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let allAttributesInRect: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) else { return nil }

        switch alignment {
        case .center:
            return alignCenter(allAttributesInRect: allAttributesInRect)
        case .left:
            return alignLeft(allAttributesInRect: allAttributesInRect)
        case .right:
            return alignRight(allAttributesInRect: allAttributesInRect)
        }
    }

    private func alignCenter(allAttributesInRect: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        guard let numberOfSection = collectionView?.numberOfSections else { return [] }

        var redefinedArray = [UICollectionViewLayoutAttributes]()

        for i in 0 ..< numberOfSection {

            var thisSectionObjects = sectionObjects(allAttributesInRect: allAttributesInRect, section: i)
            let totalLines = numberOfLines(allAttributesInRect: thisSectionObjects, section: i)
            let lastrowObjects = lastRow(allAttributesInRect: thisSectionObjects, numberOfRows: totalLines, section: i)
            let lastRowObjectsRow = centerLastRow(lastRowAttrs: lastrowObjects)
            let start = thisSectionObjects.count - lastrowObjects.count

            for j in start..<thisSectionObjects.count{
                thisSectionObjects[j] = lastRowObjectsRow[j - start]
            }
            redefinedArray.append(contentsOf: thisSectionObjects)
        }

        return redefinedArray
    }

    private func alignLeft(allAttributesInRect: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        return allAttributesInRect;
    }

    private func alignRight(allAttributesInRect: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        return allAttributesInRect;
    }

    private func getTotalLenthOftheSection(section: Int, allAttributesInRect: [UICollectionViewLayoutAttributes]) -> CGFloat {
        var totalLength:CGFloat = 0.0
        totalLength = totalLength + (CGFloat (((self.collectionView!.numberOfItems(inSection: section)) - 1)) * padding)
        for  attributes in allAttributesInRect {

            if(attributes.indexPath.section == section){
                totalLength = totalLength + attributes.frame.width
            }
        }

        return totalLength
    }

    private func numberOfLines(allAttributesInRect: [UICollectionViewLayoutAttributes], section: Int) -> Int {
        var totalLines:Int = 0
        for  attributes in allAttributesInRect {
            if(attributes.indexPath.section == section){
                if (attributes.frame.origin.x == self.sectionInset.left){
                    totalLines = totalLines + 1
                }
            }
        }
        return totalLines
    }

    private func sectionObjects(allAttributesInRect: [UICollectionViewLayoutAttributes], section: Int) -> [UICollectionViewLayoutAttributes] {
        var objects = [UICollectionViewLayoutAttributes]()
        for  attributes in allAttributesInRect {
            if(attributes.indexPath.section == section){
                objects.append(attributes)
            }
        }
        return objects
    }

    private func lastRow(allAttributesInRect: [UICollectionViewLayoutAttributes], numberOfRows: Int, section: Int) -> [UICollectionViewLayoutAttributes] {
        var totalLines:Int = 0
        var lastRowArrays = [UICollectionViewLayoutAttributes]()
        for  attributes in allAttributesInRect {
            if(attributes.indexPath.section == section){
                if (attributes.frame.origin.x == self.sectionInset.left){
                    totalLines = totalLines + 1
                    if(totalLines == numberOfRows){
                        lastRowArrays.append(attributes)
                    }
                }
                else{
                    if(totalLines == numberOfRows){
                        lastRowArrays.append(attributes)
                    }
                }
            }
        }
        return lastRowArrays
    }

    private func centerLastRow(lastRowAttrs: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        var redefinedValues = [UICollectionViewLayoutAttributes]()
        let totalLengthOftheView = self.collectionView?.frame.width
        var totalLenthOftheCells:CGFloat = 0.0
        totalLenthOftheCells = totalLenthOftheCells + (CGFloat (lastRowAttrs.count) - 1) * padding

        for attrs in lastRowAttrs{
            totalLenthOftheCells = totalLenthOftheCells + attrs.frame.width
        }

        var initalValue = (totalLengthOftheView!/2) - (totalLenthOftheCells/2)

        for  i in 0..<lastRowAttrs.count {
            let changeingAttribute = lastRowAttrs[i]
            var frame = changeingAttribute.frame
            frame.origin.x = initalValue
            changeingAttribute.frame = frame
            redefinedValues.append(changeingAttribute)
            initalValue = initalValue + changeingAttribute.frame.width + padding
        }

        return redefinedValues
    }
}
