package cn.itcast.estore.utils;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public class JDBCUtils {
	private static final ComboPooledDataSource DATA_SOURCE = new ComboPooledDataSource();
	private static final ThreadLocal<Connection> TL = new ThreadLocal<Connection>();
	
	// 获取数据源
	public static DataSource getDataSource() {
		return DATA_SOURCE;
	}

	// 获取连接
	public static Connection getConnection() throws SQLException {
		Connection conn = null;
		try {
			conn = TL.get();
			if (conn == null) {
				conn = DATA_SOURCE.getConnection();
				TL.set(conn);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(conn);
		return conn;
	}
	public static void main(String[] args) throws SQLException {
		getConnection();
	}
}
