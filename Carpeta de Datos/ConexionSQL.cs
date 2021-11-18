using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Sql;
using System.Data;
using System.Data.SqlClient;

namespace ProyectoMuebles.Carpeta_de_Datos
{
    class ConexionSQL
    {
        //Cadena de conexion
        public static string CadenaConexion = @"Server=(localdb)\Server;Database=Muebleria;Integrated Security=true;";
        SqlConnection cControl = new SqlConnection(CadenaConexion);
        //Metodos Para Conectar o desconectar la base de datos
        public void Abrir()
        {
            cControl.Open();
        }
        public void Cerrar()
        {
            cControl.Close();
        }
        public void EjecutarSP(String NombreSP, ref List<clsParametro>lst)
        {
            SqlCommand cmd;
            try
            {
                Abrir();
                cmd = new SqlCommand(NombreSP, cControl);
                cmd.CommandType = CommandType.StoredProcedure;
                if (lst != null)
                {
                    for (int i = 0; i < lst.Count; i++)
                    {
                        if (lst[i].Direccion == ParameterDirection.Input)
                            cmd.Parameters.AddWithValue(lst[i].Nombre, lst[i].Valor);
                        if (lst[i].Direccion == ParameterDirection.Output)
                            cmd.Parameters.Add(lst[i].Nombre, lst[i].TipoDato, lst[i].Tamaño).Direction = ParameterDirection.Output;
                    }
                    cmd.ExecuteNonQuery();
                    for (int i = 0; i < lst.Count; i++)
                    {
                        if (cmd.Parameters[i].Direction == ParameterDirection.Output)
                            lst[i].Valor = cmd.Parameters[i].Value;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            Cerrar();
        }
    }
}
