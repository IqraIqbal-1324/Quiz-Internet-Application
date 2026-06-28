using System;
using System.Configuration;
using System.Data.SqlClient;

namespace IADLAB08_QuizApplication
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["QuizDBConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "SELECT UserID, Role FROM Users WHERE Username=@u AND Password=@p";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["UserID"] = dr["UserID"].ToString();
                    Session["Username"] = txtUsername.Text.Trim();
                    Session["Role"] = dr["Role"].ToString();

                    string userRole = Session["Role"].ToString();

                    if (userRole == "Admin")
                        Response.Redirect("Admin.aspx");
                    else if (userRole == "Teacher")
                        Response.Redirect("Teacher.aspx");
                    else if (userRole == "Student")
                        Response.Redirect("Student.aspx");
                }
                else
                {
                    lblMessage.Text = "Invalid Username or Password!";
                }
            }
        }
    }
}