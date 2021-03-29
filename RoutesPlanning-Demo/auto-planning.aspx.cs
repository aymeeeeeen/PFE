using Ext.Net;
using System;
using System.Data.Entity.Spatial;
using System.Linq;
using System.Web.UI.WebControls;
using Microsoft.SqlServer.Types;

namespace RoutesPlanning_Demo
{
    public partial class auto_planning : System.Web.UI.Page
    {
        demoDB db;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (pm.Checked == true)
            //{
            //    X.Call("planificationOptimise");
            //    pm.Checked = true;
            //}
            //else if (pm.Checked == false)
            //{
            //    X.Call("planificationManuelle");
            //    pm.Checked = false;
            //}
            ChargeGridPanel();
        }


        protected void Button1Click(object sender, DirectEventArgs e)
        {
            SpacialDataSet sd = new SpacialDataSet();
            sd.vehicule = vehicule.Text;
            sd.dateDepart = DateTime.Parse(dateDepart.Text);
            sd.dateArivee = DateTime.Parse(dateArivee.Text);
            SqlGeometry sqlG = SqlGeometry.Parse(trajet.Text);
            sd.trajet = DbGeometry.FromBinary(sqlG.STAsBinary().Buffer);
            db = new demoDB();
            db.SpacialDataSets.Add(sd);
            db.SaveChanges();
        }

        protected void ChargeGridPanel()
        {
            db = new demoDB();
            Store1.DataSource = db.SpacialDataSets.ToList();
            this.Store1.DataBind();
        }
       
        protected void RowSelect(object sender, DirectEventArgs e)
        {
            string varID = e.ExtraParams["Id"];
            SpacialDataSet sd = SpacialDataSet.GetSpacialDataSet(int.Parse(varID));
            string test = Convert.ToString(sd.trajet);
            frmInfo.SetValues(new
            {
                sd.vehicule,
                sd.dateDepart,
                sd.dateArivee,
                sd.trajet
            });       
        }
    }
}