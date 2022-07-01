using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;

namespace KuulEatsWebAppDotNet
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { 
                 ReservationElectedDate.Value = Convert.ToDateTime(DateTime.Now).ToString();
                 NewOrderRefHiddenField.Value = Guid.NewGuid().ToString();
                if (Request.QueryString["RID"] == null)
                {
                    //Need to select resturaunt
                    RunRestaurant.Visible = false;
                    SelectRestaurantPanel.Visible = true;
                }
                else {
                    RunRestaurant.Visible = true;
                    SelectRestaurantPanel.Visible = false;
                };
            };
        }

        protected void Opt_NewRes_Button_Click(object sender, EventArgs e)
        {

        }
        protected void Opt_ShowThisRestaurant_Click(object sender, EventArgs e)
        {
            try {
                int RID = Convert.ToInt32(((HiddenField)((RepeaterItem)((Button)sender).NamingContainer).FindControl("RestaurantID")).Value.ToString());
                Response.Redirect("/default.aspx?RID=" + RID);
            } catch (Exception) { };
        }
        //DateTime
        protected void SelectThisDate_Click(object sender, EventArgs e)
        {
            //Clean up interface
            foreach (RepeaterItem ri in DateListRepeater.Items)
            {
                ((System.Web.UI.HtmlControls.HtmlGenericControl)ri.FindControl("DateBlock")).Attributes.Remove("Class");
                ((System.Web.UI.HtmlControls.HtmlGenericControl)ri.FindControl("DateBlock")).Attributes.Add("Class", "dateBlock");
            }
            //Identify selected date
            DateTime Targetdate = Convert.ToDateTime(
                ((HiddenField)((RepeaterItem)((Button)sender).NamingContainer).FindControl("DateOfHiddenField")).Value.ToString()
                );
            //set temp parameter             

            ReservationElectedDate.Value = Targetdate.ToString();

            TimeSelectorMonthIndicatorLabel.Text = Targetdate.ToString("MMM");
            TimeSelectorWeekdayIndicatorLabel.Text = Targetdate.ToString("ddd");
            TimeSelectorDayIndicatorLabel.Text = Targetdate.ToString("dd");
            TimeSelectorHeaderUpdatePanel.Update();

            ReservationDisplayMonth.Text = Targetdate.ToString("MMM");
            ReservationDisplayWeekday.Text = Targetdate.ToString("ddd");
            ReservationDisplayDay.Text = Targetdate.ToString("dd");
            ReservationTop.Update();
            //update display
            DataUpdatePanel.Update();
            //show selected date
            ((System.Web.UI.HtmlControls.HtmlGenericControl)((RepeaterItem)((Button)sender).NamingContainer).FindControl("DateBlock")).Attributes.Add("Class", "dateBlock DateBlockSelected ");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "GoSHowTimeSelection", "stepToTime();", true);
        }

        protected void SelectThisTime_Click(object sender, EventArgs e)
        {
            //Clean up interface
            try
            {
                foreach (RepeaterItem ri in TimeListRepeater.Items)
                {
                    ((System.Web.UI.HtmlControls.HtmlGenericControl)ri.FindControl("TimeBlock")).Attributes.Remove("Class");
                    ((System.Web.UI.HtmlControls.HtmlGenericControl)ri.FindControl("TimeBlock")).Attributes.Add("Class", "timeBlock");
                }
            }
            catch { };

            //Identify selected date
            DateTime Targetdate = Convert.ToDateTime(
                ((Label)((RepeaterItem)((Button)sender).NamingContainer).FindControl("StartTime")).Text.ToString()
                );

            ReservationDisplayTimeLabel.Text = ((Label)((RepeaterItem)((Button)sender).NamingContainer).FindControl("StartTime")).Text.ToString();
            ReservationTop.Update();

            //set temp parameter
            ReservationElectedTime.Value = Convert.ToDateTime(ReservationElectedDate.Value).ToString();
            ReservationElectedTarget.Value = (Convert.ToDateTime(ReservationElectedDate.Value).AddMinutes(Targetdate.Minute).AddHours(Targetdate.Hour)).ToString();
            //update display
            DataUpdatePanel.Update();
            //show selected date            
            ((System.Web.UI.HtmlControls.HtmlGenericControl)((RepeaterItem)((Button)sender).NamingContainer).FindControl("TimeBlock")).Attributes.Add("Class", "timeBlock timeBlockSelected");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "GoShowCustomerSelection", "stepToCustomer();", true);


        }
        //User Details
        protected void CustomerNameTextbox_TextChanged(object sender, EventArgs e)
        {

            SubmitCustomerDetailsButton.Focus();
        }

        protected void CustomerContactNumberTextbox_TextChanged(object sender, EventArgs e)
        {
            //Attempt Search for customer name
            CustomerNameTextbox.Focus();
        }

        protected void SubmitCustomerDetailsButton_Click(object sender, EventArgs e)
        {
            if (CustomerContactNumberTextbox.Text.Length > 15)
            {
                ErrOnCustomerDetailsLabel.Text = "Please enter a valid contact number";
            }
            else
            {
                if (CustomerNameTextbox.Text.Length > 50)
                {
                    ErrOnCustomerDetailsLabel.Text = "Please enter a customer name";
                }
                else
                {
                    //All Good
                    ReservationDisplayCustomerName.Text = CustomerNameTextbox.Text;
                    ReservationDisplayContactNumber.Text = CustomerContactNumberTextbox.Text;
                    ReservationTop.Update();
                    //Change View
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "GoShowOrderSelection", "stepToOrder();", true);

                };
            };
        }

        protected void OptthisCategory_Click(object sender, EventArgs e)
        {
            int TargetCat = int.Parse(((Label)((RepeaterItem)((Button)sender).NamingContainer).FindControl("thisCategoryID")).Text.ToString());
            //Tag Category
            try
            {
                foreach (RepeaterItem ri in CategoryListRepeater.Items)
                {
                    ((Button)ri.FindControl("thisCategory")).CssClass = "CategoryButton";

                }
            }
            catch { };
            ((Button)sender).CssClass = "CategoryButtonSelected";
            CategoryListUpdatepanel.Update();
            //Update List

            ReservationViewingCat.Value = TargetCat.ToString();
            DataUpdatePanel.Update();
            ItemListSqlDataSource.DataBind();
            ItemListRepeater.DataBind();
            ItemListUpdatepanel.Update();
            //Show / Hide Empty Template
            if (ItemListRepeater.Items.Count > 0)
            {
                EmptyProductListPanel.Visible = false;
            }
            else
            {
                EmptyProductListPanel.Visible = true;
            };
            ItemListUpdatepanel.Update();
        }
        protected void OptthisItem_Click(object sender, EventArgs e)
        {
            //Retrieve Item ID
            int ItemID = int.Parse(((Label)((RepeaterItem)((Button)sender).NamingContainer).FindControl("thisItemID")).Text.ToString());
            //Add to Order
            try { 
                string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("Temp_Orders", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Function", SqlDbType.VarChar).Value = "AddKnown";
                        cmd.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                        cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                        cmd.Parameters.Add("@targetID", SqlDbType.Int).Value = ItemID;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                //Now Tag the Button
                try
                {
                    foreach (RepeaterItem ri in ItemListRepeater.Items)
                    {
                        ((Button)ri.FindControl("thisItem")).CssClass = "AddToOrderButton";                        
                    }
                }
                catch { };
                ((Button)sender).CssClass = "AddedToOrderButton";

            } catch { 
                //Handle Error On Adding Known Item To Temp Order
            };
            RefreshOrderList();

        }
        protected void RefreshOrderList()
        {
            //Refresh the order list
            CurrentOrderListSqlDataSource.DataBind();
            OrderListRepeater.DataBind();
            CurrentOrderListUpdatepanel.Update();
            //Refresh The Order Footer
            try
            {
                string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        da.SelectCommand = new SqlCommand("Temp_Orders", con);
                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                        da.SelectCommand.Parameters.Add("@Function", SqlDbType.VarChar).Value = "Total";
                        da.SelectCommand.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                        da.SelectCommand.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                        con.Open();
                        DataSet ds = new DataSet();
                        da.Fill(ds, "Totals");
                        DataTable dt = ds.Tables["Totals"];
                        OrderTotalLabel.Text = dt.Rows[0]["Total"].ToString();
                        EndOfOrder.Update();
                    }
                }
            }
            catch
            {
                //Handle Error On Adding Known Item To Temp Order
                ErrorOnManualItemEntry.Text = "Failed to add item. Please try again.";
            };
        }
        protected void OptManualItem_Click(object sender, EventArgs e)
        {
            //First Lets Evaluate
            ErrorOnManualItemEntry.Text = "";
            if (ManualItemDescriptionTextbox.Text.ToString().Length == 0 || ManualItemDescriptionTextbox.Text.ToString().Length > 50)
            {
                ErrorOnManualItemEntry.Text = "Please enter a valid item description";
            }
            else {
                if (! IsNumeric(ManualItemPriceTextbox.Text.ToString())) {
                    ErrorOnManualItemEntry.Text = "Please enter a valid Item Price";
                } else {
                    try {
                        decimal NewPrice = decimal.Parse(ManualItemPriceTextbox.Text.ToString());
                        if (NewPrice < 0)
                        {
                            //Here we would prohibit a negative amount
                            //But then again, maybe it's a discount???
                            //Should Make this a possible parameter under the company settings
                            //For now we'll allow it
                        };
                        //Let's Add the Item
                        //Add to Order
                        try
                        {
                            string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                            using (SqlConnection con = new SqlConnection(ConnectionString))
                            {
                                using (SqlCommand cmd = new SqlCommand("Temp_Orders", con))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.Add("@Function", SqlDbType.VarChar).Value = "AddCustom";
                                    cmd.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                                    cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                                    cmd.Parameters.Add("@targetID", SqlDbType.Int).Value = 0;
                                    cmd.Parameters.Add("@ItemDescription", SqlDbType.VarChar).Value = ManualItemDescriptionTextbox.Text.ToString();
                                    cmd.Parameters.Add("@ITEMPRICE", SqlDbType.Decimal).Value = NewPrice;
                                    con.Open();
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            //Now Clean Up
                            ManualItemDescriptionTextbox.Text = "";
                            ManualItemPriceTextbox.Text = "";
                            ManualItemDescriptionTextbox.Focus();
                            ManualEntryUpdatePanel.Update();

                        }
                        catch
                        {
                            //Handle Error On Adding Known Item To Temp Order
                            ErrorOnManualItemEntry.Text = "Failed to add item. Please try again.";
                        };
                        RefreshOrderList();
                    } catch {
                        ErrorOnManualItemEntry.Text = "Please enter a valid Item Price.";
                    };
                   
                }
            };
        }
        public bool IsNumeric(string value)
        {
            return value.All(char.IsNumber);
        }
        protected void OptRemovethisItem_Click(object sender, EventArgs e)
        {
            int LineID = int.Parse(((Label)((RepeaterItem)((Button)sender).NamingContainer).FindControl("OrderItemIdLabel")).Text.ToString());
            try
            {
                string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("Temp_Orders", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Function", SqlDbType.VarChar).Value = "Delete";
                        cmd.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                        cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                        cmd.Parameters.Add("@targetID", SqlDbType.Int).Value = LineID;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }             
            }
            catch
            {
                //Handle Error On Removing Item From Order
            };
            RefreshOrderList();
        }
        protected void ItemNote_TextChanged(object sender, EventArgs e)
        {
            string Note = ((TextBox)sender).Text.ToString();
            int LineID = int.Parse(((Label)((RepeaterItem)((TextBox)sender).NamingContainer).FindControl("OrderItemIdLabel")).Text.ToString());
            if (Note.Length > 0) {
                //Add Note
                try
                {
                    string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                    using (SqlConnection con = new SqlConnection(ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("Temp_Orders", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.Add("@Function", SqlDbType.VarChar).Value = "AddNote";
                            cmd.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                            cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                            cmd.Parameters.Add("@targetID", SqlDbType.Int).Value = LineID;
                            cmd.Parameters.Add("@ItemDescription", SqlDbType.VarChar).Value = Note;
                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch
                {
                    //Handle Error On Removing Item From Order
                };
            } else {
                //Remove Note
                try
                {
                    string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                    using (SqlConnection con = new SqlConnection(ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("Temp_Orders", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.Add("@Function", SqlDbType.VarChar).Value = "RemoveNote";
                            cmd.Parameters.Add("@OrderIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                            cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                            cmd.Parameters.Add("@targetID", SqlDbType.Int).Value = LineID;
                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch
                {
                    //Handle Error On Removing Item From Order
                };
            };
            RefreshOrderList();
        }
        protected void SaveNewOrder_Click(object sender, EventArgs e)
        {
            try
            {
                string ConnectionString = ConfigurationManager.ConnectionStrings["NewTryxConnectionString"].ToString();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SaveOrder", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@ReservationIdentifier", SqlDbType.VarChar).Value = NewOrderRefHiddenField.Value.ToString();
                        cmd.Parameters.Add("@ReservationId", SqlDbType.Int).Value = int.Parse(SelectedReservationID.Value.ToString());
                        cmd.Parameters.Add("@RestaurantID", SqlDbType.Int).Value = int.Parse(Request.QueryString["rid"].ToString().ToLower());
                        cmd.Parameters.Add("@CustomerIdentifier", SqlDbType.Int).Value = int.Parse(SelectedCustomerID.Value.ToString());
                        cmd.Parameters.Add("@CustomerContactNumber", SqlDbType.VarChar).Value = ReservationDisplayContactNumber.Text.ToString();
                        cmd.Parameters.Add("@CustomerName", SqlDbType.VarChar).Value = ReservationDisplayCustomerName.Text.ToString();
                        cmd.Parameters.Add("@OrderNote", SqlDbType.Text).Value = ORderNoteTextbox.Text.ToString();
                        cmd.Parameters.Add("@StartDateTime", SqlDbType.Date).Value = DateTime.Parse(ReservationElectedDate.Value.ToString()).Add(TimeSpan.Parse(ReservationElectedTime.Value.ToString()));
                        cmd.Parameters.Add("@ReservationStatusId", SqlDbType.Int).Value = 1;
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                //Now Change Display
                

            }
            catch
            {
                //Handle Error On Adding Known Item To Temp Order
            };
        }
      
    }
}