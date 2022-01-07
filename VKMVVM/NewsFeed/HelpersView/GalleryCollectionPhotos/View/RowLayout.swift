//
//  RowLayout.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 05.01.2022.
//

import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {

    weak var delegate: RowLayoutDelegate!
    
    private static var numberOfRows = 1
    private var cellPadding: CGFloat = 8
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - insets.left - insets.right
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache = []
        contentWidth = 0
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        var photos = [CGSize]()
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            photos.append(photoSize)
        }
        let superviewWidth = collectionView.frame.width
        guard var rowHeight = RowLayout.rowHeightCouter(superviewWidth: superviewWidth, photosArray: photos) else { return }
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfRows)
        
        let photosRatio = photos.map { $0.height / $0.width }
        
        var yOffset = [CGFloat]()
        for row in 0 ..< RowLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        
        var row = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = photosRatio[item]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    static func rowHeightCouter(superviewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        let photoWidthMinRatio = photosArray.min { ($0.height/$0.width) < ($1.height/$1.width) }
        
        guard let myPhotoWidthMinRatio = photoWidthMinRatio else { return nil }
        let difference = superviewWidth / myPhotoWidthMinRatio.width
        
        rowHeight = myPhotoWidthMinRatio.height * difference
        
        rowHeight = rowHeight * CGFloat(RowLayout.numberOfRows)
        return rowHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttrubutes = [UICollectionViewLayoutAttributes]()
        
        for attrubute in cache {
            if attrubute.frame.intersects(rect) {
                visibleLayoutAttrubutes.append(attrubute)
            }
        }
        
        return visibleLayoutAttrubutes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}

