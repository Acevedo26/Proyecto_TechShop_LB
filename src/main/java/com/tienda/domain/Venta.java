package com.tienda.domain;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name="venta")
public class Venta implements Serializable {    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "venta_seq")
    @SequenceGenerator(name = "venta_seq", sequenceName = "venta_seq", allocationSize = 1)
    @Column(name="id_venta")
    private Long idVenta;
    @Column(name = "id_factura")
    private Long idFactura;
    
    @Column(name = "id_producto")
    private Long idProducto;
    
    @Column(name = "precio", precision = 10, scale = 2)
    private java.math.BigDecimal precio;
    
    @Column(name = "cantidad")
    private int cantidad;    
    
    public Venta() {
    }

    public Venta(Long idFactura, Long idProducto, double precio, int cantidad) {
        this.idFactura = idFactura;
        this.idProducto = idProducto;
        this.precio = java.math.BigDecimal.valueOf(precio);
        this.cantidad = cantidad;
    }
}