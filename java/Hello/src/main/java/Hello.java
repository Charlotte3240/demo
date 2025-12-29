import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;



public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        String[] arr = {"hello", "world"};
        for (String str : arr) {
            System.out.println(str);
        }
        List<String> l = Stream.of(arr).collect(Collectors.toList());
        List<String> a = l.stream().peek(e -> {
            System.out.println(e);
            System.out.println(e + "1");
        }).collect(Collectors.toList());
        a = l.stream().map( e ->{
            return e + "2";
        }).collect(Collectors.toList());

        System.out.println(a);
        System.out.println("start");
        Variables.foo(arr);
        System.out.println("end");

        Arrays.stream(arr).forEach(e ->{
            System.out.println(e + "222");
        });


        Person p = new Person();
        String bob = "Bob";
        p.setName(bob); // 传入bob变量
        System.out.println(p.getName()); // "Bob"
        bob = "Alice"; // bob改名为Alice
//        p.setName(bob); // 传入bob变量

        System.out.println(p.getName()); // "Bob"还是"Alice"?



    }
}

class Person {
    private String name;

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }
}