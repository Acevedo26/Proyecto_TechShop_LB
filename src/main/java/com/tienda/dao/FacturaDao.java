package com.tienda.dao;

import com.tienda.domain.Factura;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Date;

public interface FacturaDao extends JpaRepository <Factura,Long> {
    
    // Métodos adicionales para CRUD
    List<Factura> findByIdUsuario(Long idUsuario);
    List<Factura> findByEstado(int estado);
    List<Factura> findByTotalBetween(java.math.BigDecimal totalMin, java.math.BigDecimal totalMax);
    List<Factura> findByFechaBetween(Date fechaInicio, Date fechaFin);
}