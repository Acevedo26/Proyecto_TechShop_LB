package com.tienda.domain;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Data
@Entity
@Table(name="categoria")
public class Categoria implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "categoria_seq")
    @SequenceGenerator(name = "categoria_seq", sequenceName = "categoria_seq", allocationSize = 1)
    @Column(name="id_categoria")
    private Long idCategoria;
    
    @Column(name = "descripcion", length = 200)
    private String descripcion;
    
    @Column(name = "ruta_imagen", length = 500)
    private String rutaImagen;
    
    @Column(name = "activo")
    private boolean activo;

    @OneToMany(mappedBy = "categoria", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Producto> productos;
}
