package com.kh.mate.naver;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.util.StringUtils;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

public class NaverLoginBO {
	private final static String CLIENT_ID = "7jsrhEQR5MfpczPZr2CA";
	private final static String CLIENT_SECRET = "40PJTrMctm";
	private final static String REDIRECT_URI = "http://park.jh92.kro.kr/mate/callback.do";
	private final static String SESSION_STATE = "oauth_state";
	
	 /* 프로필 조회 API URL => 이건 아직 모르겠음*/
    private final static String PROFILE_API_URL = "https://openapi.naver.com/v1/nid/me";

    public String getAuthorizationUrl(HttpSession session) {
    	String state = generateRandomString();
    	setSession(session, state);
    	
    	OAuth20Service oauthService = new ServiceBuilder()
    								  .apiKey(CLIENT_ID)
    								  .apiSecret(CLIENT_SECRET)
    								  .callback(REDIRECT_URI)
    								  .state(state)
    								  .build(NaverLoginApi.instance());
    	
    	return oauthService.getAuthorizationUrl();
    }
    
    public OAuth2AccessToken getAcessToken(HttpSession session, String code, String state) throws IOException  {
    	
    	String sessionState = getSession(session);
    	if(StringUtils.pathEquals(sessionState, state)) {

        	OAuth20Service oauthService = new ServiceBuilder()
        								  .apiKey(CLIENT_ID)
        								  .apiSecret(CLIENT_SECRET)
        								  .callback(REDIRECT_URI)
        								  .state(state)
        								  .build(NaverLoginApi.instance());
        	// getAccessToken이 예외를 던짐
        	OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
        	return accessToken;
    	}
    	
    	//나중에 return 수정할 것
    	return null;
    }
    
  
    
	private void setSession(HttpSession session, String state) {
		session.setAttribute(SESSION_STATE, state);
		
	}
	
	private String getSession(HttpSession session) {
		return (String)session.getAttribute(SESSION_STATE);
	}

	private String generateRandomString() {
		
		return UUID.randomUUID().toString();
	}
	  // Access Token을 이용하여 네이버 사용자 프로필 API를 호출
    public String getUserProfile(OAuth2AccessToken oauthToken) throws IOException {
    	
    	OAuth20Service oauthService = new ServiceBuilder()
    								  .apiKey(CLIENT_ID)
    								  .apiSecret(CLIENT_SECRET)
    								  .callback(REDIRECT_URI)
    								  .build(NaverLoginApi.instance());
    	OAuthRequest request = new OAuthRequest(Verb.GET, PROFILE_API_URL, oauthService);
    	oauthService.signRequest(oauthToken, request);
    	Response response = request.send();
    	
    	return response.getBody();
    }
}
