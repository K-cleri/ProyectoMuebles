using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProyectoMuebles.Presentacion
{
    public partial class MenuPrincipal : Form
    {
        public MenuPrincipal()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
            RealizarVenta Ventas = new RealizarVenta();
            Ventas.Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            this.Close();
            AgregarArticulo agregarArticulo = new AgregarArticulo();
            agregarArticulo.Show();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            this.Close();
            Form1 inicioSesion = new Form1();
            inicioSesion.Show();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            this.Close();
            Clientes cliente = new Clientes();
            cliente.Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.Close();
            Inventario objetInventario = new Inventario();
            objetInventario.Show();
        }
    }
}
