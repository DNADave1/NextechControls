//
//  MergeMenuViewController.swift
//  NexTech
//
//  Created by David Strehlow on 9/18/20.
//

import UIKit
import Foundation

enum CCDAType {
    case summaryOfCare
    case clinicalSummary
}

protocol MergeMenuViewControllerDelegate: UIPopoverPresentationControllerDelegate {
    func startCCDAListCoordinator()
    func startCCDAGenerationCoordinator(_ type: CCDAType)
    var unreconciledCCDACount: Int { get }
}

public class MergeMenuViewController2: UIViewController {
    
    // Options that might be set externally:
    public var viewCornerRadius: CGFloat = 8
    public var badgeCornerRadius: CGFloat = 12
    public var badgeBackgroundColor: UIColor = .red
    
    private weak var delegate: MergeMenuViewControllerDelegate?
    
    @IBOutlet weak var ClinicalSumButton: UIButton!
    @IBOutlet weak var SummaryOfCareButton: UIButton!
    @IBOutlet weak var CCDAsToReconcileBadge: UIView!
    @IBOutlet weak var BadgeView: UIView!
    @IBOutlet var CCDAsNeedingReconciliationButton: UIButton!
    @IBOutlet weak var CCDABadgeLabel: UILabel!
    private var originalBadgeViewFrame: CGRect = CGRect.zero
    private var ccdaReconcileVersion: Bool = false
    private var ccdaReconcileFeature: Bool = false
    
    // This class requires two version booleans, a delegate and the name of a storyboard and bundle
    init(apiVerson: Bool, ldFeature: Bool, delegate: MergeMenuViewControllerDelegate, nibName: String, bundle: Bundle = .main) {
        super.init(nibName: nibName, bundle: bundle)
        self.delegate = delegate
        self.ccdaReconcileVersion = apiVerson
        self.ccdaReconcileFeature = ldFeature
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = viewCornerRadius
        self.BadgeView.layer.cornerRadius = badgeCornerRadius
        self.BadgeView.backgroundColor = badgeBackgroundColor
        
        if !ccdaReconcileVersion || !ccdaReconcileFeature {
            self.CCDAsToReconcileBadge.isHidden = true
            self.CCDAsNeedingReconciliationButton.isEnabled = false
        } else if let count = delegate?.unreconciledCCDACount, count > 0 {
            self.CCDABadgeLabel.text = "\(count)"
            self.CCDAsToReconcileBadge.isHidden = false
            self.CCDAsNeedingReconciliationButton.isEnabled = true
        } else {
            self.CCDAsToReconcileBadge.isHidden = true
            self.CCDAsNeedingReconciliationButton.isEnabled = false
        }
    }
    
    @IBAction func ReconcileButtonPushed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.startCCDAListCoordinator()
        }
    }
    
    @IBAction func SummaryOfCareButtonPushed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.startCCDAGenerationCoordinator(CCDAType.summaryOfCare)
        }
    }
    
    @IBAction func ClinicalSummaryButtonPushed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if let delegate = delegate {
            delegate.startCCDAGenerationCoordinator(CCDAType.clinicalSummary)
        }
    }
    
}
