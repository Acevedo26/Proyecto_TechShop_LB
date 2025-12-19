package com.tienda.domain;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Data;

@Data
@Entity
@Table(name="factura")
public class Factura implements Serializable {    
    private static final long serialVersionUID = 1L;
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "factura_seq")
    @SequenceGenerator(name = "factura_seq", sequenceName = "factura_seq", allocationSize = 1)
    @Column(name="id_factura")
    private Long idFactura;
    @Column(name = "id_usuario")
    private Long idUsuario;
    
    @Column(name = "fecha")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fecha;
    
    @Column(name = "total", precision = 10, scale = 2)
    private java.math.BigDecimal total;
    
    @Column(name = "estado")
    private int estado;
    
    
    public Factura() {
    }

    public Factura(Long idUSuario) {
        this.idUsuario = idUSuario;
        this.fecha = Calendar.getInstance().getTime();
        this.estado=1;
    }    
}
