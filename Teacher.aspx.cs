using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace IADLAB08_QuizApplication
{
    public partial class Teacher : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["QuizDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Teacher")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                lblWelcome.Text = "Welcome Teacher: " + Session["Username"].ToString();
                LoadQuestions();
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
        protected void ddlSubject_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuestions();
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (txtQuestion.Text.Trim() == "" ||
                txtOptionA.Text.Trim() == "" ||
                txtOptionB.Text.Trim() == "" ||
                txtOptionC.Text.Trim() == "" ||
                txtOptionD.Text.Trim() == "")
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please fill all fields before adding question.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Questions
                                (QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Subject, DifficultyLevel)
                                VALUES
                                (@QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption, @Subject, @DifficultyLevel)";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@QuestionText", txtQuestion.Text.Trim());
                cmd.Parameters.AddWithValue("@OptionA", txtOptionA.Text.Trim());
                cmd.Parameters.AddWithValue("@OptionB", txtOptionB.Text.Trim());
                cmd.Parameters.AddWithValue("@OptionC", txtOptionC.Text.Trim());
                cmd.Parameters.AddWithValue("@OptionD", txtOptionD.Text.Trim());
                cmd.Parameters.AddWithValue("@CorrectOption", ddlCorrectOption.SelectedValue);
                cmd.Parameters.AddWithValue("@Subject", ddlSubject.SelectedValue);
                cmd.Parameters.AddWithValue("@DifficultyLevel", ddlDifficulty.SelectedValue);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Question added successfully!";

            ClearFields();
            LoadQuestions();
        }

        private void LoadQuestions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DifficultyLevel
                                 FROM Questions
                                 WHERE Subject = @Subject
                                 ORDER BY QuestionID DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Subject", ddlSubject.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvQuestions.DataSource = dt;
                gvQuestions.DataBind();
            }
        }

        protected void gvQuestions_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int questionID = Convert.ToInt32(gvQuestions.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Questions WHERE QuestionID = @QuestionID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Question deleted successfully!";
            LoadQuestions();
        }

        private void ClearFields()
        {
            txtQuestion.Text = "";
            txtOptionA.Text = "";
            txtOptionB.Text = "";
            txtOptionC.Text = "";
            txtOptionD.Text = "";
            ddlCorrectOption.SelectedIndex = 0;
            ddlDifficulty.SelectedIndex = 0;
        }
    }
}