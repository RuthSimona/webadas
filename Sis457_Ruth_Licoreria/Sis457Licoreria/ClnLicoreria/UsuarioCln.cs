using CadLicoreria;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClnLicoreria
{
    public class UsuarioCln
    {
        public static int insertar(Usuario usuario)
        {
            using (var context = new LabLicoreriaEntities())
            {
                context.Usuario.Add(usuario);
                context.SaveChanges();
                return usuario.idUsuario;
            }
        }

        public static int actualizar(Usuario usuario)
        {
            using (var context = new LabLicoreriaEntities())
            {
                var existente = context.Usuario.Find(usuario.idUsuario);
                existente.usuario1 = usuario.usuario1.Trim();
                existente.idEmpleado = usuario.idEmpleado;
                existente.usuarioRegistro = usuario.usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static int cambiarClave(int id, string clave, string usuarioRegistro)
        {
            using (var contexto = new LabLicoreriaEntities())
            {
                var existente = contexto.Usuario.Find(id);
                existente.clave = clave;
                existente.usuarioRegistro = usuarioRegistro;
                return contexto.SaveChanges();
            }
        }

        public static int eliminar(int id, string usuario)
        {
            using (var contexto = new LabLicoreriaEntities())
            {
                var existente = contexto.Usuario.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuario;
                return contexto.SaveChanges();
            }
        }

        public static Usuario get(int id)
        {
            using (var contexto = new LabLicoreriaEntities())
            {
                return contexto.Usuario.Find(id);
            }
        }

        public static Usuario validar(string usuario, string clave)
        {
            using (var contexto = new LabLicoreriaEntities())
            {
                return contexto.Usuario
                    .Where(x => x.usuario1 == usuario && x.clave == clave && x.estado == 1)
                    .FirstOrDefault();
            }
        }

        public static List<Usuario> listar()
        {
            using (var contexto = new LabLicoreriaEntities())
            {
                return contexto.Usuario.Where(x => x.estado != -1).ToList();
            }
        }
    }
}
