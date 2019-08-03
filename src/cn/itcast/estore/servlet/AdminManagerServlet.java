package cn.itcast.estore.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.google.gson.Gson;

import cn.itcast.estore.entity.Cart;
import cn.itcast.estore.entity.Category;
import cn.itcast.estore.entity.Comment;
import cn.itcast.estore.entity.Favorite;
import cn.itcast.estore.entity.Goods;
import cn.itcast.estore.entity.User;
import cn.itcast.estore.utils.JDBCUtils;


@SuppressWarnings("all")
// 需要在路径前书写"/"，表示项目根目录
@WebServlet("/admin")
// admin?method=updateGoods
public class AdminManagerServlet extends BaseServlet {
	
	//更新商品
	public void doUpdate(HttpServletRequest request,  
            HttpServletResponse response) throws ServletException, IOException, SQLException { 
		
		//获取登录用户信息
		User admin = (User)request.getSession().getAttribute("AdminUser");
		//如果没有登录，没管理去登录
		if(admin == null){
			//重定向到登录页面
			response.sendRedirect("login.jsp");
			return ;
		}
		
		//上传的文件名
    	String fileN = null;
    	//随机生产的文件名
    	String resultName = null;
    	//保存表单信息
    	String goodsName= null;
    	String category= null;
    	String marketprice= null;
    	String estoreprice= null;
    	String num= null;
    	String imageUrl= "addImages/timg.jpg";//默认图片
    	String content = null;
    	request.setCharacterEncoding("utf-8");  
        response.setCharacterEncoding("utf-8");  
        //1、创建一个DiskFileItemFactory工厂  
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        //2、创建一个文件上传解析器  
        ServletFileUpload upload = new ServletFileUpload(factory);  
        //解决上传文件名的中文乱码  
        upload.setHeaderEncoding("UTF-8");   
        factory.setSizeThreshold(1024 * 500);//设置内存的临界值为500K  
        File ceshi = new File("F:\\ceshi");//当超过500K的时候，存到一个临时文件夹中  
        factory.setRepository(ceshi);  
        upload.setSizeMax(1024 * 1024 * 500);//设置上传的文件总的大小不能超过500M  
        try {  
            // 1. 得到 FileItem 的集合 items  
            List<FileItem> /* FileItem */items = upload.parseRequest(request);  
  
            // 2. 遍历 items:  
            for (FileItem item : items) {  
                // 若是一个一般的表单域, 打印信息  
                if (item.isFormField()) {  
                    String name = item.getFieldName();
                    if((name +"").equals("goodsName")){
                    	goodsName = item.getString("utf-8");
                    }
                    if((name +"").equals("category")){
                    	category = item.getString("utf-8");
                    }
                    if((name +"").equals("marketprice")){
                    	marketprice = item.getString("utf-8");
                    }
                    if((name +"").equals("estoreprice")){
                    	estoreprice = item.getString("utf-8");
                    }
                    if((name +"").equals("num")){
                    	num = item.getString("utf-8");
                    }
                    if((name +"").equals("content")){
                    	content = item.getString("utf-8");
                    }
                      
                      
                }  
                // 若是文件域则把文件保存到 E:\project\mysetore\WebContent\addImages 目录下.  
                else {  
                    fileN = item.getName();  //获取上传文件名
                 /*   System.out.println("文件名"+fileN);*/
                    long sizeInBytes = item.getSize();  
  
                    InputStream in = item.getInputStream();  
                    byte[] buffer = new byte[1024];  
                    int len = 0;  
                    
                    //生成随机文件名
                    Date date = new Date(); 
                    SimpleDateFormat format = new SimpleDateFormat("yyyyMMSSHHmmss");
                    resultName = format.format(date);
                    //保存文件路径
                    String fileName = "E:\\project\\mysetore\\WebContent\\addImages\\" +resultName+fileN;//文件最终上传的位置  
                    OutputStream out = new FileOutputStream(fileName);  
  
                    while ((len = in.read(buffer)) != -1) {  
                        out.write(buffer, 0, len);  
                    }  
  
                    out.close();  
                    in.close();  
                    System.out.println("上传完成");
                    
                }  
            }  
  
        } catch (FileUploadException e) {  
            e.printStackTrace();  
        }  
       /* System.out.println("长度" + (fileN+"").length());*/
        //上传文件了
        if((fileN+"").length() != 0){
        	//图片路径
            imageUrl = "addImages/" + resultName + fileN;
        }
        
        System.out.println(goodsName);
        System.out.println(category);
        System.out.println(marketprice);
        System.out.println(estoreprice);
        System.out.println(num);
        System.out.println(imageUrl);
        System.out.println(content);
        
       //读取id
        String id = request.getParameter("id");
        //更新goods表
        QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
        String sql = "update goods set cid=?,name=?,marketprice=?,estoreprice=?,"
        		+ "num=?,imgurl=?, description=? where id=?";
        qr.update(sql, category, goodsName, marketprice,estoreprice,num,imageUrl,content,id);
       
        //重定向到商品详情页
         response.sendRedirect("goods?method=queryById&id="+id);
	}
	
	
	
	//修改查看某个商品信息
	 public void updateGoods(HttpServletRequest request,  
	            HttpServletResponse response) throws ServletException, IOException, SQLException { 
			 
		//获取登录用户信息
			User user = (User)request.getSession().getAttribute("loginUser");
			//获取登录用户信息
			User admin = (User)request.getSession().getAttribute("AdminUser");
			//如果没有登录，没管理去登录
			if(user == null || admin == null){
				//重定向到登录页面
				response.sendRedirect("login.jsp");
				return ;
			}
			//获取id
			String id = request.getParameter("id");
		//读取当前商品信息
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "select * from goods where id =?";
			Goods goods = qr.query(sql, new BeanHandler<>(Goods.class),id);
			//保存商品信息
			request.setAttribute("goods", goods);	
		//转发	
		request.getRequestDispatcher("updateGoods.jsp").forward(request, response);
	 }
	
	//新增商品
    public void addGoods(HttpServletRequest request,  
            HttpServletResponse response) throws ServletException, IOException { 
    	
    	//获取登录用户信息
    			User user = (User)request.getSession().getAttribute("loginUser");
    			//获取登录用户信息
    			User admin = (User)request.getSession().getAttribute("AdminUser");
    			//如果没有登录，去登录
    			if(user == null || admin == null){
    				//重定向到登录页面
    				response.sendRedirect("login.jsp");
    				return ;
    			}
    	//上传的文件名
    	String fileN = null;
    	//随机生产的文件名
    	String resultName = null;
    	//保存表单信息
    	String goodsName= null;
    	String category= null;
    	String marketprice= null;
    	String estoreprice= null;
    	String num= null;
    	String imageUrl= "addImages/timg.jpg";//默认图片
    	String content = null;
    	request.setCharacterEncoding("utf-8");  
        response.setCharacterEncoding("utf-8");  
        //1、创建一个DiskFileItemFactory工厂  
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        //2、创建一个文件上传解析器  
        ServletFileUpload upload = new ServletFileUpload(factory);  
        //解决上传文件名的中文乱码  
        upload.setHeaderEncoding("UTF-8");   
        factory.setSizeThreshold(1024 * 500);//设置内存的临界值为500K  
        File ceshi = new File("F:\\ceshi");//当超过500K的时候，存到一个临时文件夹中  
        factory.setRepository(ceshi);  
        upload.setSizeMax(1024 * 1024 * 500);//设置上传的文件总的大小不能超过500M  
        try {  
            // 1. 得到 FileItem 的集合 items  
            List<FileItem> /* FileItem */items = upload.parseRequest(request);  
  
            // 2. 遍历 items:  
            for (FileItem item : items) {  
                // 若是一个一般的表单域, 打印信息  
                if (item.isFormField()) {  
                    String name = item.getFieldName();
                    if((name +"").equals("goodsName")){
                    	goodsName = item.getString("utf-8");
                    }
                    if((name +"").equals("category")){
                    	category = item.getString("utf-8");
                    }
                    if((name +"").equals("marketprice")){
                    	marketprice = item.getString("utf-8");
                    }
                    if((name +"").equals("estoreprice")){
                    	estoreprice = item.getString("utf-8");
                    }
                    if((name +"").equals("num")){
                    	num = item.getString("utf-8");
                    }
                    if((name +"").equals("content")){
                    	content = item.getString("utf-8");
                    }
                      
                      
                }  
                // 若是文件域则把文件保存到 E:\project\mysetore\WebContent\addImages 目录下.  
                else {  
                    fileN = item.getName();  //获取上传文件名
                 /*   System.out.println("文件名"+fileN);*/
                    long sizeInBytes = item.getSize();  
  
                    InputStream in = item.getInputStream();  
                    byte[] buffer = new byte[1024];  
                    int len = 0;  
                    
                    //生成随机文件名
                    Date date = new Date(); 
                    SimpleDateFormat format = new SimpleDateFormat("yyyyMMSSHHmmss");
                    resultName = format.format(date);
                    //保存文件路径
                    String fileName = "E:\\project\\mysetore\\WebContent\\addImages\\" +resultName+fileN;//文件最终上传的位置  
                    OutputStream out = new FileOutputStream(fileName);  
  
                    while ((len = in.read(buffer)) != -1) {  
                        out.write(buffer, 0, len);  
                    }  
  
                    out.close();  
                    in.close();  
                    System.out.println("上传完成");
                    
                }  
            }  
  
        } catch (FileUploadException e) {  
            e.printStackTrace();  
        }  
       /* System.out.println("长度" + (fileN+"").length());*/
        //上传文件了
        if((fileN+"").length() != 0){
        	//图片路径
            imageUrl = "addImages/" + resultName + fileN;
        }
        
       /* System.out.println(goodsName);
        System.out.println(category);
        System.out.println(marketprice);
        System.out.println(estoreprice);
        System.out.println(num);
        System.out.println(imageUrl);
        System.out.println(content);*/
        //导入goods表
        QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
        String sql = "insert into goods values(?,?,?,?,?,?,?,?,?,?,?)";
        try {
			qr.update(sql,
				null,category,goodsName,marketprice,estoreprice,
				num,imageUrl,0,1,new Date(),content);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        //重定向到管理页面 admin?method=query
        response.sendRedirect("addormanager.jsp");
    }  



	
	//加载商品类别 信息
		public void loadCategory(HttpServletRequest req, HttpServletResponse resp) throws Exception {
			//查找商品类别信息
			QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
			String sql = "SELECT * FROM `category`";
			List<Map<String, Object>> list = qr.query(sql, new MapListHandler());
			// 将数据转换为json
			Gson gson = new Gson();
			String json = gson.toJson(list);
			resp.getWriter().write(json);
		}
	
	
	//添加 修改商品页面
	public void addAndUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {

		//获取登录用户信息
		User user = (User)req.getSession().getAttribute("loginUser");
		//获取登录用户信息
		User admin = (User)req.getSession().getAttribute("AdminUser");
		//如果没有登录，去登录
		if(user == null || admin == null){
			//重定向到登录页面
			resp.sendRedirect("login.jsp");
			return ;
		}
		
			req.getRequestDispatcher("addGoods.jsp").forward(req, resp);
	}
	
	//查询所有商品信息
	public void query(HttpServletRequest req, HttpServletResponse resp) throws Exception {

		//获取登录用户信息
		User user = (User)req.getSession().getAttribute("loginUser");
		//如果没有登录，去登录
		if(user == null){
			//重定向到登录页面
			resp.sendRedirect("login.jsp");
			return ;
		}
		
		//如果登录了 查询当前所有商品
		QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
		String sql = "select * from goods order by createtime desc";
		// 查询当前用户的所有购买信息，但是不包含商品的详细信息，只有商品ID
		List<Goods> gList = qr.query(sql, new BeanListHandler<>(Goods.class));
		
		// 将集合保存到request中，然后转发到favorite.jsp展示数据
		//这里发送数据到页面 需要转发：
		//先保存
		req.setAttribute("gList", gList);
		//再转发
		req.getRequestDispatcher("adminManager.jsp").forward(req, resp);
		
	}
	

				//删除商品
			public void delAjax(HttpServletRequest req, HttpServletResponse resp) throws Exception {
				User user = (User)req.getSession().getAttribute("loginUser");
				//获取商品id
				String id = req.getParameter("id");
				System.out.println(id);
				// 如果没有登录，则强制性跳转到登录页面
				if ( user == null ) {
					// 如果请求的方式为ajax，则不能使用重定向
					// 因为重定向的页面中的内容会作为ajax的响应结果
					// 并不会发生我们预期的跳转动作
					//resp.sendRedirect("login.jsp");
					
					// 可以响应一个表示未登陆的字符串，例如："unlogin"
					resp.getWriter().write("unlogin");
					return ;
				}
			
				System.out.println(id);
				QueryRunner qr = new QueryRunner(JDBCUtils.getDataSource());
				//删除喜爱
				String sql = "delete from favorite where gid=?";
				qr.update(sql,id);
				//删除评论
				 sql = "delete from comment where gid=?";	
				 qr.update(sql,id);
				 //删除商品
				 sql = "delete from goods where id=?";	
				qr.update(sql,id);
				//响应一个表示登陆的字符串，例如："ok"
				resp.getWriter().write("ok");
			}
		 
}
