import Foundation
import UIKit

protocol InputCollectionCellDelegate: AnyObject {
    func onTextEdit(text: String, cell: UICollectionViewCell)
}

class TextFieldCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let topLeadingTrailing = CGFloat(20)
    }
    
    weak var delegate: InputCollectionCellDelegate?
    
    private lazy var allTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.text = nil
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
        allTextField.textColor = UIColor.black
    }
    
    @objc
    func textDidChangeNotification (_ notif: Notification) {
        guard self == notif.object as? UITextView else {
            textDidChange()
            return
        }
    }
    
    @objc
    func textDidChange() {
        delegate?.onTextEdit(text: allTextField.text ?? "", cell: self)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutTextField() {
        contentView.addSubview(allTextField)
        NSLayoutConstraint.activate([
            allTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.topLeadingTrailing),
            allTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topLeadingTrailing),
            contentView.trailingAnchor.constraint(equalTo: allTextField.trailingAnchor, constant: Constants.topLeadingTrailing),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        allTextField.placeholder = viewModel.placeHolder
        allTextField.text = viewModel.text
        if let errorColor = viewModel.errorColor {
             allTextField.textColor = errorColor
        } else {
            allTextField.textColor = UIColor.black
        }
    }
}

extension TextFieldCollectionViewCell {
    
    struct ViewModel {
        var text: String
        let placeHolder: String
        var errorColor: UIColor?
    }
}
