//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CadLicoreria
{
    using System;
    using System.Collections.Generic;
    
    public partial class Detalle_Compra
    {
        public int idDetalleCompra { get; set; }
        public Nullable<int> idCompra { get; set; }
        public Nullable<int> idProducto { get; set; }
        public Nullable<double> cantidad { get; set; }
        public Nullable<double> PrecioUnitarioCompra { get; set; }
        public Nullable<double> PrecioUnitarioVenta { get; set; }
        public Nullable<double> TotalCosto { get; set; }
        public string usuarioRegistro { get; set; }
        public System.DateTime fechaRegistro { get; set; }
        public short estado { get; set; }
    
        public virtual Compra Compra { get; set; }
        public virtual Producto Producto { get; set; }
    }
}
