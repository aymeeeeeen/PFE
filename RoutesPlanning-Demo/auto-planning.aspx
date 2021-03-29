<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="auto-planning.aspx.cs" Inherits="RoutesPlanning_Demo.auto_planning" %>
<!DOCTYPE html>
<html xmlns="https://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Planification Des Trajets</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests" /> 
    <link href="Content/style.css" rel="stylesheet" />
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.0/mapsjs-ui.css?dp-version=1549984893" />
    <script type="text/javascript" src="Scripts/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-core.js"></script>
    <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-service.js"></script>
    <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-ui.js"></script>
    <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-mapevents.js"></script>
    <script runat="server">
        [DirectMethod]
        public void Unchecked() { X.Call("testCheckBox"); }
    </script>
    <script>
        var onKeyUp = function () {
            try {
                var me = this,
                    v = me.getValue(),
                    field;
                if (me.startDateField) {
                    field = Ext.getCmp(me.startDateField);
                    field.setMaxValue(v);
                    me.dateRangeMax = v;
                } else if (me.endDateField) {
                    field = Ext.getCmp(me.endDateField);
                    field.setMinValue(v);
                    me.dateRangeMin = v;
                }
                field.validate();
            } catch (e) {

            }
        };
    </script>
</head>
<body>
    <ext:ResourceManager runat="server" />
    <div>
        <div class="row collapse show no-gutters d-flex h-100 position-relative">
            <div class="col-3 h-100 w-sidebar navbar-collapse collapse d-none d-md-flex sidebar">
                <!-- fixed sidebar -->
                <form id="form" runat="server">
                    <div class="container-fluid px5">
                        <div class="navbar-light bg-light position-fixed align-self-start w-sidebar shadow-lg p-3 mb-5 bg-white rounded mt-2">
                            <div>
                                <h5>La Planification Des Trajets</h5>
                            </div> 
                            <ext:FormPanel ID="frmInfo" runat="server" Border="false" Frame="false" Padding="5">
                                <Items>
                                    <ext:Checkbox runat="server" ID="pm" BoxLabel="Plannification Optimisé" Checked="true">
                                        <Listeners>
                                            <Change Handler="App.direct.Unchecked()"/>
                                        </Listeners>
                                    </ext:Checkbox>
                                    <ext:TextField runat="server" ID="vehicule" AllowBlank="false" FieldLabel="Véhicule">
                                    </ext:TextField>  
                                    <ext:DateField ID="dateDepart" runat="server" Vtype="daterange" FieldLabel="Date De Départ" EnableKeyEvents="true" Format="yyyy-MM-dd">  
                                        <CustomConfig>
                                            <ext:ConfigItem Name="endDateField" Value="dateArivee" Mode="Value" />
                                        </CustomConfig>
                                        <Listeners>
                                            <KeyUp Fn="onKeyUp" />
                                        </Listeners>
                                    </ext:DateField>
                                    <ext:TimeField ID="TimeField2" runat="server" FieldLabel="Heure Départ" MinTime="9:00" MaxTime="18:00" Increment="30" SelectedTime="09:00" Format="H:mm" />
                                    <ext:DateField ID="dateArivee" runat="server" Vtype="daterange" FieldLabel="Date d'Arrivée" EnableKeyEvents="true" Format="yyyy-MM-dd">    
                                        <CustomConfig>
                                            <ext:ConfigItem Name="startDateField" Value="dateDepart" Mode="Value" />
                                        </CustomConfig>
                                        <Listeners>
                                            <KeyUp Fn="onKeyUp" />
                                        </Listeners>
                                    </ext:DateField>
                                    <ext:TimeField ID="TimeField1" runat="server" FieldLabel="Heure d'Arivée" MinTime="9:00" MaxTime="18:00" Increment="30" SelectedTime="09:00" Format="H:mm" />
                                    <ext:TextField runat="server" ID="txtBoxTolerence" AllowBlank="false" FieldLabel="Tolérence"></ext:TextField>
                                    <ext:TextField runat="server" ID="trajet" AllowBlank="false" FieldLabel="Trajet" Hidden="false"></ext:TextField>
                                </Items>
                                <Items>
                                    <ext:Button runat="server" Type="Submit" ID="btnOK" Text="Valider" Icon="Accept" Margin="10" OnDirectClick="Button1Click">
                                    </ext:Button>
                                    <ext:Button runat="server" ID="btnCancel" Text="Annuler" Icon="Cancel"></ext:Button>
                                </Items>
                            </ext:FormPanel>
                        </div>
                    </div>
                    <div class="fixed-bottom">
                        <ext:GridPanel ID="GridPanel" runat="server" Header="true" Border="false" Title="Liste Des Planifications" Icon="Lorry">
                            <Store>
                                <ext:Store ID="Store1" runat="server" PageSize="10">
                                    <Model>
                                        <ext:Model runat="server" IDProperty="Id">
                                            <Fields>
                                                <ext:ModelField Name="Id" />
                                                <ext:ModelField Name="vehicule" />
                                                <ext:ModelField Name="dateDepart" Type="Date" />
                                                <ext:ModelField Name="dateArivee" Type="Date" />
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                            <ColumnModel runat="server">
                                <Columns>
                                    <ext:Column runat="server" Text="Id" Sortable="true" DataIndex="Id" />
                                    <ext:Column runat="server" Text="Véhicule" Sortable="true" DataIndex="vehicule" Flex="1" />
                                    <ext:DateColumn runat="server" Text="Date De Départ" Sortable="true" DataIndex="dateDepart" Format="yyyy-MM-dd" Flex="1"/>
                                    <ext:DateColumn runat="server" Text="Date d'Arivée" Sortable="true" DataIndex="dateArivee" Format="yyyy-MM-dd" Flex="1"/>
                                    <ext:ImageCommandColumn runat="server" Width="30" Sortable="false">
                                        <Commands>
                                            <ext:ImageCommand Icon="Decline" ToolTip-Text="Delete Plant" CommandName="delete">                            
                                            </ext:ImageCommand>
                                        </Commands>
                                        <Listeners>
                                            <Command Handler="this.up('gridpanel').store.removeAt(recordIndex);" />
                                        </Listeners>
                                    </ext:ImageCommandColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel runat="server" Mode="Single">
                                    <DirectEvents>
                                        <Select OnEvent="RowSelect" Buffer="250">
                                            <EventMask ShowMask="true" Target="CustomTarget" CustomTarget="#{frmInfo}" />
                                            <ExtraParams>
                                                <ext:Parameter Name="Id" Value="record.getId()" Mode="Raw" />
                                            </ExtraParams>
                                        </Select>
                                    </DirectEvents>
                                </ext:RowSelectionModel>
                            </SelectionModel>
                            <View>
                                <ext:GridView runat="server" LoadMask="false" />
                            </View>
                            <Features>
                                <ext:GridFilters runat="server" Local="true">
                                    <Filters>
                                        <ext:NumericFilter DataIndex="Id" />
                                        <ext:StringFilter DataIndex="vehicule" />
                                        <ext:DateFilter DataIndex="dateDepart">
                                            <DatePickerOptions runat="server" TodayText="Now" />
                                        </ext:DateFilter>
                                        <ext:DateFilter DataIndex="dateArivee">
                                            <DatePickerOptions runat="server" TodayText="Now" />
                                        </ext:DateFilter>
                                    </Filters>
                                </ext:GridFilters>
                            </Features>
                            <BottomBar>
                                <ext:PagingToolbar runat="server" DisplayInfo="true" DisplayMsg="Displaying Jobs {0} - {1} of {2}" />
                            </BottomBar>
                        </ext:GridPanel>
                    </div>
                </form>
            </div>
            <div class="col">
                <div id="mapContainer"></div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/demo.js"></script>
</body>
</html> 
