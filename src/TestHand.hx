package ;
import com.lime.zeromvc.Observer;
import com.lime.zeromvc.IExecute;
class TestHand implements IExecute<Observer<Int>, Int, String> {
    public function new() {
    }

    public function init(target:Observer<Int>, type:Int):Void {

        trace("init");
        target.dispose(type);
    }

/**
     * 执行
     * 当观察者派发通知时，接口实现类所注册的对应识标时执行本方法！
     *
     * @param tContent
     */

    public function execute(tContent:String):Void {
trace("fuck");

    }

/**
     * 释放
     * 移除观察对接口实现类的实例的引用！
     * 释放不会立即生效！
     */

    public function dispose():Void {


    }
}
