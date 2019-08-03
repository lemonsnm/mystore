package cn.itcast.estore.servlet;

import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * servlet模块化：
 * @author lemonSun
 *
 * 2019年6月16日下午10:17:55
 */
@SuppressWarnings("all")
public class BaseServlet extends HttpServlet {
	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		// servlet的路径?method=serlvet中的方法名
		// user?method=login
		String methodName = request.getParameter("method");
		Class clazz = this.getClass();
		try {
			Method method = clazz.getMethod(methodName, HttpServletRequest.class, 
					HttpServletResponse.class);
			method.invoke(this, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
