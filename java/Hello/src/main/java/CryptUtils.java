import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * @author biao.tang
 * @date 2020-04-10
 */
public class CryptUtils {

    public static String getSignCheckContent(Map<String,String> params){
        StringBuffer content = new StringBuffer();
        ArrayList keys = new ArrayList(params.keySet());
        Collections.sort(keys);

        for(int i = 0; i < keys.size(); ++i) {
            String key = (String)keys.get(i);
            String value = params.get(key);
            content.append((i == 0?"":"&") + key + "=" + value);
        }
        return content.toString();
    }

    public static String md5(String str) {
        try {
            // 生成一个MD5加密计算摘要
            MessageDigest md = MessageDigest.getInstance("MD5");
            // 计算md5函数
            md.update(str.getBytes());
            // digest()最后确定返回md5 hash值,返回值为8为字符串。因为md5 hash值是16位的hex值,实际上就是8位的字符
            // BigInteger函数则将8位的字符串转换成16位hex值,用字符串来表示；得到字符串形式的hash值
            String md5=new BigInteger(1, md.digest()).toString(16);
            //BigInteger会把0省略掉,需补全至32位
            return fillMD5(md5).toLowerCase();
        } catch (Exception e) {
            throw new RuntimeException("MD5加密错误:"+e.getMessage(),e);
        }
    }

    public static String fillMD5(String md5){
        return md5.length() == 32 ? md5 : fillMD5("0"+md5);
    }


    public static void main(String[] args) {
        String current = "1749626583155";
        String code = "monitor";
        Map<String, String> signMap = new HashMap<>();
        signMap.put("time", current);
        signMap.put("code", code);
        signMap.put("key", "dsds92312KNJJHU@&#saddsEOEGYI-==!%^dslk87305R==");
        String signData = CryptUtils.getSignCheckContent(signMap);

        String signMd5 = CryptUtils.md5(signData);
        System.out.println(signData);

    }

}
