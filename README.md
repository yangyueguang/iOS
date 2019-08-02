# Freedom
```
这是我的自由主义项目 http://k4wvm2.axshare.com 项目原型设计稿
extension Reactive where Base: UIView {
    func tap() -> Observable<UITapGestureRecognizer> {
        let tap = UITapGestureRecognizer()
        base.isUserInteractionEnabled = true
        base.addGestureRecognizer(tap)
        let observableTap = tap.rx.event
            .filter{ $0.state == UIGestureRecognizer.State.recognized}
            .startWith(tap)
            .do(onDispose: {[weak base, weak tap] in
                guard let tap = tap else { return }
                base?.removeGestureRecognizer(tap)
            })
            .takeUntil(self.base.rx.deallocated)
        return observableTap
    }
}
```
