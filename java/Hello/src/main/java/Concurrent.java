import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class Concurrent {
    public void parllesExcute(){
        List<String> list = new ArrayList<>();
        list.add("cby");
        list.add("yyzs");
        list.add("silent");

        // 并行执行所有组件处理
        List<CompletableFuture<String>> futures = new ArrayList<>();
        ExecutorService pool = Executors.newFixedThreadPool(10);   // 可复用，不要每次 new
        int i = 0;
        for (String category : list) {
            int finalI = i;
            CompletableFuture<String> future = CompletableFuture.supplyAsync(() ->{
                System.out.println("start recognize " + category);
                try {
                    Thread.sleep(1000L * finalI);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                System.out.println("end recognize " + category);
                if (!category.equals("silent")){
                    return "";
                }else{
                    return category;
                }
            });
            i++;
            futures.add(future);
        }
        // 等待所有结果
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();

        // 收集所有返回值
        List<String> results = futures.stream()
                .map(CompletableFuture::join)
                .filter(s -> !s.isEmpty())
                .distinct()
                .collect(Collectors.toList());

        System.out.println(results);
    }
}
