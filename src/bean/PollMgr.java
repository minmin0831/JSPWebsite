package bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

public class PollMgr {
	private DBConnectionMgr pool;
	
	public PollMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public Vector<PollListBean> getAllList(){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<PollListBean> vlist = new Vector<PollListBean>();
		
		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM tblPollList ORDER BY num DESC";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				PollListBean bean = new PollListBean();
				bean.setNum(rs.getInt("num"));
				bean.setQuestion(rs.getString("question"));
				bean.setSdate(rs.getString("sdate"));
				bean.setEdate(rs.getString("edate"));
				//bean.setWdate(rs.getString("wdate"));
				//bean.setType(rs.getInt("type"));
				//bean.setActive(rs.getInt("active"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}//public Vector<PollListBean> getAllList()
	
	public Vector<String> getItem(int num){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<String> vlist = new Vector<String>();
		
		try {
			con = pool.getConnection();
			String sql = "SELECT item FROM tblPollItem "
					+ "WHERE listnum = ? ORDER BY itemnum";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				vlist.add(rs.getString("item"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}//public Vector<PollItemBean> getItem(int num)
	
	public PollListBean getList(int num){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PollListBean bean = new PollListBean();
		
		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM tblPollList WHERE num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				//bean.setNum(rs.getInt("num"));
				bean.setQuestion(rs.getString("question"));
				bean.setSdate(rs.getString("sdate"));
				bean.setEdate(rs.getString("edate"));
				//bean.setWdate(rs.getString("wdate"));
				bean.setType(rs.getInt("type"));
				//bean.setActive(rs.getInt("active"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return bean;
	}//public Vector<PollListBean> getList(int num)
	
	public int getMaxNum() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int listnum = 0;
		
		try {
			con = pool.getConnection();
			String sql = "SELECT MAX(num) FROM tblPollList";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				listnum = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return listnum;
	}//public int getMaxNum()
	
	public boolean insertPoll(PollListBean plBean, PollItemBean piBean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			String sql = "INSERT INTO tblPollList(question, sdate, edate, wdate, type) "
					+ "VALUES(?, ?, ?, now(), ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, plBean.getQuestion());
			pstmt.setString(2, plBean.getSdate());
			pstmt.setString(3, plBean.getEdate());
			pstmt.setInt(4, plBean.getType());
			int result = pstmt.executeUpdate();
			
			if(result == 1) {
				sql = "INSERT INTO tblPollItem VALUES(?, ?, ?, ?)";
				pstmt = con.prepareStatement(sql);
				
				int listnum = getMaxNum();
				
				String[] item = piBean.getItem();
				int itemCount = 0;
				for(int i=0; i<item.length; i++) {
					if(item[i] == null || item[i].equals("")) break;
					pstmt.setInt(1, listnum);
					pstmt.setInt(2, i);
					pstmt.setString(3, item[i]);
					pstmt.setInt(4, 0);
					pstmt.executeUpdate();
					itemCount ++;
				}
				
				if(itemCount > 0) flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return flag;
	}//public boolean insertPoll(PollListBean plBean, PollItemBean piBean)
	
	public int sumCount(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int sum = 0;
		
		try {
			con = pool.getConnection();
			String sql = "SELECT SUM(count) FROM tblpollitem WHERE listnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				sum = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return sum;
	}//public int sumCount(int num)
	
	public boolean updatePoll(int listnum, String[] itemnum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			String sql = "UPDATE tblPollItem SET count = count + 1 "
					+ "WHERE listnum = ? AND itemnum = ?";
			pstmt = con.prepareStatement(sql);
			
			for(int i=0; i<itemnum.length; i++) {
				pstmt.setInt(1, listnum);
				pstmt.setInt(2, Integer.parseInt(itemnum[i]));
				pstmt.executeUpdate();
			}
				
			if(itemnum.length > 0) flag = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return flag;
	}//public boolean updatePoll(int listnum, String[] itemnum)

	public Vector<PollItemBean> getView(int num){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<PollItemBean> vlist = new Vector<PollItemBean>();
		
		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM tblPollItem WHERE listnum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				PollItemBean bean = new PollItemBean();
				bean.setListnum(rs.getInt("listnum"));
				bean.setItemnum(rs.getInt("itemnum"));
				
				String[] item = new String[1];
				item[0] = rs.getString("item");
				bean.setItem(item);
				
				bean.setCount(rs.getInt("count"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}
}