//TESTING

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddMovie
 */
@WebServlet("/AddMovie")
public class AddMovie extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddMovie() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
        response.getWriter().println("<link rel='stylesheet' href='/project2/styles.css' type='text/css' media='all'/>");  
        
        String loginUser = "root";
        String loginPasswd = "MySQLPassword123";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&useSSL=false";
        String title = request.getParameter("title");
        String year = request.getParameter("year");
        String director = request.getParameter("director");
        String star = request.getParameter("star");
        String genre = request.getParameter("genre");
        
        if (title.equals("") || year.equals("") || director.equals("") ||
        		star.equals("") || genre.equals(""))
        {
        	response.getWriter().println("<script type=\"text/javascript\">");
     	   	response.getWriter().println("alert('All fields must be filled, please try again.');");
     	   	response.getWriter().println("location='addmovie.html';");
     	   	response.getWriter().println("</script>");
     	   	return;
        }
        
        if (!year.matches("[0-9]+") || Integer.valueOf(year) < 1500 || Integer.valueOf(year) > 2018)
        {
     	   	response.getWriter().println("<script type=\"text/javascript\">");
        		response.getWriter().println("alert('Year must be a year that is greater than or equal to 1500 or less than 2018, please try again.');");
     	   	response.getWriter().println("location='addmovie.html';");
     	   	response.getWriter().println("</script>");
     	   	return;
        }
        
        if (!director.matches("[a-zA-Z ]+") || !star.matches("[a-zA-Z ]+") || !genre.matches("[a-zA-Z ]+"))
    	{
    	   response.getWriter().println("<script type=\"text/javascript\">");
    	   response.getWriter().println("alert('Must type in a valid name of a director, star, and genre, please try again.');");
    	   response.getWriter().println("location='addmovie.html';");
    	   response.getWriter().println("</script>");
    	   return;
    	}
        
        try
        {
        	 Class.forName("com.mysql.jdbc.Driver").newInstance();
             Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
             CallableStatement cs = dbcon.prepareCall("{call add_movie (?,?,?,?,?)}");

             cs.setString(1, title);
             cs.setString(2, year);
             cs.setString(3, director);
             cs.setString(4, star);
             cs.setString(5, genre);
             
             cs.executeUpdate();
             
 	         response.getWriter().println("<div style=\"text-align:center\">");
             response.getWriter().println("<H1 style = 'text-align: center; color: white'>The following entry has been added to the database:</H1>");
             PreparedStatement statement = dbcon.prepareStatement("SELECT * FROM movies WHERE title = ? and year = ? and director = ?");
             statement.setString(1, title);
             statement.setString(2, year);
             statement.setString(3, director);
             ResultSet rs = statement.executeQuery();
             response.getWriter().println("<TABLE border align = 'center'>");
             response.getWriter().println("<tr>" + "<td>" + "Title" + "</td>" + "<td>" + "Year"
 	        		+ "</td>" + "<td>" + "Director" + "</td>" + "<td>" + "ID" + "</td>" + "<td>" 
            		 + "Star" + "</td>" + "<td>" + "Genre" + "</td>" + "</tr>");
             
             while (rs.next())
             {
            	 response.getWriter().println("<tr>" + "<td>" + rs.getString("title") + "</td>" + "<td>" + rs.getString("year")
            			 					+ "</td>" + "<td>" + rs.getString("director") + "</td>" + "<td>" + rs.getString("id")
            			 					+ "</td>");
             }
             
             response.getWriter().println("<td>" + star + "</td>" + "<td>" + genre + "</td>" + "</tr>");
             
             response.getWriter().println("</TABLE border>");
             
 	         response.getWriter().println("</div>");
 	        response.getWriter().println("<a href='employeeMain.html' title='EmployeeMain'>"
               		+ "<button style='height:35px;width:100px;position:relative;float: right;bottom:0px;right:0px;z-index:999'>Back to Main Page</button>"
               		+ "</a>");

             
        }
        catch(Exception e)
        {
        	response.getWriter().println(e.getMessage());
        }
        
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
