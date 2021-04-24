package com.kh.mate.common;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Utils {

	
	public static String getRenamedFileName(String originalFilename) {
		String renamedFilename = null;

		int beginIndex = originalFilename.lastIndexOf('.');
		String ext = originalFilename.substring(beginIndex); // .png ....

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS_");
		DecimalFormat df = new DecimalFormat("000");
		
		renamedFilename = sdf.format(new Date())
						+ df.format(Math.random() * 1000 )
						+ ext;
		
		return renamedFilename;
	}


}
