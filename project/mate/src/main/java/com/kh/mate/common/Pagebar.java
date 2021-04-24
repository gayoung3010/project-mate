package com.kh.mate.common;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Pagebar implements Serializable{

	private int cPage;
	private int numPerPage;
	private int totalContents;
	private String url;
	private int pageBarSize;
	
	private int totalPage;
	private int pageStart;
	private int pageEnd;
	private int pageNo;
	
	private int start;
	private int end;
	private Map<String, Object> options;
	
	public Pagebar(int cPage, int numPerPage, String url, int pageBarSize) {
		this.cPage = cPage;
		this.numPerPage = numPerPage;
		this.url = url;
		this.pageBarSize = pageBarSize;
	}
	
	public int getcPage() {
		return cPage;
	}

	public void setcPage(int cPage) {
		this.cPage = cPage;
	}

	public int getNumPerPage() {
		return numPerPage;
	}

	public void setNumPerPage(int numPerPage) {
		this.numPerPage = numPerPage;
	}

	public int getTotalContents() {
		return totalContents;
	}

	public void setTotalContents(int totalContents) {
		this.totalContents = totalContents;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public int getPageBarSize() {
		return pageBarSize;
	}

	public void setPageBarSize(int pageBarSize) {
		this.pageBarSize = pageBarSize;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	
	public int getStart() {
		this.start = (this.cPage-1)*this.numPerPage +1;
		return this.start;
	}
	
	public int getEnd() {
		this.end = this.cPage*this.numPerPage;
		return this.end;
	}
	
	public void setOptions(Map<String, Object> options) {
		this.options = options;
	}
	
	public String getPagebar() {
		//url에 조건 추가
		this.url += "?";
		if(this.options != null && !this.options.isEmpty()) {
			for(String key : this.options.keySet()) {
				if(this.options.get(key) != null && !this.options.get(key).equals("")) {
					if(this.options.get(key).getClass().isArray()) {
						this.url += "&" + key + "=";
						String[] values = (String[])this.options.get(key);
						for(int i = 0; i < values.length ; i++) {
							this.url += values[i];
							if(i != values.length-1) this.url += ",";
						}
					}
					else {
						Object value = this.options.get(key);
						if( value instanceof Integer) {
							value = (int)this.options.get(key);
						}else if(value instanceof String) {
							value = (String)this.options.get(key);
						}
						
						this.url += "&" + key + "=" + value;
					}
				}
			}
		}
		this.totalPage = (int)(Math.ceil(new Double(this.totalContents)/this.numPerPage));
		this.pageStart = ((this.cPage-1) / this.pageBarSize) * this.pageBarSize + 1;
		this.pageEnd = (this.pageStart + this.pageBarSize) -1;
		this.pageNo = this.pageStart;
		
		StringBuilder pageBar = new StringBuilder();
		
		if(pageNo == 1) {
			
		}else {
			pageBar.append("<a href='"+this.url+"&cPage="+(this.pageNo-1)+"'>이전</a>\n");
		}
		
		//PageNo
		while(this.pageNo <= this.pageEnd && this.pageNo <= this.totalPage) {
			//현재페이지인 경우
			if(pageNo==cPage) {
				pageBar.append("<span class='cPage' style='background-color:#F2F2F2;'>"+this.pageNo+"</span>\n");
			}
			//현재페이지가 아닌경우
			else {
				pageBar.append("<a href='"+this.url+"&cPage="+this.pageNo+"'>"+this.pageNo+"</a>\n");
			}
			this.pageNo++;
			
		}
		
		//다음
		if(this.pageNo > this.totalPage ) {
			
		}else {
			pageBar.append("<a href='"+this.url+"&cPage="+this.pageNo+"'>다음</a>\n");
		}
		System.out.println(pageBar.toString());
		return pageBar.toString();
	}
}
