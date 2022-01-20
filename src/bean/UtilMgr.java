package bean;

import java.io.File;
import java.io.UnsupportedEncodingException;

public class UtilMgr {
	public static String replace(String str, String pattern, String replace) {
		int s = 0, e = 0;
		StringBuffer result = new StringBuffer();
		
		while(( e = str.indexOf(pattern, s)) >= 0) {
			result.append(str.substring(s, e));
			result.append(replace);
			s = e + pattern.length();
		}
		result.append(str.substring(s));
		return result.toString();
	}
	
	public static void delete(String path) {
		File file = new File(path);
		if(file.isFile()) {
			file.delete();
		}
	}
}
