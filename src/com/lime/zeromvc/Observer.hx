package com.lime.zeromvc;

/**
 * 反射式 观察者
 * 在观察者对象上添加事件标识和对应要执行的类，一个标识可以对应多个类，一个类可以添加进不对的标识。当观察者派发通知时 通知标识所对应的类所会被实例化，初始化并且执行execute方法！若执行释放，第二接收到相应通知将会构建新的对象！否则只会产生一个识标只会产生一个实例并且常在内存！
 *
 * @param <TKey>
 */
import haxe.ds.ObjectMap;

class Observer<TKey> {

    private var target:Dynamic ;
    private var pool:ObjectMap<TKey, ObjectMap<Dynamic, Dynamic>> ;
    private var instancePool:ObjectMap<TKey, IExecute<Dynamic, Dynamic, Dynamic>> ;

/**
     * 观察者
     *
     * @param target 派发通知时的目标对象
     */

    public function new(target:Dynamic = null) {
        if (target == null) {
            this.target = this;
        } else {

            this.target = target;
        }
        init();
    }

    private function init():Void {
        pool = new ObjectMap();
        instancePool = new ObjectMap();
    }

/**
     * 添加监听
     *
     * @param type      监听标识
     * @param classType 监听执行类的反射对象(如 Dynamic.class)
     * @return
     */

    public function addListener(type:TKey, classType:Class<Dynamic>):Bool {
        var out:Bool = false;
        if (!hasListener(type)) {
            var map:ObjectMap<Dynamic, Dynamic> = new ObjectMap();
            pool.set(type, map);
        }
        if (!hasListener(type, classType)) {
            pool.get(type).set(classType, classType);
            out = true;
        }
        return out;
    }

/**
     * 移除监听
     *
     * @param type      监听标识
     * @param classType 监听执行类的反射对象(如 Dynamic.class)
     * @return
     */

    public function removeListener(type:TKey, classType:Class<Dynamic>) {
        var out:Bool = false;
        if (hasListener(type)) {
            out = pool.get(type).remove(classType);
        }
        return out;
    }

/**
     * 消除标识下所有监听
     *
     * @param type 监听标识
     * @return 是否消除成功
     */

    public function clearListener(type:TKey) {
        var out:Bool = false;
        if (hasListener(type)) {
            pool.remove(type);
            out = true;
        }
        return out;
    }

/**
     * 判断标识下是否存在监听
     *
     * @param type      监听标识
     * @param classType 监听执行类的反射对象(如 Dynamic.class)
     * @return 是否存在监听
     */

    public function hasListener(type:TKey, classType:Class<Dynamic> = null) {
        if (classType == null) {
            return pool.get(type) != null;

        } else {
            return pool.get(type) != null && pool.get(type).get(classType) != null;

        }
    }


/**
     * 释放
     *
     * @param type 监听标识
     * @return
     */

    public function dispose(type:TKey) {

        if (instancePool.get(type) != null) {
        trace("1");
            instancePool.remove(type);
            return true;
        } else {
            trace("2");
            return false;
        }
    }

/**
     * 通知
     *
     * @param type 监听标识
     * @param data 监听标识
     * @return 执行次数
     */

    public function notify(type:TKey, data:Dynamic = null):Int {
        var out:Int = 0;
        if (hasListener(type)) {
            for (classType in pool.get(type)) {
                var neure:IExecute<Dynamic, Dynamic, Dynamic> ;
                if (instancePool.get(type) != null) {
                    neure = instancePool.get(type);
                    neure.execute(data);
                } else {
                    neure = Type.createInstance(classType, new Array<Dynamic>());
                    instancePool.set(type, neure);
                    neure.init(target, type);
                    neure.execute(data);
                    out++;
                }
            }
        }
        return out;
    }

}
