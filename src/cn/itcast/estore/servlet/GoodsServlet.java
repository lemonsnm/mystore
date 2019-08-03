package cn.itcast.estore.servlet;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import com.google.gson.Gson;

import cn.itcast.estore.entity.Category;
import cn.itcast.estore.entity.Comment;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/goods")
// goods?method=queryById
public class GoodsServlet extends BaseServlet {
	

	//查看某个商品的详细信息（评论信息）
	public void queryById(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		// 获取要查询的商品的id
		String id = req.getParameter("id");
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		//查询商品的详细信息
		String sql = "select * from goods where id=?";
		Goods goods = qr.query(sql, new BeanHandler<>(Goods.class), id);
		//查询商品的所有评论 按照评论时间降序
		 sql = "select * from comment where gid=? order by createtime desc";
		List<Comment> commentsList = qr.query(sql, new BeanListHandler<>(Comment.class), id);
		System.out.println(commentsList);
		
		//给每个评论加入用户昵称
		for (Comment comment : commentsList) {
			 sql = "select * from user where id=?";
			 User user = qr.query(sql, new BeanHandler<>(User.class), comment.getUid());
			 comment.setNickname(user.getNickname());
		}
		
		// 保存商品详细
		req.setAttribute("goods", goods);
		//保存商品评论信息
		req.setAttribute("commentsList", commentsList);
		 //数据并转发到jsp显示数据
		req.getRequestDispatcher("/goods_detail.jsp").forward(req, resp);
	}
	
	//模糊查询店铺
	public void query(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from goods where 1=1";
		
		String cid = req.getParameter("cid");
		List<Object> list = new ArrayList<>();
		if ( cid != null ) {
			sql += " and cid=? ";
			list.add(cid);
		}
		
		String name = req.getParameter("name");
		if ( name != null && !"".equals(name) ) {
			sql += " and name like ? ";
			list.add("%" + name + "%");
		}
		
		// 将集合转换为数组
		Object[] params = list.toArray();
		
		List<Goods> gList = qr.query(sql, 
			new BeanListHandler<>(Goods.class), params);
		// servlet负责查询出数据，页面的展示交给jsp来完成
		// 在跳转到jsp之前，需要先将数据保存到requst中
		req.setAttribute("gList", gList);
		req.getRequestDispatcher("/goods.jsp").forward(req, resp);
	}
	
	//查询店铺分类
	public void queryCategory(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from category";
		List<Category> cList = qr.query(sql, new BeanListHandler<>(Category.class));
		// 将java中的集合对象装换成特殊格式的字符串：json
		// Gson用于将对象、数组、集合、Map等装换成json字符串
		Gson gson = new Gson();
		String json = gson.toJson(cList);
		// 响应给浏览器
		resp.getWriter().write(json);
	}
	
	//查询店铺数量
		public void queryNum(HttpServletRequest req, HttpServletResponse resp) throws Exception {
			
			//获取登录用户信息
			User user = (User)req.getSession().getAttribute("loginUser");
			//如果没有登录，为0
			if(user == null){
				resp.getWriter().write("no");
			}else{
				QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
				String sql = "select * from cart where uid=?";
				List<Category> cList = qr.query(sql, new BeanListHandler<>(Category.class),user.getId());
				Integer length = cList.size(); 
				// 响应给浏览器
				resp.getWriter().write(length+"");
			}
			
		
		}
}
