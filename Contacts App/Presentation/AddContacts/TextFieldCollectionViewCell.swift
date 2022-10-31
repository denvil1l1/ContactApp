import Foundation
import UIKit
 
class TextFieldCollectionViewCell : UICollectionViewCell {
    
    //var label: UILabel?
    private lazy var allTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.text = nil
        textField.backgroundColor = UIColor.systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutTextField()
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutTextField() {
        contentView.addSubview(allTextField)
        NSLayoutConstraint.activate([
            allTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            allTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: allTextField.trailingAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
    
        allTextField.placeholder = viewModel.placeHolder
        allTextField.text = viewModel.text
    }
}
//let test = model.viewModel as? TextCellViewModel
//nameTextField.placeholder = test?.placeholder
//surnameTextField.placeholder = test?.placeholder
extension TextFieldCollectionViewCell {
    struct ViewModel {
        let text: String
        let placeHolder: String
        //        var rowValue: String?
        //        var keyboardType: UIKeyboardType = .default
        //        var font: UIFont? = Font.robotoMedium.uiFont(size: 13)
    }
}
