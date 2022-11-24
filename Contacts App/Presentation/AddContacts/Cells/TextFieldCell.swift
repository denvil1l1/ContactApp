import Foundation
import UIKit

protocol TextFieldCellDelegate: AnyObject {
    
    func onTextEdit(text: String, cell: UICollectionViewCell)
}

class TextFieldCell: UICollectionViewCell {
    
    private enum Constants {
        static let topLeadingTrailing: CGFloat = 20
    }
    
    weak var delegate: TextFieldCellDelegate?
    
    private lazy var textField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textDidBegin), for: .editingDidBegin)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutTextField()
    }
    
    @objc
    func textDidBegin () {
        textField.textColor = UIColor.black
    }
    
    @objc
    func textDidChange() {
        delegate?.onTextEdit(text: textField.text ?? "", cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutTextField() {
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.topLeadingTrailing),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topLeadingTrailing),
            contentView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: Constants.topLeadingTrailing),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        textField.placeholder = viewModel.placeHolder
        textField.text = viewModel.text
        if let errorColor = viewModel.errorColor {
            textField.textColor = errorColor
        } else {
            textField.textColor = UIColor.black
        }
    }
}

extension TextFieldCell {
    
    struct ViewModel {
        var text: String
        let placeHolder: String
        var errorColor: UIColor?
    }
    
}
