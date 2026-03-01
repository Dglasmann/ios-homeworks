import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - Subviews

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Hipster Cat"
        lbl.numberOfLines = 1
        return lbl
    }()

    // Увеличили шрифт statusLabel по макету
    private let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 34, weight: .regular) // <- увеличено
        lbl.textColor = .gray
        lbl.text = "Waiting for something..."
        lbl.numberOfLines = 1
        return lbl
    }()

    private let statusTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Enter status..."
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .default
        tf.returnKeyType = .done
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let setStatusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitle("Show status", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 14
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowRadius = 6
        btn.layer.shadowOpacity = 0.35
        return btn
    }()

    // MARK: - State & constants

    private var statusText: String = ""
    private var isEditingStatus: Bool = false

    private let avatarSize: CGFloat = 120
    private let nameTopOffset: CGFloat = 27            // name Y = safeTop + 27
    private let avatarTopOffset: CGFloat = 16          // avatar Y = safeTop + 16
    private let avatarToButtonGap: CGFloat = 16        // button.top = avatar.bottom + 16 (base)
    private let statusToButtonGap: CGFloat = 34        // statusLabel.bottom = button.top - 34
    private let tfHeight: CGFloat = 40
    private let tfSpacing: CGFloat = 8                 // spacing around textfield

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)

        // initial state
        statusTextField.isHidden = true

        // targets
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        statusTextField.addTarget(self, action: #selector(textFieldDidEndOnExit(_:)), for: .editingDidEndOnExit)
    }

    // MARK: - Actions

    @objc private func buttonPressed() {
        if !isEditingStatus {
            // показать textField и плавно сдвинуть кнопку вниз
            isEditingStatus = true
            statusTextField.isHidden = false
            setStatusButton.setTitle("Set status", for: .normal)

            // фокус и анимация layout
            statusTextField.becomeFirstResponder()
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
            return
        }

        // второй клик — применяем статус (если не пустой)
        let trimmed = statusText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            print("Status пустой")
            return
        }

        statusLabel.text = trimmed
        print("Status set: \(trimmed)")
        statusTextField.resignFirstResponder()
    }

    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }

    @objc private func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let fullW = bounds.width
        let safeTop: CGFloat = superview?.safeAreaInsets.top ?? 0

        // Avatar
        let avatarX: CGFloat = 16
        let avatarY: CGFloat = safeTop + avatarTopOffset
        avatarImageView.frame = CGRect(x: avatarX, y: avatarY, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarSize / 2

        // Right column start X and width (выровнено по правой стороне аватара)
        let rightX = avatarImageView.frame.maxX + 16
        let rightWidth = fullW - rightX - 16

        // Name label: fixed from safeTop
        let nameHeight = nameLabel.sizeThatFits(CGSize(width: rightWidth, height: CGFloat.greatestFiniteMagnitude)).height
        nameLabel.frame = CGRect(x: rightX, y: safeTop + nameTopOffset, width: rightWidth, height: nameHeight)

        // Base button Y (от аватара)
        let avatarBottom = avatarImageView.frame.maxY
        var baseButtonY = avatarBottom + avatarToButtonGap

        // Расчёт высоты statusLabel по содержимому и ширине
        let statusHeight = statusLabel.sizeThatFits(CGSize(width: rightWidth, height: CGFloat.greatestFiniteMagnitude)).height

        // Нам нужно: statusLabel.bottom == button.top - statusToButtonGap
        // => желаемая button.top = statusLabel.bottom + statusToButtonGap
        // статус мы хотим расположить как можно ниже, поэтому используем именно это правило:
        // сначала вычислим желаемую button.top согласно текущему statusLabel (если без textfield).
        let desiredButtonTopFromStatus = (safeTop + nameTopOffset + nameHeight) + 8 /* gap after name */ + statusHeight + statusToButtonGap

        // Устанавливаем базовую кнопку как max(avatarBased, statusBased)
        if baseButtonY < desiredButtonTopFromStatus {
            baseButtonY = desiredButtonTopFromStatus
        }

        // Теперь, если текстовое поле показано, добавляем дополнительный сдвиг, чтобы поместить textField между statusLabel и кнопкой.
        var buttonY = baseButtonY
        if isEditingStatus {
            // хотим разместить textField под statusLabel с tfSpacing сверху и снизу — поэтому смещаем кнопку вниз на tfHeight + 2*tfSpacing
            let extra = tfHeight + 2.0 * tfSpacing
            buttonY = baseButtonY + extra
        }

        // Теперь строго вычисляем позицию statusLabel: его нижняя граница должна быть buttonTop - statusToButtonGap
        let statusBottomY = buttonY - statusToButtonGap
        let statusY = statusBottomY - statusHeight
        statusLabel.frame = CGRect(x: rightX, y: statusY, width: rightWidth, height: statusHeight)

        // TextField размещаем между statusLabel и кнопкой (если показан)
        if isEditingStatus {
            let tfY = statusLabel.frame.maxY + tfSpacing
            statusTextField.frame = CGRect(x: rightX, y: tfY, width: rightWidth, height: tfHeight)
            statusTextField.isHidden = false
        } else {
            statusTextField.isHidden = true
            statusTextField.frame = CGRect(x: rightX, y: statusLabel.frame.maxY + 8, width: rightWidth, height: tfHeight)
        }

        // Button
        let btnWidth = fullW - 32
        let btnHeight: CGFloat = 50
        setStatusButton.frame = CGRect(x: 16, y: buttonY, width: btnWidth, height: btnHeight)
    }
}
