//
//  FastisMonthHeader.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class MonthHeader: JTACMonthReusableView {

    // MARK: - Outlets

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month name"
        return label
    }()

    // MARK: - Variables

    internal var calculatedHeight: CGFloat = 0
    internal var tapHandler: (() -> Void)?
    private var insetConstraint: Constraint?
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(FastisConfig.default.monthHeader)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(tapRecognizer)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureSubviews() {
        self.addSubview(self.monthLabel)
    }

    private func configureConstraints() {
        self.monthLabel.snp.makeConstraints { (maker) in
            self.insetConstraint = maker.edges.equalToSuperview().constraint
        }
    }

    internal func configure(for date: Date) {
        self.monthLabel.text = self.monthFormatter.string(from: date).capitalizingFirstLetter()
    }

    // MARK: - Actions

    internal func applyConfig(_ config: FastisConfig.MonthHeader) {
        self.monthFormatter.dateFormat = config.monthFormat
        self.monthFormatter.locale = config.monthLocale
        self.monthLabel.font = config.labelFont
        self.monthLabel.textColor = config.labelColor
        self.monthLabel.textAlignment = config.labelAlignment
        self.insetConstraint?.update(inset: config.insets)
    }

    @objc private func viewTapped() {
        self.tapHandler?()
    }

}

extension FastisConfig {

    /**
     Month titles
     
     Configurable in FastisConfig.``FastisConfig/monthHeader-swift.property`` property
     */
    public struct MonthHeader {

        /**
         Text alignment for month title label
         
         Default value — `.left`
         */
        public var labelAlignment: NSTextAlignment = .left

        /**
         Text color for month title label
         
         Default value — `.label`
         */
        public var labelColor: UIColor = .label

        /**
         Text font for month title label
         
         Default value — `.systemFont(ofSize: 17, weight: .semibold)`
         */
        public var labelFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)

        /**
         Insets for month title label
         
         Default value — `UIEdgeInsets(top: 24, left: 8, bottom: 4, right: 16)`
         */
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 24, left: 8, bottom: 4, right: 16)

        /**
         Format of displayed month value
         
         Default value — `"LLLL yyyy"`
         */
        public var monthFormat: String = "LLLL yyyy"

        /**
         Locale of displayed month value
         
         Default value — `.current`
         */
        public var monthLocale: Locale = .current

        /**
         Height of month view
         
         Default value — `48pt`
         */
        public var height: MonthSize = MonthSize(defaultSize: 48)
    }

}
