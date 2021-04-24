package com.kh.mate.member.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kh.mate.common.Pagebar;
import com.kh.mate.member.model.vo.Address;
import com.kh.mate.member.model.vo.Member;

public interface MemberDAO {

	int insertMember(Member member);

	Member selectOneMember(String memberId);

	int updateMember(Map<String, Object> map);

	int deleteMember(Map<String, Object> map);

	List<Map<String, Object>> selectAllPurchase(String memberId);

	List<Address> selectMemberAddress(String memberId);

	int checkAddressName(Map<String, Object> param);

	int insertAddress(Map<String, Object> param);

	int successPurchase(int purchaseNo);

	int failPurchase(int purchaseNo);

	List<Member> searchMember(Pagebar pb);

	int getSearchContent(Pagebar pb);

	int tempPassword(HashMap<String, String> map);

	int deleteAddress(Map<String, String> param);

}
