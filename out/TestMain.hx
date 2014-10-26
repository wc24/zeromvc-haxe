package ;
import haxe.macro.Type.ClassType;
import com.lime.zeromvc.Observer;
import TestHand;
class TestMain {
    public static function main() {
        var sss = new Observer<Int>();

        sss.addListener(1, TestHand);

//         new TestHand();
//        trace(Type.resolveClass("TestHand"));
//        Type.getClass<TestHand>();
//        trace(TestHand);

        sss.notify(1);
        sss.notify(1);
        sss.clearListener(1);
        sss.notify(2);

    }

    public function new() {
    }
}
