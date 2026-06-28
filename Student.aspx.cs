using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace IADLAB08_QuizApplication
{
    public partial class Student : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["QuizDBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Student")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                lblWelcome.Text = "Welcome Student: " + Session["Username"].ToString();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            pnlResult.Visible = false;
            lblResult.Text = "";
            LoadQuestions();
        }

        private void LoadQuestions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT TOP 5 *
                                 FROM Questions
                                 WHERE Subject = @Subject
                                 ORDER BY NEWID()";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Subject", ddlSubject.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    pnlQuiz.Visible = false;
                    pnlResult.Visible = false;
                    lblResult.ForeColor = System.Drawing.Color.Red;
                    lblResult.Text = "No questions found for selected subject.";
                    return;
                }

                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();

                pnlQuiz.Visible = true;
                pnlResult.Visible = false;
                lblResult.Text = "";
                btnStartQuiz.Enabled = true;
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                RadioButtonList rblOptions = (RadioButtonList)e.Item.FindControl("rblOptions");

                HiddenField hfOptionA = (HiddenField)e.Item.FindControl("hfOptionA");
                HiddenField hfOptionB = (HiddenField)e.Item.FindControl("hfOptionB");
                HiddenField hfOptionC = (HiddenField)e.Item.FindControl("hfOptionC");
                HiddenField hfOptionD = (HiddenField)e.Item.FindControl("hfOptionD");

                rblOptions.Items.Add(new ListItem("A. " + hfOptionA.Value, "A"));
                rblOptions.Items.Add(new ListItem("B. " + hfOptionB.Value, "B"));
                rblOptions.Items.Add(new ListItem("C. " + hfOptionC.Value, "C"));
                rblOptions.Items.Add(new ListItem("D. " + hfOptionD.Value, "D"));
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int studentID = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection checkConn = new SqlConnection(connStr))
            {
                checkConn.Open();

                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE UserID = @UserID AND Role = 'Student'",
                    checkConn
                );

                checkCmd.Parameters.AddWithValue("@UserID", studentID);

                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (exists == 0)
                {
                    Session.Clear();
                    Response.Redirect("Login.aspx");
                    return;
                }
            }
            int score = 0;
            int correctCount = 0;
            int incorrectCount = 0;
            int totalMarks = rptQuestions.Items.Count;

            DataTable reviewTable = new DataTable();
            reviewTable.Columns.Add("QuestionText");
            reviewTable.Columns.Add("SelectedOption");
            reviewTable.Columns.Add("CorrectOption");
            reviewTable.Columns.Add("Status");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                int quizID = GetOrCreateQuizID(conn);
                string deleteOldAnswers = @"DELETE FROM Answers 
                            WHERE StudentID = @StudentID AND QuizID = @QuizID";

                SqlCommand deleteCmd = new SqlCommand(deleteOldAnswers, conn);
                deleteCmd.Parameters.AddWithValue("@StudentID", studentID);
                deleteCmd.Parameters.AddWithValue("@QuizID", quizID);
                deleteCmd.ExecuteNonQuery();

                foreach (RepeaterItem item in rptQuestions.Items)
                {
                    HiddenField hfQuestionID = (HiddenField)item.FindControl("hfQuestionID");
                    HiddenField hfCorrectOption = (HiddenField)item.FindControl("hfCorrectOption");
                    RadioButtonList rblOptions = (RadioButtonList)item.FindControl("rblOptions");

                    if (string.IsNullOrEmpty(rblOptions.SelectedValue))
                    {
                        lblResult.ForeColor = System.Drawing.Color.Red;
                        lblResult.Text = "Please attempt all questions before submitting.";
                        return;
                    }

                    int questionID = Convert.ToInt32(hfQuestionID.Value);
                    string correctOption = hfCorrectOption.Value;
                    string selectedOption = rblOptions.SelectedValue;
                    string questionText = GetQuestionText(conn, questionID);

                    int marksObtained = 0;
                    string status = "Incorrect";

                    if (selectedOption == correctOption)
                    {
                        marksObtained = 1;
                        score++;
                        correctCount++;
                        status = "Correct";
                    }
                    else
                    {
                        incorrectCount++;
                    }

                    string answerQuery = @"INSERT INTO Answers
                                           (StudentID, QuizID, QuestionID, SelectedOption, CorrectOption, MarksObtained)
                                           VALUES
                                           (@StudentID, @QuizID, @QuestionID, @SelectedOption, @CorrectOption, @MarksObtained)";

                    SqlCommand answerCmd = new SqlCommand(answerQuery, conn);
                    answerCmd.Parameters.AddWithValue("@StudentID", studentID);
                    answerCmd.Parameters.AddWithValue("@QuizID", quizID);
                    answerCmd.Parameters.AddWithValue("@QuestionID", questionID);
                    answerCmd.Parameters.AddWithValue("@SelectedOption", selectedOption);
                    answerCmd.Parameters.AddWithValue("@CorrectOption", correctOption);
                    answerCmd.Parameters.AddWithValue("@MarksObtained", marksObtained);
                    answerCmd.ExecuteNonQuery();

                    reviewTable.Rows.Add(questionText, selectedOption, correctOption, status);
                }

                string resultQuery = @"
                IF EXISTS (SELECT 1 FROM Results WHERE StudentID = @StudentID AND QuizID = @QuizID)
                BEGIN
                    UPDATE Results
                    SET Score = @Score,
                        TotalMarks = @TotalMarks,
                        AttemptDate = GETDATE()
                    WHERE StudentID = @StudentID AND QuizID = @QuizID
                END
                ELSE
                BEGIN
                    INSERT INTO Results
                    (StudentID, QuizID, Score, TotalMarks)
                    VALUES
                    (@StudentID, @QuizID, @Score, @TotalMarks)
                END";

                SqlCommand resultCmd = new SqlCommand(resultQuery, conn);
                resultCmd.Parameters.AddWithValue("@StudentID", studentID);
                resultCmd.Parameters.AddWithValue("@QuizID", quizID);
                resultCmd.Parameters.AddWithValue("@Score", score);
                resultCmd.Parameters.AddWithValue("@TotalMarks", totalMarks);
                resultCmd.ExecuteNonQuery();
            }

            lblResult.ForeColor = System.Drawing.Color.Green;
            lblResult.Text = "Quiz submitted successfully.";

            lblScoreDetails.Text =
                "Subject: " + ddlSubject.SelectedValue + "<br/>" +
                "Total Marks: " + totalMarks + "<br/>" +
                "Obtained Marks: " + score + "<br/>" +
                "Correct Answers: " + correctCount + "<br/>" +
                "Incorrect Answers: " + incorrectCount + "<br/>";

            gvReview.DataSource = reviewTable;
            gvReview.DataBind();

            pnlResult.Visible = true;
            pnlQuiz.Visible = false;
            btnStartQuiz.Enabled = true;
        }

        private int GetOrCreateQuizID(SqlConnection conn)
        {
            string selectQuery = "SELECT TOP 1 QuizID FROM Quiz WHERE Title = @Title ORDER BY QuizID DESC";

            SqlCommand selectCmd = new SqlCommand(selectQuery, conn);
            selectCmd.Parameters.AddWithValue("@Title", ddlSubject.SelectedValue + " Quiz");

            object result = selectCmd.ExecuteScalar();

            if (result != null)
            {
                return Convert.ToInt32(result);
            }

            string insertQuery = @"INSERT INTO Quiz
                                   (Title, TotalQuestions, TotalMarks, Duration, StartTime, ShuffleQuestions, ShuffleOptions, AttemptOnlyOnce, AllowReview, CreatedBy)
                                   OUTPUT INSERTED.QuizID
                                   VALUES
                                   (@Title, 5, 5, 30, GETDATE(), 1, 1, 1, 1, 2)";

            SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
            insertCmd.Parameters.AddWithValue("@Title", ddlSubject.SelectedValue + " Quiz");

            return Convert.ToInt32(insertCmd.ExecuteScalar());
        }

        private string GetQuestionText(SqlConnection conn, int questionID)
        {
            string query = "SELECT QuestionText FROM Questions WHERE QuestionID = @QuestionID";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@QuestionID", questionID);

            object result = cmd.ExecuteScalar();

            if (result == null)
                return "";

            return result.ToString();
        }
    }
}