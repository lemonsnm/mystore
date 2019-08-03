package com.github.wxpay.sdk;

import java.io.InputStream;
import java.util.ResourceBundle;

public class MyConfig extends WXPayConfig {
	private static final ResourceBundle RB = ResourceBundle.getBundle("wxpay");
	private static final String APPID = RB.getString("appid");
	private static final String MCHID = RB.getString("mchid");
	private static final String KEY = RB.getString("key");
	// 企业方公众号Id
	String getAppID() {
		return APPID;
	}

	// 商户账号
	String getMchID() {
		return MCHID;
	}
	
	// 获取 API 密钥
	String getKey() {
		return KEY;
	}

	InputStream getCertStream() {
		return null;
	}

	IWXPayDomain getWXPayDomain() {
		return IWXPayDomainImpl.instance();
	}
}
