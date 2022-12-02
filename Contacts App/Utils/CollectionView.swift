//
//  CollectionView.swift
//  Contacts App
//
//  Created by vladislav on 30.11.2022.
//
import UIKit

extension UICollectionView {
    
    func registerAnyCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: String(describing: cellClass))
      }
  
    func dequeueReusableCell<CellClass: UICollectionViewCell>(of type: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as? CellClass else {
          fatalError("could not cast UICollectionViewCell at indexPath (section: \(indexPath.section), row: \(indexPath.row)) to expected type \(String(describing: CellClass.self))")
        }
        return cell
      }
    
}
