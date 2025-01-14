//
//  FastisCurrentValueView.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit

class CurrentValueView<Value: FastisValue>: UIView {

    // MARK: - Outlets

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = self.config.placeholderTextColor
        label.text = self.config.placeholderTextForRanges
        label.font = self.config.textFont
        return label
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(CurrentValueView.clear), for: .touchUpInside)
        button.setImage(self.config.clearButtonImage, for: .normal)
        button.tintColor = self.config.clearButtonTintColor
        button.alpha = 0
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Variables

    private let config: FastisConfig.CurrentValueView

    /// Clear button tap handler
    internal var onClear: (() -> Void)?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = self.config.locale
        formatter.dateFormat = self.config.format
        return formatter
    }()

    internal var currentValue: Value? {
        didSet {
            self.updateStateForCurrentValue()
        }
    }

    // MARK: - Lifecycle

    internal init(config: FastisConfig.CurrentValueView) {
        self.config = config
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
        self.updateStateForCurrentValue()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        self.backgroundColor = .clear
    }

    private func configureSubviews() {
        self.containerView.addSubview(self.label)
        self.containerView.addSubview(self.clearButton)
        self.addSubview(self.containerView)
    }

    private func configureConstraints() {
        self.clearButton.snp.makeConstraints { (maker) in
            maker.right.top.bottom.centerY.equalToSuperview()
        }
        self.label.snp.makeConstraints { (maker) in
            maker.top.bottom.centerX.equalToSuperview()
            maker.right.lessThanOrEqualTo(self.clearButton.snp.left)
            maker.left.greaterThanOrEqualToSuperview()
        }
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(self.config.insets)
        }
    }

    private func updateStateForCurrentValue() {

        if let value = self.currentValue as? Date {

            self.label.text = self.dateFormatter.string(from: value)
            self.label.textColor = self.config.textColor
            self.clearButton.alpha = 1
            self.clearButton.isUserInteractionEnabled = true

        } else if let value = self.currentValue as? FastisRange {

            self.label.textColor = self.config.textColor
            self.clearButton.alpha = 1
            self.clearButton.isUserInteractionEnabled = true

            if value.onSameDay {
                self.label.text = self.dateFormatter.string(from: value.fromDate)
            } else {
                self.label.text = self.dateFormatter.string(from: value.fromDate) + " – " + self.dateFormatter.string(from: value.toDate)
            }

        } else {

            self.label.textColor = self.config.placeholderTextColor
            self.clearButton.alpha = 0
            self.clearButton.isUserInteractionEnabled = false

            switch Value.mode {
            case .range:
                self.label.text = self.config.placeholderTextForRanges

            case .single:
                self.label.text = self.config.placeholderTextForSingle

            }

        }

    }

    // MARK: - Actions

    @objc private func clear() {
        self.onClear?()
    }

}

extension FastisConfig {

    /**
     Current value view appearance (clear button, date format, etc.)
     
     Configurable in FastisConfig.``FastisConfig/currentValueView-swift.property`` property
     */
    public struct CurrentValueView {

        /**
         Placeholder text in .range mode
         
         Default value — `"Select date range"`
         */
        public var placeholderTextForRanges: String = "Select date range"

        /**
         Placeholder text in .single mode
         
         Default value — `"Select date"`
         */
        public var placeholderTextForSingle: String = "Select date"

        /**
         Color of the placeholder for value label
         
         Default value — `.tertiaryLabel`
         */
        public var placeholderTextColor: UIColor = .tertiaryLabel

        /**
         Color of the value label
         
         Default value — `.label`
         */
        public var textColor: UIColor = .label

        /**
         Font of the value label
         
         Default value — `.systemFont(ofSize: 17, weight: .regular)`
         */
        public var textFont: UIFont = .systemFont(ofSize: 17, weight: .regular)

        /**
         Clear button image
         
         Default value — `UIImage(systemName: "xmark.circle")`
         */
        public var clearButtonImage: UIImage? = UIImage(systemName: "xmark.circle")

        /**
         Clear button tint color
         
         Default value — `.systemGray3`
         */
        public var clearButtonTintColor: UIColor = .systemGray3

        /**
         Insets of value view
         
         Default value — `UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)`
         */
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)

        /**
         Format of current value
         
         Default value — `"d MMMM"`
         */
        public var format: String = "d MMMM"

        /**
         Locale of formatter
         
         Default value — `Locale.autoupdatingCurrent`
         */
        public var locale: Locale = .autoupdatingCurrent
    }
}
