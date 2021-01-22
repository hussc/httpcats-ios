import UIKit

protocol ReusableCell: Identifiable {
    
}

protocol ReusableView: Identifiable {
    
}

extension UITableViewCell: ReusableCell {
    
}

extension UICollectionViewCell: ReusableCell {
    
}

extension UICollectionReusableView: ReusableView {
    
}

extension UITableView {
    func register(cellClass: ReusableCell.Type){
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func register(cellNib: ReusableCell.Type){
        register(UINib(nibName: cellNib.identifier, bundle: nil), forCellReuseIdentifier: cellNib.identifier)
    }
    
    
    func dequeueCell<T: ReusableCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}


extension UICollectionView {
    func register(cellClass: ReusableCell.Type){
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func register(cellNib: ReusableCell.Type){
        register(UINib(nibName: cellNib.identifier, bundle: nil), forCellWithReuseIdentifier: cellNib.identifier)
    }
    
    func register(reusableViewClass: ReusableView.Type, for kind: String){
        register(reusableViewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableViewClass.identifier)
    }
    
    func register(reusableViewNib: ReusableView.Type, for kind: String){
        register(UINib(nibName: reusableViewNib.identifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableViewNib.identifier)
    }
    
    func dequeueCell<T: ReusableCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func dequeReusableView<T: ReusableView>(reusableViewType: T.Type, kind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableViewType.identifier, for: indexPath) as! T
    }
}

protocol EmptyInstantiatable {
    static func instantiate() -> Self
}
