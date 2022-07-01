<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="KuulEatsWebAppDotNet._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Content/MainCS.css" rel="stylesheet" />
    <script src="Scripts/MainJS.js"></script>
     <asp:UpdatePanel runat="server" id="DataUpdatePanel" updatemode="conditional">
                <contenttemplate>
                    <asp:HiddenField runat="server" id="ReservationElectedDate"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="ReservationElectedTime"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="ReservationElectedTarget"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="ReservationViewingCat" Value="0"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="SelectedCustomerID" Value="0"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="SelectedReservationID" Value="0"></asp:HiddenField>
                    <asp:HiddenField runat="server" id="NewOrderRefHiddenField" Value="NAN"></asp:HiddenField>
                </contenttemplate>
            </asp:UpdatePanel>
    <div class="row"> <div>
                
            </div>
        <asp:panel id="SelectRestaurantPanel" runat="server" visible="true">
           <table class="standardTable">
                    <tr>
                        <td>Please select a Restaurant</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:repeater runat="server" id="RestaurantListRepeater" datasourceid="RestaurantListSqlDataSource">
                                <itemtemplate>
                                    <div>
                                         <asp:HiddenField id="RestaurantID" value='<%# Eval("ID") %>' runat="server" />
                                        <asp:button runat="server" id="Opt_ShowThisRestaurant" usersubmitbehavior="false" text='<%# Eval("Name") %>' onclick="Opt_ShowThisRestaurant_Click" />
                                    </div>
                                </itemtemplate>
                            </asp:repeater>
                            <asp:SqlDataSource ID="RestaurantListSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="RestaurantList" SelectCommandType="StoredProcedure">                      
                    </asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
        </asp:panel>
        <asp:panel id="RunRestaurant" runat="server" visible="false">
        <div id="CurrentList" class="col-md-4" style="display:none;">
            <table cellspacing="0" style="width: 100%; height: 100%">
                <tr>
                    <td>Current Reservations</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <asp:Repeater ID="reservationListRepeater" runat="server" DataSourceID="ReservationListCurrentSqlDataSource">
                        </asp:Repeater>
                        <asp:SqlDataSource ID="ReservationListCurrentSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="Reservations List" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter DefaultValue="0" Name="RestaurantId" QueryStringField="rid" Type="Int32" />
                                <asp:Parameter Name="TimeViewed" Type="DateTime" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td>
                       
                        
                        <asp:UpdatePanel ID="ReservationListFooterUpdatePanel" runat="server" updatemode="conditional">
                           <contenttemplate>
<asp:Button ID="Opt_NewRes_Button" class="btn" runat="server" Text="Add Reservation" ToolTip="Add New Reservation" OnClick="Opt_NewRes_Button_Click" UseSubmitBehavior="False" />
                         </contenttemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>

        </div>
        <div id="NewReservationZone" class="col-md-4">

        </div>
        <div id="GetDate" class="halfScreenBlockLeft">
            <p class="h1" style="text-align: center;">Select a Reservation Date</p>
            <hr />
            <asp:updatepanel runat="server" updatemode="conditional" id="DateUpdatePanel">
                <contenttemplate>
                    <asp:Repeater ID="DateListRepeater" runat="server" DataSourceID="AvailableDatesSqlDataSource">

                        <itemtemplate>
                            <div runat="server" id="DateBlock" class="dateBlock" onclick="try{var q =  document.getElementsByClassName('dateBlockSelected');for (x = 0; x = q.length-1;x++){q[x].classList.remove('dateBlockSelected')};} catch(e){};this.getElementsByClassName('silentButton')[0].click();">
                                <table class="standardTable">
                                    <tr>
                                        <td class="dateBlockMonth">
                                            <asp:label text='<%# Eval("MonthOf") %>' runat="server" />
                                        </td>
                                        <td rowspan="2" class="dateBlockDay">
                                            <asp:label text='<%# Eval("DayOf") %>' runat="server" />
                                            <asp:HiddenField value='<%# Eval("Reserved") %>' runat="server" />
                                            <asp:HiddenField value='<%# Eval("Available") %>' runat="server" />

                                            <asp:HiddenField id="DateOfHiddenField" runat="server" value='<%# Eval("DateOf") %>'></asp:HiddenField>
                                        </td>
                                    </tr>

                                    <tr>

                                        <td>
                                            <asp:label text='<%# Eval("WeekdayOf") %>' runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">

                                            <progress id="file" value='<%# Eval("Reserved") %>' max='<%# Eval("Total") %>' title="0%">1$</progress>
                                            <asp:label class="dateBlockAvailableQTY" text='<%# Eval("Available") %>' runat="server" />
                                            <asp:Button class="silentButton" id="SelectThisDate" runat="server" Text="" OnClick="SelectThisDate_Click" UseSubmitBehavior="False" />
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </itemtemplate>
                    </asp:Repeater>
                     <asp:SqlDataSource ID="AvailableDatesSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="ReservationDates" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter DefaultValue="1" Name="RestaurantID" QueryStringField="rid" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                </contenttemplate>
            </asp:updatepanel>


        </div>
        <div id="GetTime" class="halfScreenBlockLeft halfScreenBlockFaded">
            <asp:updatepanel runat="server" id="TimeSelectorHeaderUpdatePanel" updatemode="conditional">
                <contenttemplate>
 <div class="dateBlock dateBlockDisplay" onclick="stepToDate();">
                                <table class="standardTable">
                                    <tr>
                                        <td class="dateBlockMonth">
                                            <asp:label id="TimeSelectorMonthIndicatorLabel" text="..." runat="server" />
                                        </td>
                                        <td rowspan="2" class="dateBlockDay">
                                            <asp:label id="TimeSelectorDayIndicatorLabel" text=".." runat="server" />                                         
                                        </td>
                                    </tr>

                                    <tr>

                                        <td>
                                            <asp:label id="TimeSelectorWeekdayIndicatorLabel" text="..." runat="server" />
                                        </td>
                                    </tr>
                                    

                                </table>
                            </div>
                </contenttemplate>
            </asp:updatepanel>
            <p class="h1" style="text-align: center;">Select a Reservation Time</p>
            <hr />
            <asp:updatepanel id="TimeUpdatePanel" runat="server" updatemode="conditional" class="timeZone">
                <contenttemplate>
                 
                        <asp:Repeater ID="TimeListRepeater" runat="server" DataSourceID="AvailableTimesSqlDataSource">
                            <itemtemplate>
                                <div runat="server" id="TimeBlock" class="timeBlock" onclick="try{var q =  document.getElementsByClassName('timeBlockSelected');for (x = 0; x = q.length-1;x++){q[x].classList.remove('timeBlockSelected')};} catch(e){};this.getElementsByClassName('silentButton')[0].click();">
                                    <table class="standardTable">
                                        <tr>
                                            <td>
                                                <asp:label id="StartTime" text='<%# Eval("StartTime").ToString().Substring(0,5)  %>' runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:HiddenField value='<%# Eval("Booked") %>' runat="server" />
                                                <asp:HiddenField value='<%# Eval("Available") %>' runat="server" />

                                                <progress id="file" value='<%# Eval("Booked") %>' max='<%# Eval("Total") %>' title="0%">1$</progress>
                                                <asp:label class="timeBlockAvailableQTY" text='<%# Eval("Available") %>' runat="server" />
                                                <asp:Button class="silentButton" id="SelectThisTimeButton" runat="server" Text="" OnClick="SelectThisTime_Click" UseSubmitBehavior="False" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </itemtemplate>
                        </asp:Repeater>
                        <asp:SqlDataSource ID="AvailableTimesSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="ReservationTimes" SelectCommandType="StoredProcedure">
                            <selectparameters>
                                <asp:QueryStringParameter DefaultValue="1" Name="RestaurantID" QueryStringField="rid" Type="Int32" />
                                <asp:ControlParameter ControlID="ReservationElectedDate" DefaultValue="" Name="TargetDate" PropertyName="value" Type="String" />
                            </selectparameters>
                        </asp:SqlDataSource>
                  
                </contenttemplate>
            </asp:updatepanel>

        </div>
        <div id="GetCustomer" class="halfScreenBlockLeft halfScreenBlockFaded">
            <p class="h1" style="text-align: center;">Customer Details</p>
            <hr />
            <asp:updatepanel runat="server" id="CustomerSelectorUpdatePanel" class="ZoneBlockSized">
                <contenttemplate>
                    <table class="standardTable">
                        <tr class="CompressedLine">
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>                            
                        </tr>
                        <tr class="CompressedLine">
                            <td colspan="2" class="text-left h3">Customer Contact Number</td>
                        </tr>
                         <tr class="CompressedLine">
                             <td class="Indent">&nbsp;</td>
                            <td>
                                <asp:textbox id="CustomerContactNumberTextbox" autopostback="true" runat="server" cssclass="TextBoxNumberLineMed" OnTextChanged="CustomerContactNumberTextbox_TextChanged"></asp:textbox>
                            </td>
                        </tr>
                         <tr class="CompressedLine">
                            <td colspan="2">&nbsp;</td>
                        </tr>
                        <tr class="CompressedLine">
                            <td colspan="2" class="text-left h3">Customer Name</td>
                        </tr>
                         <tr class="CompressedLine">
                             <td class="Indent">&nbsp;</td>
                            <td>
                                <asp:TextBox id="CustomerNameTextbox" autopostback="true"   runat="server" cssclass="TextBoxFullLine" OnTextChanged="CustomerNameTextbox_TextChanged"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="CompressedLine">
                            <td colspan="2">&nbsp;</td>
                        </tr>
                         <tr class="CompressedLine">
                            <td colspan="2">
                                <asp:label id="ErrOnCustomerDetailsLabel" runat="server" class="has-error"></asp:label>
                            </td>
                        </tr>
                         <tr class="CompressedLine">
                            <td colspan="2">&nbsp;</td>
                        </tr>
                         <tr class="CompressedLine">
                            <td colspan="2" style="text-align:right;">
                                <asp:Button runat="server" Text="Save" CssClass="btn-primary h3" ID="SubmitCustomerDetailsButton" OnClick="SubmitCustomerDetailsButton_Click" UseSubmitBehavior="False" />
                            </td>
                        </tr>
                         <tr>
                            <td colspan="2"></td>
                        </tr>
                    </table>
                </contenttemplate>
            </asp:updatepanel>
        </div>
        <div id="GetOrder" class="halfScreenBlockLeft halfScreenBlockFaded">
            <p class="h1" style="text-align: center;">Order</p>
            <hr />
            <div class="ZoneBlockSized">
                <table class="standardTable">
                    <tr>
                        <td rowspan="2" style="width: 10vw;
vertical-align: top;">
                            <div style="max-height:64vh;overflow-y:auto;">
                            <asp:updatepanel runat="server" id="CategoryListUpdatepanel" updatemode="conditional" >
                <contenttemplate>
                    <asp:Repeater id="CategoryListRepeater" runat="server" DataSourceID="CategoryListSqlDataSource">
                       <itemtemplate>
                           <asp:label id="thisCategoryID" runat="server" style="display:none" Text='<%# Eval("Id") %>'></asp:label>
                          <asp:Button id="thisCategory" cssclass="CategoryButton" runat="server"  Text='<%# Eval("CategoryName") %>' UseSubmitBehavior="False" OnClick="OptthisCategory_Click" />
                       </itemtemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="CategoryListSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="Category List" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:QueryStringParameter DefaultValue="0" Name="RestaurantID" QueryStringField="rid" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </contenttemplate>
            </asp:updatepanel> 
                            
                                </div>
                        </td>
                    
                        <td style="vertical-align:top;"><asp:updatepanel updatemode="conditional" runat="server" id="ItemListUpdatepanel" class="SubPageList">
                <contenttemplate>
                    <asp:Repeater runat="server" id="ItemListRepeater" DataSourceID="ItemListSqlDataSource">
                        <itemtemplate>
                            <table class="standardTable">
                                <tr>
                                    
                                    <td><asp:Label runat="server" id="thisProductDescription"  Text='<%# Eval("ProductDescription") %>'></asp:Label></td>
                                    <td><asp:Label runat="server" id="thisItemID" style="display:none" Text='<%# Eval("Id") %>'></asp:Label>
                             
                             <asp:Label runat="server" id="thisProductCost"  Text='<%# Eval("ProductCost","{0:c}") %>'></asp:Label></td>
                                <td>
                                    <asp:Button id="thisItem" runat="server" cssclass="AddToOrderButton" UserSubmitBehavior="false" Text="Add" OnClick="OptthisItem_Click" onclientclick="this.attr('disabled':'true');" />
                                </td></tr>
                            </table>
                             
                        </itemtemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="ItemListSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="Item List" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:QueryStringParameter DefaultValue="0" Name="RestaurantID" QueryStringField="rid" Type="Int32" />
                            <asp:ControlParameter ControlID="ReservationViewingCat" DefaultValue="0" Name="CategoryID" PropertyName="Value" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Panel runat="server" id="EmptyProductListPanel">
                        Please select a category on the left or manually enter a product below.
                    </asp:Panel>
                </contenttemplate>
            </asp:updatepanel></td>
                    </tr>
                    <tr>
                        <td>
                           <div>
                               <asp:updatepanel runat="server" id="ManualEntryUpdatePanel" updatemode="conditional">
                                   <contenttemplate>
                                       <table class="standardTable">
                                           <tr>
                                               <td>Item Description</td>
                                               <td>Item Price</td>
                                               <td rowspan="2">
                                                   <asp:Button usersumbitbehavior="false" id="AddManualItem" runat="server" onclick="OptManualItem_Click" />
                                               </td>
                                           </tr>
                                           <tr>
                                               <td>
                                                   <asp:textbox runat="server" autopostback="false" id="ManualItemDescriptionTextbox"></asp:textbox>
                                               </td>
                                               <td>
                                                   <asp:textbox runat="server" id="ManualItemPriceTextbox" autopostback="false"></asp:textbox>
                                               </td></tr>
                                           <tr>
                                               <td colspan="3">
                                                   <asp:label runat="server" id="ErrorOnManualItemEntry"></asp:label>
                                               </td>
                                           </tr>
                                       </table>
                                   </contenttemplate>
                               </asp:updatepanel>
                           </div>
                        </td>
                    </tr>
                </table>
            </div>
            

        </div>

        <div id="ReservationView" class="halfScreenBlockRight">
            <asp:UpdatePanel id="ReservationTop" runat="server" updatemode="conditional">
                <contenttemplate>
                    <table class="standardTable">
                        <tr>
                            <td>
                                <div class="dateBlock dateBlockDisplay" onclick="stepToDate();">
                                <table class="standardTable">
                                    <tr>
                                        <td class="dateBlockMonth">
                                            <asp:label id="ReservationDisplayMonth" text="..." runat="server" />
                                        </td>
                                        <td rowspan="2" class="dateBlockDay">
                                            <asp:label id="ReservationDisplayDay" text=".." runat="server" />                                         
                                        </td>
                                    </tr>

                                    <tr>

                                        <td>
                                            <asp:label id="ReservationDisplayWeekday" text="..." runat="server" />
                                        </td>
                                    </tr>
                                    

                                </table>
                            </div>
                            </td>
                            <td rowspan="2">
                                <asp:Label runat="server" class="h1" id="ReservationDisplayCustomerName"></asp:Label>
                                <asp:Label runat="server" class="h2" id="ReservationDisplayContactNumber"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="dateBlock dateBlockDisplay dateBlockDay" style="margin-top: 1vh;" onclick="stepToTime();">
                                    <asp:label runat="server" id="ReservationDisplayTimeLabel" text="..."></asp:label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </contenttemplate>
            </asp:UpdatePanel>
            <asp:updatepanel updatemode="conditional" runat="server" id="CurrentOrderListUpdatepanel" class="SubPageList">
                <contenttemplate>
                    <asp:Repeater runat="server" id="OrderListRepeater" DataSourceID="CurrentOrderListSqlDataSource">
                        <itemtemplate>
                            <table class="standardTable">
                                <tr>
                                     <td>
                                    <asp:Button id="Button1" runat="server" cssclass="AddToOrderButton" UserSubmitBehavior="false" Text="Remove" OnClick="OptRemovethisItem_Click" />
                                </td>
                                    <td><asp:Label runat="server" id="Label1"  Text='<%# Eval("Description") %>'></asp:Label></td>
                                    <td><asp:Label runat="server" id="OrderItemIdLabel" style="display:none" Text='<%# Eval("Id") %>'></asp:Label>
                             
                             <asp:Label runat="server" id="Label3"  Text='<%# Eval("Price","{0:c}") %>'></asp:Label>
                                        <asp:Textbox autopostback="true" OnTextChanged="ItemNote_TextChanged" runat="server" id="ItemNotes" Text='<%# Eval("Note") %>'></asp:Textbox>

                                    </td>
                               </tr>
                            </table>
                             
                        </itemtemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="CurrentOrderListSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:NewTryxConnectionString %>" SelectCommand="Temp_Orders" SelectCommandType="StoredProcedure">
                        <SelectParameters>                            
                            <asp:Parameter DefaultValue="Select" Name="Function" Type="String" />
                            <asp:ControlParameter ControlID="NewOrderRefHiddenField" DefaultValue="NAN" Name="OrderIdentifier" PropertyName="Value" Type="String" />                 
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:Panel runat="server" id="Panel1">
                        Please select a category on the left or manually enter a product below.
                    </asp:Panel>
                </contenttemplate>
            </asp:updatepanel>
            <asp:updatepanel id="EndOfOrder" runat="server" updatemode="conditional">
                <contenttemplate>
                    <asp:MultiView runat="server" id="OrderFooter" ActiveViewIndex="0" >
                        <asp:view runat="server" id="NewOrderView">
                            <table class="standardTable">
                                <tr>
                                    <td colspan="2">Total:</td>
                                    <td><asp:label id="OrderTotalLabel" runat="server"></asp:label></td>
                                </tr>
                                <tr>
                                    <td colspan="2">Note:</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="2"><asp:textbox runat="server" id="ORderNoteTextbox"></asp:textbox></td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <asp:button runat="server" onclick="SaveNewOrder_Click" usersubmitbehavior="false" id="SaveNewOrder" text="Save" />
                                    </td>
                                </tr>
                            </table>

                        </asp:view>
                    </asp:MultiView>
                </contenttemplate>
            </asp:updatepanel>
        </div>
            </asp:panel>

    </div>


</asp:Content>
