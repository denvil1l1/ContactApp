import UIKit

protocol SexPickerCollectionDelegate: AnyObject {
    func saveSex(sexNumber: String)
}

class SexPickerCollectionViewCell: UICollectionViewCell, UIPickerViewDataSource {
    
    weak var delegate: SexPickerCollectionDelegate?
    
    private lazy var pickerSex: UIPickerView = {
        let pickerSex = UIPickerView()
        pickerSex.dataSource = self
        pickerSex.delegate = self
        return pickerSex
    }()
    
    private lazy var textFieldForPickerView: UITextField = {
        var textFieldForPickerView = UITextField()
        textFieldForPickerView.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldForPickerView.backgroundColor = UIColor.systemGray6
        textFieldForPickerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldForPickerView.inputView = pickerSex
        return textFieldForPickerView
       
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        layoutTextFieldPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutTextFieldPickerView() {
        contentView.addSubview(textFieldForPickerView)
        NSLayoutConstraint.activate([
            textFieldForPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldForPickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: textFieldForPickerView.trailingAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        textFieldForPickerView.placeholder = viewModel.placeholder
        textFieldForPickerView.text = viewModel.text
    }
}

extension SexPickerCollectionViewCell {
    
    struct ViewModel {
        let text: String
        let placeholder: String
    }
}

extension SexPickerCollectionViewCell {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

extension SexPickerCollectionViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = VariantsSex.allCases[row].displayRowValue
        delegate?.saveSex(sexNumber: result)
        textFieldForPickerView.text = result
        return "\(result)"
    }
}
