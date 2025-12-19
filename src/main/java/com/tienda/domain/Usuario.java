package com.tienda.domain;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Entity
@Data
@Table(name = "usuario")
public class Usuario implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_USUARIO")
    @SequenceGenerator(name = "SEQ_USUARIO", sequenceName = "SEQ_USUARIO", allocationSize = 1)
    @Column(name = "id_usuario")
    private Long idUsuario;
    @Column(name = "username", length = 50, nullable = false, unique = true)
    private String username;
    
    @Column(name = "password", length = 255, nullable = false)
    private String password;
    
    @Column(name = "nombre", length = 100)
    private String nombre;
    
    @Column(name = "apellidos", length = 100)
    private String apellidos;
    
    @Column(name = "correo", length = 150, unique = true)
    private String correo;
    
    @Column(name = "telefono", length = 20)
    private String telefono;
    
    @Column(name = "ruta_imagen", length = 500)
    private String rutaImagen;
    
    @Column(name = "activo")
    private boolean activo;

    @OneToMany
    @JoinColumn(name = "id_usuario")
    private List<Rol> roles;
}
