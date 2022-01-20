package bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class MemberMgr {

	private DBConnectionMgr pool;
	
	public MemberMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public boolean checkId(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT id FROM tblMember WHERE id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			flag = rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return flag;
	}//public boolean checkId(String id)
	
	public Vector<ZipcodeBean> zipcodeRead(String area3){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<ZipcodeBean> vlist = new Vector<ZipcodeBean>();
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT * FROM tblzipcode WHERE area3 LIKE ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%"+ area3 +"%");
			rs = pstmt.executeQuery();

			while(rs.next()) {
				ZipcodeBean bean = new ZipcodeBean();
				bean.setZipcode(rs.getString("zipcode"));
				bean.setArea1(rs.getString("area1"));
				bean.setArea2(rs.getString("area2"));
				bean.setArea3(rs.getString("area3"));
				vlist.addElement(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}//public Vector<ZipcodeBean> zipcodeRead(String area3)
	
	public boolean insertMember(MemberBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			
			String sql = "INSERT INTO tblMember(id, pwd, name, gender, email, "
					+ "birthday, zipcode, address, hobby, job) "
					+ "VALUES(?,?,?,?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getId());
			pstmt.setString(2, bean.getPwd());
			pstmt.setString(3, bean.getName());
			pstmt.setString(4, bean.getGender());
			pstmt.setString(5, bean.getEmail());
			pstmt.setString(6, bean.getBirthday());
			pstmt.setString(7, bean.getZipcode());
			pstmt.setString(8, bean.getAddress());
			
			String[] hobby = bean.getHobby();
			char[] hb = {'0', '0', '0', '0', '0'};
			String[] lists = {"인터넷", "여행", "게임", "영화", "운동"};
			for(int i=0; i<hobby.length; i++) {
				for(int j=0; j<lists.length; j++) {
					if(hobby[i].equals(lists[j])) {
						hb[j] = '1';
					}
				}
			}
			pstmt.setString(9, new String(hb));
			
			pstmt.setString(10, bean.getJob());
			
			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return flag;
	}//public boolean insertMember(MemberBean bean)
	
	public boolean loginMember(String id, String pwd) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean loginCon = false;
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT COUNT(*) FROM tblMember WHERE id=? AND pwd=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pwd);
			rs = pstmt.executeQuery();
			
			if(rs.next() && rs.getInt(1) > 0)
				loginCon = true;
			
		} catch (Exception e) {
			System.out.println("Exception : "+ e);
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return loginCon;
	}//public boolean loginMember(String id, String pwd)
	
	public String getName(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String name = null;
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT name FROM tblMember WHERE id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next())
				name = rs.getString("name");
			
		} catch (Exception e) {
			System.out.println("Exception : "+ e);
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return name;
	}//public String getName(String id)
	
	public MemberBean getMember(String id) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberBean bean = new MemberBean();
		
		try {
			con = pool.getConnection();
			
			String sql = "SELECT * FROM tblMember WHERE id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setId(rs.getString("id"));
				bean.setPwd(rs.getString("pwd"));
				bean.setName(rs.getString("name"));
				bean.setGender(rs.getString("gender"));
				bean.setEmail(rs.getString("email"));
				bean.setBirthday(rs.getString("birthday"));
				bean.setZipcode(rs.getString("zipcode"));
				bean.setAddress(rs.getString("address"));
				
				String[] hobbys = new String[5];
				String hobby = rs.getString("hobby");
				for(int i=0; i<hobbys.length; i++) {
					hobbys[i] = hobby.substring(i, i + 1);
				}
				bean.setHobby(hobbys);
				
				bean.setJob(rs.getString("job"));
			}
		} catch (Exception e) {
			System.out.println("Exception : "+ e);
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return bean;
	}//public MemberBean getMember(String id)
	
	public boolean updateMember(MemberBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		boolean flag = false;
		
		try {
			con = pool.getConnection();
			
			String sql = "UPDATE tblMember SET "
					+ "pwd = ?, name = ?, gender = ?, email = ?, birthday = ?, "
					+ "zipcode = ?, address = ?, hobby = ?, job = ? "
					+ "WHERE id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getPwd());
			pstmt.setString(2, bean.getName());
			pstmt.setString(3, bean.getGender());
			pstmt.setString(4, bean.getEmail());
			pstmt.setString(5, bean.getBirthday());
			pstmt.setString(6, bean.getZipcode());
			pstmt.setString(7, bean.getAddress());
			
			String[] hobby = bean.getHobby();
			char[] hb = {'0', '0', '0', '0', '0'};
			String[] lists = {"인터넷", "여행", "게임", "영화", "운동"};
			for(int i=0; i<hobby.length; i++) {
				for(int j=0; j<lists.length; j++) {
					if(hobby[i].equals(lists[j])) {
						hb[j] = '1';
					}
				}
			}
			pstmt.setString(8, new String(hb));
			
			pstmt.setString(9, bean.getJob());
			pstmt.setString(10, bean.getId());
			
			if(pstmt.executeUpdate() == 1) {
				flag = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return flag;
	}//public boolean updateMember(MemberBean bean)
}//public class MemberMgr
