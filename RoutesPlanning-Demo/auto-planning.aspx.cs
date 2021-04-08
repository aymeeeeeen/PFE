using Ext.Net;
using System;
using System.Data.Entity.Spatial;
using System.Linq;
using System.Web.UI.WebControls;
using Microsoft.SqlServer.Types;
using System.Data.SqlTypes;

namespace RoutesPlanning_Demo
{
    public partial class auto_planning : System.Web.UI.Page
    {
        demoDB db;

        protected void Page_Load(object sender, EventArgs e)
        {

            ChargeGridPanel();
        }
        

        protected void Button1Click(object sender, DirectEventArgs e)
        {
            SpacialDataSet sd = new SpacialDataSet();
            sd.vehicule = vehicule.Text;
            sd.dateDepart = DateTime.Parse(dateDepart.Text)+TimeSpan.Parse(HD.Text);
            sd.dateArivee = DateTime.Parse(dateArivee.Text) + TimeSpan.Parse(HA.Text);
            if (pm.Checked == true)
            {
                SqlGeometry sqlG = SqlGeometry.Parse(trajet.Text);
                sd.trajet = DbGeometry.FromBinary(sqlG.STAsBinary().Buffer);
            }
            else if (pm.Checked == false)
            {
                SqlGeometry sqlG = SqlGeometry.Parse(trajet.Text);
                sd.trajet = DbGeometry.FromBinary(sqlG.STAsBinary().Buffer);
            }
            sd.active = (bool?)SqlBoolean.Parse(active.Text);
            db = new demoDB();
            db.SpacialDataSets.Add(sd);
            db.SaveChanges();
            X.Msg.Alert("INFO", "l'opération a été effectuée avec succès").Show();
            ResetInputs();
            Store1.Reload();
            X.Call("resetMap");
        }

        protected void ChargeGridPanel()
        {
            db = new demoDB();
            int x = 1;
            bool y = Convert.ToBoolean(x);

            var data = (from sd in db.SpacialDataSets
                        where sd.active == y
                        select sd);
            Store1.DataSource = data;
            Store1.DataBind();
        }
       
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            string varID = e.ExtraParams["Id"];
            SpacialDataSet sd = SpacialDataSet.GetSpacialDataSet(int.Parse(varID));     
            frmInfo.SetValues(new
            {
                sd.vehicule,
                sd.dateDepart,
                sd.dateArivee,
                
                V =
                trajet.Text = sd.trajet.AsText()
            });
            X.Call("getTrajetFromDb");
        }

        protected void ResetInputs()
        {
            vehicule.Clear();
            dateDepart.Clear();
            HD.Clear();
            dateArivee.Clear();
            HA.Clear();
            trajet.Clear();
        }

        protected void deleteRowConfirmation(object sender, DirectEventArgs e)
        {
            MessageBoxConfig config = new MessageBoxConfig();
            config.Title = "ALERTE";
            config.Message = "Êtes-vous sûr de vouloir supprimer?";
            config.Closable = false;
            config.Icon = MessageBox.Icon.WARNING;
            config.Buttons = MessageBox.Button.YESNO;
            config.MessageBoxButtonsConfig = new MessageBoxButtonsConfig
            {
                Yes = new MessageBoxButtonConfig { Handler = "App.direct.deleteRow", Text = "YES" },
                No = new MessageBoxButtonConfig { Handler = "Ext.net.DirectMethods.ClickedNO()", Text = "NO" }
            };
            X.Msg.Show(config);
        }

        [DirectMethod]
        protected void deleteRow(object sender, DirectEventArgs e)
        {
            db = new demoDB();
            string varID = e.ExtraParams["Id"];
            var ID = int.Parse(varID);
            SpacialDataSet sd = (from i in db.SpacialDataSets where i.Id == ID select i).SingleOrDefault();
            sd.active = false;
            db.SaveChanges();
            //ChargeGridPanel();
            Store1.Reload();
        }
    }   
}