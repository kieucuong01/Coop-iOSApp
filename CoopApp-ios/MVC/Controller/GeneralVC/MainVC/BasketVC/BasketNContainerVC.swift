import Foundation
import XLPagerTabStrip

class BasketNContainerVC: BaseButtonBarPagerTabStripViewController<IconWithLabelCell> {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "IconWithLabelCell", bundle: Bundle(for: IconWithLabelCell.self), width: { _ in
                return 70.0
        })
    }

    override func viewDidLoad() {
        self.title = NSLocalizedString("SỌT HÀNG", comment: "")
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
//        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .red
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { [weak self] (oldCell: IconWithLabelCell?, newCell: IconWithLabelCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconImage.tintColor = .lightGray
            oldCell?.iconLabel.textColor = .lightGray
            newCell?.iconImage.tintColor = .red
            newCell?.iconLabel.textColor = .red
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "ic_printer"), style: .plain, target: self, action: #selector(self.printAction(_:)))]

        super.viewDidLoad()
    }
    
//    private func callAPIInsertBasket(){
//        APIBase.sharedInstance()?.callAPIInsertBasket(isShowHUD: true, params: nil, completionHandler: { (result, error) in
//            if error == nil{
//                // Success
//                let basket : BasketModel = BasketModel(dict: result?["basket"] as! Dictionary<String, Any>)
//                if let vc = self.viewControllers[0] as? BasketVC {
//                    vc.baskets.append(basket)
//                    vc.collectionView.reloadData()
//                }
//            }
//            else {
//                // Call API Fail
//                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
//            }
//        })
//    }
//
//    private func callAPIInsertContainer(){
//        let params = ["name" : "name",
//                      "description": "description"] as [String : Any]
//
//        APIBase.sharedInstance()?.callAPIInsertContainer(isShowHUD: true, params: params, completionHandler: { (result, error) in
//            if error == nil {
//                let container : ContainerModel = ContainerModel(dict: result?["container"] as! Dictionary<String, Any>)
//                // Success
//                if let vc = self.viewControllers[1] as? ContainerVC{
//                    vc.list.append(container)
//                    vc.collectionView.reloadData()
//                }
//            }
//            else {
//                // Call API Fail
//                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
//            }
//        })
//    }
//
//    @objc func addAction(){
//        if self.currentIndex == 0 {
//            self.callAPIInsertBasket()
//        }
//        else if self.currentIndex == 1 {
//            self.callAPIInsertContainer()
//        }
//    }
    
    @objc func printAction(_ sender: UIBarButtonItem){
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "My Print Job"
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        let viewController = self.viewControllers[self.currentIndex]
        printController.printingItem = viewController.view.toImage()
        
        // Do it
        printController.present(animated: true, completionHandler: nil)
    }
    
    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboardLogin: UIStoryboard = UIStoryboard(name: "Basket", bundle: nil)
        let vc1 : BasketVC = storyboardLogin.instantiateViewController(withIdentifier: "basketVC") as! BasketVC
        vc1.itemInfo = IndicatorInfo(title: "SỌT HÀNG", image: UIImage(named: "ic_cart"))
        vc1.delegate = self
        
        let vc2 : ContainerVC = storyboardLogin.instantiateViewController(withIdentifier: "containerVC") as! ContainerVC
        vc2.itemInfo = IndicatorInfo(title: "THÙNG HÀNG", image: UIImage(named: "ic_container"))
        
        return [vc1, vc2]
    }

    override func configure(cell: IconWithLabelCell, for indicatorInfo: IndicatorInfo) {
        cell.iconImage.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
        cell.iconLabel.text = indicatorInfo.title?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }
}

extension BasketNContainerVC : BasketVCDelegate {
    func clickedButtonCancel(sender: BasketVC) {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addAction))
    }
    
    func clickedButtonOK(sender: BasketVC) {
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_printer"), style: .plain, target: self, action: #selector(self.printAction(_:)))
    }
}
