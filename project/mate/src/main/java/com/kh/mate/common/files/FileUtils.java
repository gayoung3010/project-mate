package com.kh.mate.common.files;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class FileUtils {
	
	//폴더 내 파일 옮기기
	public static void fileCopy(File sourceF, File targetF) {
		File[] target_file = sourceF.listFiles();
		for (File file : target_file) {
			File temp = new File(targetF.getAbsolutePath() + File.separator + file.getName());
			if(file.isDirectory()){
				temp.mkdir();
				fileCopy(file, temp);
			} else {
			    FileInputStream fis = null;
				FileOutputStream fos = null;
				try {
					fis = new FileInputStream(file);
					fos = new FileOutputStream(temp) ;
					byte[] b = new byte[4096];
					int cnt = 0;
					while((cnt=fis.read(b)) != -1){
						fos.write(b, 0, cnt);
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally{
					try {
						fis.close();
						fos.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		   }
	    }
	
	//폴더내 파일 삭제
	public static void fileDelete(String path) {
		File folder = new File(path);
		try {
			if(folder.exists()) {
				File[] folder_list = folder.listFiles();
				
				for(int i=0; i < folder_list.length; i++) {
					if(folder_list[i].isFile()) {
						folder_list[i].delete();
					}else {
						fileDelete(folder_list[i].getPath());
					}
					folder_list[i].delete();
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//폴더 내 파일명 가져오기
	public static List<String> getFileName(File sourceF) {
		File[] targetF = sourceF.listFiles();
		List<String> fileNameList = new ArrayList<>();
		for(File f : targetF) {
			String fileName = f.getName();
			fileNameList.add(fileName);
		}
		
		return fileNameList;
	}

}
