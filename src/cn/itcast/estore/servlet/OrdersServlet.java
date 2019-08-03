package cn.itcast.estore.servlet;

import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;

import com.github.wxpay.sdk.MyConfig;
import com.github.wxpay.sdk.WXPay;
import com.google.gson.Gson;

import cn.itcast.estore.entity.Cart;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.Orders;
import cn.itcast.estore.entity.OrdersItem;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/orders")
public class OrdersServlet extends BaseServlet {
	
	
	
	public void getPayResult(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		MyConfig config = new MyConfig();
        WXPay wxpay = new WXPay(config);

        Map<String, String> data = new HashMap<String, String>();
        data.put("out_trade_no", req.getParameter("oid"));
        try {
            Map<String, String> response = wxpay.orderQuery(data);
            String result = response.get("trade_state");
            resp.getWriter().write(result);
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	//微信生成对应地址
	public void getUrl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		
		MyConfig config = new MyConfig();
        WXPay wxpay = new WXPay(config);
        
        Map<String, String> data = new HashMap<String, String>();
        data.put("body", "宿州学院商城-微信扫描支付中心");
        String oid = req.getParameter("oid");
        // 订单编号
        data.put("out_trade_no", oid);
        // 设备号，可以不指定
        data.put("device_info", "");
        // 币种：CNY表示人民币
        data.put("fee_type", "CNY");
        // 订单总金额，单位是分
        
        // 查询订单信息，主要是总金额
        QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
        String sql = "select * from orders where id=?";
        Orders orders = qr.query(sql, new BeanHandler<>(Orders.class), oid);
        // totalprice的单位是元，需要转换成分
        Double totalprice = orders.getTotalprice();
        totalprice = totalprice * 100;
        data.put("total_fee", totalprice.intValue()+ "");
        // 支付方的ip地址
        data.put("spbill_create_ip", "127.0.0.1");
        // 支付成功之后的通知地址，我们不需要这个地址，但如果要想
        // 知道支付是否成功，需要单独调用一个接口进行查询订单的支付状态
        data.put("notify_url", "http://www.example.com/wxpay/notify");
        // 付款方式：扫码支付对应的值为NATIVE
        data.put("trade_type", "NATIVE");  // 此处指定为扫码支付
        // 商品编号
        //data.put("product_id", "12");

        try {
        	// 调用微信下单接口，返回下单的结果，其中包含支付从URL
        	// 地址，这个地址就是用来生成二维码连接的地址
            Map<String, String> response = wxpay.unifiedOrder(data);
            // 微信支付的连接地址
            String code_url = response.get("code_url");
            resp.getWriter().write(code_url);
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	
	//查看订单信息
	public void detail(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		// 获取订单编号
		String id = req.getParameter("id");
		
		// 查询订单信息
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from orders where id=?";
		Orders orders = qr.query(sql, new BeanHandler<>(Orders.class), id);
		
		// 查询订单明细信息
		sql = "select * from ordersitem where oid=?";
		List<OrdersItem> items = qr.query(sql, new BeanListHandler<>(OrdersItem.class), id);
		
		// 查询商品信息
		for (OrdersItem item : items) {
			sql = "select * from goods where id=" + item.getGid();
			Goods goods = qr.query(sql, new BeanHandler<>(Goods.class));
			item.setGoods(goods);
		}
		
		// 保存数据
		req.setAttribute("orders", orders);
		req.setAttribute("items", items);
		
		// 转发到jsp展示数据
		
		req.getRequestDispatcher("orders_detail.jsp").forward(req, resp);
		
	}
	
	
	//判断订单状态
	public void cancel(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		// 修改订单状态
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "update orders set status=4 where id=?";
		qr.update(sql, req.getParameter("id"));
		
		// 修改完成之后，重新查询订单信息
		resp.sendRedirect("orders?method=query");
	}
	
	//查看订单信息
	public void query(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		// 查询订单的代码...
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		// 由于用户id不是用户提交的数据，因此不存在SQL注入的风险，可以直接拼接
		String sql = "select * from orders where uid=" + user.getId();
		
		List<Orders> oList = qr.query(sql, new BeanListHandler<>(Orders.class));
		req.setAttribute("oList", oList);
		
		req.getRequestDispatcher("orders.jsp").forward(req, resp);
	}
	
/*	// 演示SQL注入的问题
	public static void main2(String[] args) {
		String username = "zhangsan";
		String password = "abc' or '1'='1";
		String sql = "select * from user where username='" + username + "' and password='" + password + "'";
		System.out.println(sql);
	}*/
	
	// 提交订单功能
	public void submit(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		User user = (User)req.getSession().getAttribute("loginUser");
		// 如果没有登录，则强制性跳转到登录页面
		if ( user == null ) {
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		// 获取收货人信息
		String sheng = req.getParameter("sheng");
		String shi = req.getParameter("shi");
		String xian = req.getParameter("xian");
		String dAddress = req.getParameter("dAddress");
		String name = req.getParameter("name");
		String tel = req.getParameter("tel");
		
		String address = sheng + shi + xian + " " 
		+ dAddress + " 姓名：" + name + " " + tel;
		
		// 生成随机32位订单号
		String id = UUID.randomUUID().toString().replace("-", "").toUpperCase();
		
		// 查询购物车数据，包含商品信息，计算总金额
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from cart where uid=?";
		// 在执行数据库操作时，手动给定一个链接对象
		List<Cart> cList = qr.query(sql, new BeanListHandler<>(Cart.class), user.getId());
		// 遍历集合，查询商品的详细信息
		// 查询当前用户的所有购买信息，但是不包含商品的详细信息，只有商品ID
		double totalprice = 0;
		for (Cart cart : cList) {
			sql = "select * from goods where id=?";
			Goods goods = qr.query(sql, new BeanHandler<>(Goods.class), cart.getGid());
			totalprice += cart.getBuynum() * goods.getEstoreprice();
			cart.setGoods(goods);
		}
		// 订单状态：1待付款  2已付款 3已过期   4已取消
		int status = 1;
		// 订单的生成时间
		Date createtime = new Date();
		/*
		 * 事务：把多张表的更新操作视为不可再分的原子，
		 * 保证这些操作要么全部成功，要么全部失败！
		 * 
		 * 在进行事务处理的时候，需要注意4个细节：
		 * 1、开启事务：将事务的提交改为手动提交
		 * 2、当发生异常时，需要对事物进行“回滚”操作
		 * 	  需要在try catch finally块的catch中进行事务的回滚
		 * 	  在catch中捕获的异常类型为顶级异常，保证所有的异常
		 * 	  都能够被捕捉到
		 * 3、在try catch finally块的finally中对事务进行提交
		 * 4、事务的操作必须使用同一条链接对象来完成，
		 * 	原因是提交事务、回滚事务都是通过链接对象来完成的
		 *  如果是不同的链接完成不同的操作，就无法保证操作的原子性了
		 * 
		 * 另外：
		 * 在进行事务处理的时候，创建QueryRunner对象时，不可以指定数据源(连接池对象)
		 * 原因是在进行数据库操作时，会从连接池中随机抓取一条链接，
		 * 从而无法保证事务使用的是同一个链接对象
		 */
		QueryRunner qr2 = new QueryRunner();
		// 获取连接对象
		Connection conn = JDBCUtils.getConnection();
		// 把需要视作“原子”的操作都放在try中
		try {
			// 1、开启事务：设置自动提交为false
			conn.setAutoCommit(false);
			//在try执行数据库相关操作
			// 向订单表中插入记录
			sql = "insert into orders values(?,?,?,?,?,?)";
			qr2.update(conn, sql, id, user.getId(), totalprice, address, status, createtime);
			
			//System.out.println(1/0);
			
			// 向订单明细表中插入多条记录
			for (Cart cart : cList) {
				Goods goods = cart.getGoods();
				sql = "insert into ordersitem values(?,?,?)";
				qr2.update(conn, sql, id, cart.getGid(), cart.getBuynum());
			}
			
			// 清空购物车表中的数据
			sql = "delete from cart where uid=?";
			qr2.update(conn, sql, user.getId());
			
			// 跳转到查询订单的Servlet
			resp.sendRedirect("orders?method=query");
		} catch (Exception e) {
			// 2、程序出现异常，需要进行事务的回滚
			conn.rollback();
		} finally {
			// 3、提交事务
			conn.commit();
		}
	}
	
	//加载省市县 信息
	public void loadSSX(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		// 获取区域的父区域编号
		String pid = req.getParameter("pid");
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "SELECT * FROM `province_city_district` WHERE pid=?";
		List<Map<String, Object>> list = qr.query(sql, new MapListHandler(), pid);
		// 将数据转换为json
		Gson gson = new Gson();
		String json = gson.toJson(list);
		resp.getWriter().write(json);
	}
}
