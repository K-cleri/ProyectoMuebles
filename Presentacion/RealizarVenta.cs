using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.OleDb;
using ProyectoMuebles.Carpeta_de_Datos;

namespace ProyectoMuebles.Presentacion
{
    public partial class RealizarVenta : Form
    {
        public RealizarVenta()
        {
            InitializeComponent();
        }

        private void btnCerrar_Click(object sender, EventArgs e)
        {
            this.Close();
            MenuPrincipal Regreso = new MenuPrincipal();
            Regreso.Show();
        }

        private void menuPrincipalToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
            MenuPrincipal Regreso = new MenuPrincipal();
            Regreso.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
        }
        private void GenerarTicket(int prmFOLIO)
        {
            try
            {
                string Ticket = "Nombre de la tienda: " +  "\n" +
                    "RFC:" + "\n" +
                    "------------------------------\n" +
                    "ARTICULO   CANT   PRECIO   TOTAL\n" +
                    "------------------------------\n";



                string varSQL =
                    "SELECT LEFT(DESC_PRODUCTO,10) as DESC_PRODUCTO," +
                    " CANTIDAD,P_UNITARIO,TOTAL" +
                    " FROM vVENTAS WHERE FOLIO=" + prmFOLIO + "";

                string DetalleTicket = "";
                double varGranTotal = 0;
                OleDbConnection cnnTicket = new OleDbConnection(ConexionSQL.CadenaConexion);
                cnnTicket.Open();
                OleDbCommand cmdTicket = new OleDbCommand(varSQL, cnnTicket);
                OleDbDataReader drTicket;
                drTicket = cmdTicket.ExecuteReader();

                while (drTicket.Read())
                {
                    DetalleTicket +=
                        drTicket["DESC_PRODUCTO"].ToString() + "   " +
                        drTicket["CANTIDAD"].ToString() + "   " +
                        String.Format("{0:c}",
                        drTicket["P_UNITARIO"]) + "   " +
                        String.Format("{0:c}",
                        drTicket["TOTAL"]) + "\n";
                    varGranTotal += (double)drTicket["TOTAL"];
                }

                DetalleTicket += "------------------------------\n" +
                    "TOTAL: " + String.Format("{0:c}", varGranTotal);
                Ticket += DetalleTicket;

                //mPrintDocument _mPrintDocument = new mPrintDocument(Ticket);
                //_mPrintDocument.PrintPreview();


            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
