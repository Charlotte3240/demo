import java.util.Arrays;

public class Variables {
    public static void foo(String[] args){
        Arrays.stream(args).forEach(e -> {
            if (e.length() > 3){
                System.out.println(e);
            }else{
                System.out.println(e+"123");
            }
        });
        Arrays.stream(args).forEach(e -> System.out.println(e+1));
    }
}
