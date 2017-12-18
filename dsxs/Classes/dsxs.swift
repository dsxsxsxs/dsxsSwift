public func printd(file: String = #file, function: String = #function, line: Int = #line, _ obj: Any...) {
    #if DEBUG
        if
            let filename = file.components(separatedBy: "/").last,
            let bundleID = Bundle.main.bundleIdentifier
        {
            let now = Date().toString("yyyy-MM-ddTHH:mm:ss")
            let prefix = "[\(now) \(bundleID) \(filename).\(function):\(line)]"
            var s = ""
            for o in obj{
                s = "\(s)\(o)"
            }
            print("\(prefix)\(s)")
        }
    #endif
}
extension Locale{
    public static let JP = Locale(identifier: "ja_JP")
    public static let TW = Locale(identifier: "zh_Hant_TW")
}

extension Sequence {
    public func groupBy<G: Hashable>(_ closure: (Iterator.Element)->G) -> [G: [Iterator.Element]] {
        var categories = [G: Array<Iterator.Element>]()
        for el in self {
            let key = closure(el)
            if case nil = categories[key]?.append(el) {
                categories[key] = [el]
            }
        }
        return categories
    }
}

extension UIImage{
    public class func image(with color: UIColor, size: CGSize) -> UIImage{
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIImageView{
    public func rotateForever(duration: Double = 1) {
        let id = String(ObjectIdentifier(self).hashValue)
        if layer.animation(forKey: id) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(Double.pi * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            rotationAnimation.isRemovedOnCompletion = false
            layer.add(rotationAnimation, forKey: id)
        }
    }
    public func stopRotating() {
        let id = String(ObjectIdentifier(self).hashValue)
        if layer.animation(forKey: id) != nil {
            layer.removeAnimation(forKey: id)
        }
    }
}
extension Int {
    public func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension CALayer {
    static let borderGray =  UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
    class CABorderLayer:CALayer{
        
    }
    public func remakeBorders(edges: [UIRectEdge], color: UIColor = .separatorColor, thickness: CGFloat=0.5, inset:CGFloat=0.0){
        if let subs = sublayers{
            for layer in subs{
                if layer is CABorderLayer { layer.removeFromSuperlayer() }
            }
        }
        for edge in edges{
            addBorder(edge: edge, color:color, thickness: thickness, inset: inset)
        }
    }
    
    func addBorder(edge: UIRectEdge, color: UIColor = .separatorColor, thickness: CGFloat=0.5, inset:CGFloat=0.0) {
        let border = CABorderLayer();
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0 + inset, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:frame.height - thickness - inset, width:frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0 + inset, y:0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:frame.width - thickness - inset, y: 0, width: thickness, height:frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
    
}

extension DispatchQueue{
    public func subQueue(do task:(()->Void)!, than cb:(()->Void)!) {
        DispatchQueue.global().async {
            task()
            DispatchQueue.main.async(execute: cb)
        }
    }
}

extension UIView{
    public func first<T: UIView>(where cb:((T)->Bool)!)->T?{
        for subview in subviews {
            if let subview = subview as? T, cb(subview) {
                return subview
            }
            if let target = subview.first(where: cb){
                return target
            }
        }
        return nil
    }
}

extension UIColor{
    public static let separatorColor = UITableView().separatorColor!
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
