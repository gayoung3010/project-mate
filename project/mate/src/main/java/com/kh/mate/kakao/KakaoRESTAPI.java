package com.kh.mate.kakao;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
public class KakaoRESTAPI {
	
	private final static String K_CLIENT_ID = "d36df5a7d77a76106c5ce10dd331a41e";
	private final static String K_REDIRECT_URI = "http://park.jh92.kro.kr/mate/kakaocallback.do";
	
	public static String getAuthorizationUrl(HttpSession session) {
		String kakaoUrl = "https://kauth.kakao.com/oauth/authorize?" + "client_id=" + K_CLIENT_ID + "&redirect_uri="
				+ K_REDIRECT_URI + "&response_type=code";
		//값 확인됨
//		log.debug("kakakoUrl= {}",kakaoUrl);
		return kakaoUrl;
	}
	

	public static JsonNode getAccessToken(String authorize_code) {
		
		final String RequestUrl = "https://kauth.kakao.com/oauth/token";
		final List<NameValuePair> postList = new ArrayList<NameValuePair>();
		postList.add(new BasicNameValuePair("grant_type", "authorization_code"));
		postList.add(new BasicNameValuePair("client_id", "d36df5a7d77a76106c5ce10dd331a41e"));
		postList.add(new BasicNameValuePair("redirect_uri", "http://park.jh92.kro.kr/mate/kakaocallback.do"));
		
		log.debug("authorize_code = {}", authorize_code);
		//로그인 과정중 얻은 code값		
		postList.add(new BasicNameValuePair("code", authorize_code));
		log.debug("postList = {}", postList);
		final HttpClient client = HttpClientBuilder.create().build();
		final HttpPost post = new HttpPost(RequestUrl);
		log.debug("client = {}", client);
		log.debug("post = {}", post);
		JsonNode returnNode = null;
		
		try {
			//예외처리 해야함
			post.setEntity(new UrlEncodedFormEntity(postList));
			final HttpResponse response = client.execute(post);
			// JSON 형태 반환값 처리
			ObjectMapper mapper = new ObjectMapper();
			returnNode = mapper.readTree(response.getEntity().getContent());
			
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		log.debug("returnNode = {}", returnNode);
		return returnNode;
	}
	
	//여기가 지금 값을 못받는데,
	public static JsonNode getKakaoUserInfo(JsonNode accessToken) {
		final String RequestUrl = "https://kapi.kakao.com/v2/user/me";
		final HttpClient client = HttpClientBuilder.create().build();
		final HttpPost post = new HttpPost(RequestUrl);
		//요놈때문에 정보를 못읽어오네
		log.debug("accessToken={}", accessToken);
		// add header
		//Bearer 스트링 띄어쓰기 안해서 정보 안읽어져오는거 였음 ...
		post.addHeader("Authorization", "Bearer " + accessToken);
		JsonNode returnNode = null;
		
		try {
			final HttpResponse response = client.execute(post);
			//JSON 형태 반환값 처리
			ObjectMapper mapper = new ObjectMapper();
			returnNode = mapper.readTree(response.getEntity().getContent());
			log.debug("returnNode = {}", returnNode);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return returnNode;
	}
}
