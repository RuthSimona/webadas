using CadLicoreria;
using ClnLicoreria;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CpLicoreria
{
    public partial class FrmCliente : Form
    {
        bool esNuevo = false;
        public FrmCliente()
        {
            InitializeComponent();
        }

        private void listar()
        {
            var clientes = ClienteCln.listarPa(txtBuscar.Text.Trim());
            dgvLista.DataSource = clientes;
            dgvLista.Columns["id"].Visible = false;
            dgvLista.Columns["estado"].Visible = false;
            dgvLista.Columns["razonSocial"].HeaderText = "Razon Social";
            dgvLista.Columns["cedulaIdentidad"].HeaderText = "Cedula de Identidad";
            dgvLista.Columns["celular"].HeaderText = "Celular";
            dgvLista.Columns["usuarioRegistro"].HeaderText = "Usuario Registro";
            dgvLista.Columns["fechaRegistro"].HeaderText = "Fecha de Registro";
            btnEditar.Enabled = clientes.Count > 0;
            btnEliminar.Enabled = clientes.Count > 0;
            if (clientes.Count > 0) dgvLista.Rows[0].Cells["razonSocial"].Selected = true;
        }

        private void FrmCliente_Load(object sender, EventArgs e)
        {
            Size = new Size(678, 487);
            listar();
        }

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            esNuevo = true;
            Size = new Size(955, 487);
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            esNuevo = false;
            Size = new Size(955, 487);
            int index = dgvLista.CurrentCell.RowIndex;
            int id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
            var cliente = ClienteCln.get(id);
            txtRazon.Text = cliente.razonSocial;
            txtCedula.Text = cliente.celular;
            txtCelular.Text = cliente.celular;
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            listar();
            txtBuscar.Clear();
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            Size = new Size(678, 487);
        }

        private void limpiar()
        {
            txtRazon.Text = string.Empty;
            txtCedula.Text = string.Empty;
            txtCelular.Text = string.Empty;
        }

        private void txtBuscar_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter) listar();
        }

        private bool Validar()
        {
            bool esValido = true;
            erpRazonsocial.SetError(txtRazon, "");
            erpCedula.SetError(txtCedula, "");
            erpCelular.SetError(txtCelular, "");
            if (string.IsNullOrEmpty(txtRazon.Text))
            {
                esValido = false;
                erpRazonsocial.SetError(txtRazon, "El campo Razon social es obligatorio");
            }
            if (string.IsNullOrEmpty(txtCedula.Text))
            {
                esValido = false;
                erpCedula.SetError(txtCedula, "El campo cedula es obligatorio");
            }
            if (string.IsNullOrEmpty(txtCelular.Text))
            {
                esValido = false;
                erpCelular.SetError(txtCelular, "El campo Celular es obligatorio");
            }
            return esValido;
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (Validar())
            {
                var cliente = new Cliente();
                cliente.razonSocial = txtRazon.Text.Trim();
                cliente.cedulaIdentidad = txtCedula.Text.Trim();
                cliente.celular = txtCelular.Text;
                cliente.usuarioRegistro = Util.usuario.usuario1;

                if (esNuevo)
                {
                    cliente.fechaRegistro = DateTime.Now;
                    cliente.estado = 1;
                    ClienteCln.insertar(cliente);
                }
                else
                {
                    int index = dgvLista.CurrentCell.RowIndex;
                    cliente.id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
                    ClienteCln.actualizar(cliente);
                }
                listar();
                btnCancelar.PerformClick();
                MessageBox.Show("Producto guardado correctamente", "::: Cafeteria - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            int index = dgvLista.CurrentCell.RowIndex;
            int id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
            string razonSocial = dgvLista.Rows[index].Cells["razonSocial"].Value.ToString();
            DialogResult dialog = MessageBox.Show($"¿Está seguro que desea dar de baja el producto {razonSocial}?",
                "::: Cafeteria - Mensaje :::", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (dialog == DialogResult.OK)
            {
                ClienteCln.eliminar(id, "SIS457");
                listar();
                MessageBox.Show("Producto dado de baja correctamente", "::: Cafeteria - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void btnVolver_Click(object sender, EventArgs e)
        {
            //FrmPrincipal principal = new FrmPrincipal();
            //principal.Show();
            this.Close();
        }

        private void btnLimpiar_Click(object sender, EventArgs e)
        {
            limpiar();
        }
    }
}
