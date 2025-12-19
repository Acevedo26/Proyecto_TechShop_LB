package com.tienda.controller;


import com.tienda.domain.Usuario;
import com.tienda.service.UsuarioService;
import com.tienda.service.impl.FirebaseStorageServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/usuario")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;
    @Autowired
    private FirebaseStorageServiceImpl firebaseStorageService;


    @GetMapping("/listado")
    public String inicio(Model model) {
        var usuarios = usuarioService.getUsuarios();
        model.addAttribute("usuarios", usuarios);
        model.addAttribute("totalUsuarios", usuarios.size());
        return "/usuario/listado";
    }

    @GetMapping("/nuevo")
    public String usuarioNuevo(Usuario usuario) {
        return "/usuario/modifica";
    }

    @PostMapping("/guardar")
    public String usuarioGuardar(Usuario usuario,
            @RequestParam("imagenFile") MultipartFile imagenFile) {
        var codigo= new BCryptPasswordEncoder();
        usuario.setPassword(codigo.encode(usuario.getPassword()));
        if (!imagenFile.isEmpty()) {
            usuarioService.save(usuario,false);
            usuario.setRutaImagen(
                    firebaseStorageService
                            .cargaImagen(imagenFile,
                                    "usuarios",
                                    usuario.getIdUsuario()));
        }
        usuarioService.save(usuario,true);
        return "redirect:/";
    }


    @GetMapping("/eliminar/{idUsuario}")
    public String usuarioEliminar(Usuario usuario) {
        usuarioService.delete(usuario);
        return "redirect:/usuario/listado";
    }

    @GetMapping("/modificar/{idUsuario}")
    public String usuarioModificar(Usuario usuario,Model model) {
        usuario = usuarioService.getUsuario(usuario);
        model.addAttribute("usuario", usuario);
        return "/usuario/modifica";
    }
}