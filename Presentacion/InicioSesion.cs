using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Sql;
using System.Data.SqlClient;
using ProyectoMuebles.Carpeta_de_Datos;


namespace ProyectoMuebles.Presentacion
{
    public partial class Form1 : Form
    {
        private ConexionSQL Con = new ConexionSQL();
        String Mensaje = "";     
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
           
        }

        private void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            Mensaje = IniciarSesion();
            if (Mensaje != "Error de Usuario o Contraseña.")
            {
                MessageBox.Show("Bienvenido(a)", Mensaje);
                MenuPrincipal objetMenu = new MenuPrincipal();
                this.Hide();
                objetMenu.Show();
            }
            else
            {
                MessageBox.Show("Error de Usuario o Contraseña ", Mensaje);
                this.txtNombreUsuario.Clear();
                this.txtContraseña.Clear();
                this.txtContraseña.Focus();
            }        
        }
        //Enlase a SQL para realizar una Busqueda de usuario o contraseña   
        private String IniciarSesion()
        {
            List<clsParametro> lst = new List<clsParametro>();
            String mensaje = "";
            try
            {
                lst.Add(new clsParametro("@Nombre", txtNombreUsuario.Text));
                lst.Add(new clsParametro("@Contraseña", txtContraseña.Text.Trim()));
                lst.Add(new clsParametro("@Encontro", "", SqlDbType.VarChar, ParameterDirection.Output, 30));
                Con.EjecutarSP("SP_BuscarUsuario", ref lst);
                return mensaje = lst[2].Valor.ToString();                           
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //Boton Salir Por confirmacion Si/No
        private void btnSalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("¿Desea Salir del Programa?", "Salir", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) == System.Windows.Forms.DialogResult.Yes)
            {
                Application.Exit();
            }
        }
    }
}