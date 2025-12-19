package com.tienda.domain;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "producto")
public class Producto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "producto_seq")
    @SequenceGenerator(name = "producto_seq", sequenceName = "producto_seq", allocationSize = 1)
    @Column(name = "id_producto")
    private Long idProducto;
    @Column(name = "descripcion", length = 200)
    private String descripcion;
    
    @Column(name = "detalle", length = 1000)
    private String detalle;
    
    @Column(name = "precio", precision = 10, scale = 2)
    private java.math.BigDecimal precio;
    
    @Column(name = "existencias")
    private int existencias;
    
    @Column(name = "ruta_imagen", length = 500)
    private String rutaImagen;
    
    @Column(name = "activo")
    private boolean activo;

    @ManyToOne // Efectivamente la asociación de mucho a uno...
    @JoinColumn(name = "id_categoria") // Indicar el atributo en este caso de la tabla...
    private Categoria categoria;

    public Producto() {
    }

    public Producto(String producto, boolean activo) {
        this.descripcion = producto;
        this.activo = activo;
    }
}
