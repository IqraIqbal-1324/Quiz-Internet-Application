using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace IADLAB08_QuizApplication
{
    public partial class Admin : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["QuizDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                lblWelcome.Text = "Welcome Admin: " + Session["Username"].ToString();

                LoadUsers();
                LoadResults();
                LoadStudentsDropdown();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            if (txtUsername.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please enter username and password.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string checkQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());

                int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (count > 0)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Username already exists.";
                    return;
                }

                string insertQuery = @"INSERT INTO Users (Username, Password, Role)
                                       VALUES (@Username, @Password, @Role)";

                SqlCommand cmd = new SqlCommand(insertQuery, conn);
                cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                cmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);

                cmd.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = ddlRole.SelectedValue + " added successfully.";

            txtUsername.Text = "";
            txtPassword.Text = "";

            LoadUsers();
            LoadStudentsDropdown();
        }

        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT UserID, Username, Role
                                 FROM Users
                                 WHERE Role IN ('Teacher', 'Student')
                                 ORDER BY Role, Username";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        protected void gvUsers_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int userID = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string deleteAnswers = "DELETE FROM Answers WHERE StudentID = @UserID";
                SqlCommand cmdAnswers = new SqlCommand(deleteAnswers, conn);
                cmdAnswers.Parameters.AddWithValue("@UserID", userID);
                cmdAnswers.ExecuteNonQuery();

                string deleteResults = "DELETE FROM Results WHERE StudentID = @UserID";
                SqlCommand cmdResults = new SqlCommand(deleteResults, conn);
                cmdResults.Parameters.AddWithValue("@UserID", userID);
                cmdResults.ExecuteNonQuery();

                string deleteQuestions = "DELETE FROM Questions WHERE TeacherID = @UserID";
                SqlCommand cmdQuestions = new SqlCommand(deleteQuestions, conn);
                cmdQuestions.Parameters.AddWithValue("@UserID", userID);
                cmdQuestions.ExecuteNonQuery();

                string deleteUser = "DELETE FROM Users WHERE UserID = @UserID AND Role IN ('Teacher', 'Student')";
                SqlCommand cmdUser = new SqlCommand(deleteUser, conn);
                cmdUser.Parameters.AddWithValue("@UserID", userID);
                cmdUser.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "User deleted successfully.";

            LoadUsers();
            LoadResults();
            LoadStudentsDropdown();
        }

        private void LoadResults()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT u.Username, q.Title, r.Score, r.TotalMarks, r.AttemptDate
                    FROM Results r
                    JOIN Users u ON r.StudentID = u.UserID
                    JOIN Quiz q ON r.QuizID = q.QuizID
                    ORDER BY r.AttemptDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvResults.DataSource = dt;
                gvResults.DataBind();
            }
        }

        private void LoadStudentsDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT UserID, Username FROM Users WHERE Role = 'Student' ORDER BY Username";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlStudents.DataSource = dt;
                ddlStudents.DataTextField = "Username";
                ddlStudents.DataValueField = "UserID";
                ddlStudents.DataBind();
            }

            if (ddlStudents.Items.Count > 0)
            {
                LoadStudentStats();
            }
            else
            {
                lblStudentStats.Text = "No students found.";
                gvStudentStats.DataSource = null;
                gvStudentStats.DataBind();
            }
        }

        protected void ddlStudents_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStudentStats();
        }

        private void LoadStudentStats()
        {
            int studentID = Convert.ToInt32(ddlStudents.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT q.Title, r.Score, r.TotalMarks, r.AttemptDate
                    FROM Results r
                    JOIN Quiz q ON r.QuizID = q.QuizID
                    WHERE r.StudentID = @StudentID
                    ORDER BY r.AttemptDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentID", studentID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvStudentStats.DataSource = dt;
                gvStudentStats.DataBind();

                int attempts = dt.Rows.Count;
                int totalScore = 0;
                int totalMarks = 0;

                foreach (DataRow row in dt.Rows)
                {
                    totalScore += Convert.ToInt32(row["Score"]);
                    totalMarks += Convert.ToInt32(row["TotalMarks"]);
                }

                lblStudentStats.Text =
                    "Total Attempts: " + attempts +
                    " | Total Score: " + totalScore +
                    " / " + totalMarks;
            }
        }
    }
}