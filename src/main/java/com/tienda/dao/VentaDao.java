package com.tienda.dao;

import com.tienda.domain.Venta;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VentaDao extends JpaRepository <Venta,Long> {
    
    // Métodos adicionales para CRUD
    List<Venta> findByIdFactura(Long idFactura);
    List<Venta> findByIdProducto(Long idProducto);
    List<Venta> findByPrecioBetween(java.math.BigDecimal precioMin, java.math.BigDecimal precioMax);
    List<Venta> findByCantidadGreaterThan(int cantidad);
}
