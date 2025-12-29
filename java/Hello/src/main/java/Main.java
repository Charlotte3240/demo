import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Main {

    public static void main(String[] args) throws Exception {
        Set<String> list = Stream.of("1", "2").collect(Collectors.toSet());
        list = Collections.emptySet();
        System.out.println(list);
        System.out.println("1" + String.join(",", list));

    }
}
