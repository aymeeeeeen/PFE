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
        public void CreateNewCustomer() { X.Call("testCheckBox"); }
    </script>
    <script>
        var onKeyUp = function () {
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
        };
    </script>
</head>
<body>
    <div class="container-fluid px-0">
        <div class="row collapse show no-gutters d-flex h-100 position-relative">
            <div class="col-3 h-100 w-sidebar navbar-collapse collapse d-none d-md-flex sidebar">
                <!-- fixed sidebar -->
                <div class="navbar-light bg-light position-fixed h-100 align-self-start w-sidebar shadow-lg p-3 mb-5 bg-white rounded">
                    <form id="form" runat="server">
                        <ext:ResourceManager runat="server" />
                        <ext:FormPanel ID="frmInfo" runat="server" Border="false" Frame="false" Padding="5">
                            <Items>
                                <ext:Checkbox runat="server" ID="pm" BoxLabel="Plannification Optimisé" Checked="true">
                                    <Listeners>
                                        <Change Handler="App.direct.CreateNewCustomer();"/>
                                    </Listeners>
                                </ext:Checkbox>
                                <ext:ComboBox runat="server" Editable="false" DisplayField="state" ValueField="abbr" QueryMode="Local" ForceSelection="true" TriggerAction="All"
                                    EmptyText="Select a Véhicule ..." FieldLabel="Véhicule">
                                </ext:ComboBox>  
                                <ext:DateField ID="DateField1" runat="server" Vtype="daterange" FieldLabel="Date De Départ" EnableKeyEvents="true">  
                                    <CustomConfig>
                                        <ext:ConfigItem Name="endDateField" Value="DateField2" Mode="Value" />
                                    </CustomConfig>
                                    <Listeners>
                                        <KeyUp Fn="onKeyUp" />
                                    </Listeners>
                                </ext:DateField>
                                <ext:DateField ID="DateField2" runat="server" Vtype="daterange" FieldLabel="Date d'Arrivée" EnableKeyEvents="true">    
                                    <CustomConfig>
                                        <ext:ConfigItem Name="startDateField" Value="DateField1" Mode="Value" />
                                    </CustomConfig>
                                    <Listeners>
                                        <KeyUp Fn="onKeyUp" />
                                    </Listeners>
                                </ext:DateField>
                                <ext:TextField runat="server" ID="tolerence" AllowBlank="false" FieldLabel="Tolérence"></ext:TextField>
                            </Items>
                            <Items>
                                <ext:Button runat="server" Type="Submit" ID="btnOK" Text="Valider" Icon="Accept" Margin="10"></ext:Button>
                                <ext:Button runat="server" ID="btnCancel" Text="Annuler" Icon="Cancel"></ext:Button>
                            </Items>
                        </ext:FormPanel>
                    </form>
                </div>
            </div>
            <div class="col">
                <div id="mapContainer"></div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="Scripts/demo.js"></script>
</body>
</html> 
