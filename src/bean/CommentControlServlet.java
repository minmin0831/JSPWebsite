package bean;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CommentControlServlet
 */
@WebServlet("/CommentControl")
public class CommentControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		CommentMgr cMgr = new CommentMgr();
		String mode = request.getParameter("mode");
		if(mode.equals("insert")) cMgr.insertComment(request);
		if(mode.equals("update")) cMgr.updateComment(request);
		if(mode.equals("delete")) cMgr.deleteComment(request);
		
		String url = "index.jsp?" + request.getParameter("url");
		response.sendRedirect(url);
	}
}
