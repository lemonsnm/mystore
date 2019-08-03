package cn.itcast.estore.entity;

/**
 * 商品明细
 * @author lemonSun
 *
 * 2019年6月13日下午4:42:27
 */
public class OrdersItem {
	private String oid;
	private Integer gid;
	private Integer buynum;
	
	private Goods goods;

	public Goods getGoods() {
		return goods;
	}

	public void setGoods(Goods goods) {
		this.goods = goods;
	}

	public OrdersItem() {
		super();
	}

	public OrdersItem(String oid, Integer gid, Integer buynum) {
		super();
		this.oid = oid;
		this.gid = gid;
		this.buynum = buynum;
	}

	public String getOid() {
		return oid;
	}

	public void setOid(String oid) {
		this.oid = oid;
	}

	public Integer getGid() {
		return gid;
	}

	public void setGid(Integer gid) {
		this.gid = gid;
	}

	public Integer getBuynum() {
		return buynum;
	}

	public void setBuynum(Integer buynum) {
		this.buynum = buynum;
	}

	@Override
	public String toString() {
		return "OrdersItem [oid=" + oid + ", gid=" + gid + ", buynum=" + buynum
				+ ", goods=" + goods + "]";
	}
}
