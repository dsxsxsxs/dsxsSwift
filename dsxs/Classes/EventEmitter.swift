//
//  EventEmitter.swift
//  dsxs
//
//  Created by dsxs on 2017/7/28.
//  Copyright © 2017年 nicos-dev. All rights reserved.
//

import Foundation

struct Weak<T: AnyObject> {
    weak var value : T?
    init (_ value: T) {
        self.value = value
    }
}
public class EventListenerBag<E:Hashable, T:Any>:NSObject{
    var listeners:[Weak<EventListener<E, T>>] = []
    deinit {
        for l in listeners{
            l.value?.emitter?.off(listener: l.value)
        }
    }
}

public class EventListener<E:Hashable, T:Any>:NSObject{
    public typealias Handler = (T) -> Void
    public typealias Bag = EventListenerBag<E, T>
    public typealias Emitter = EventEmitter<E, T>
    var event:E!
    var fn: Handler!
    weak var emitter: Emitter!
    public init(_ fn:Handler!){
        self.fn = fn
    }
    public func addTo(_ bag:Bag!) {
        bag.listeners.append(Weak<EventListener<E, T>>(self))
    }
}


public class EventEmitter<E:Hashable, T:Any>:NSObject{
    public typealias Handler = (T) -> Void
    public typealias Listener = EventListener<E, T>
    var events = [E: [Listener]]()
    
    @discardableResult
    public func on(_ event:E, listener: Listener)->Listener{
        if events[event] == nil{
            events[event] = []
        }
        listener.event = event
        listener.emitter = self
        events[event]?.append(listener)
        return listener
    }
    @discardableResult
    public func once(_ event:E, listener: Listener)->Listener{
        if events[event] == nil{
            events[event] = []
        }
        let onceListener = Listener(nil)
        let target = listener.fn
        let fn:Handler = {[weak onceListener, weak self] obj in
            target?(obj)
            if onceListener != nil{
                self?.off(event, listener: onceListener)
            }
        }
        onceListener.event = event
        onceListener.fn = fn
        onceListener.emitter = self
        events[event]?.append(onceListener)
        return onceListener
    }
    public func off(_ event:E, listener: Listener! = nil) {
        if let listeners = events[event]{
            if listener == nil{
                events.removeValue(forKey: event)
            }else if let index = listeners.index(of:listener) {
                events[event]?.remove(at: index)
            }
        }
    }
    public func off(listener: Listener! = nil) {
        if let event = listener.event{
            off(event, listener: listener)
        }
    }
    @discardableResult
    public func emit(_ event:E, object: T)->Bool {
        if let handlers = events[event], handlers.count > 0{
            for handler in handlers{
                handler.fn(object)
            }
            return true
        }
        return false
    }
}

