package com.tienda.dao;

import com.tienda.domain.Producto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ProductoDao extends JpaRepository<Producto, Long> {

    // Métodos existentes
    public List<Producto> findByPrecioBetweenOrderByDescripcion(double precioInf, double precioSup);

    @Query(value="SELECT a FROM Producto a WHERE a.precio BETWEEN :precioInf and :precioSup ORDER BY a.descripcion ASC")
    public List<Producto> metodoJPQL(double precioInf, double precioSup);
    
    @Query(nativeQuery=true,value="SELECT * FROM producto a WHERE a.precio BETWEEN :precioInf and :precioSup ORDER BY a.descripcion ASC")
    public List<Producto> metodoSQL(double precioInf, double precioSup);
    
    // Métodos adicionales para CRUD
    List<Producto> findByActivoTrue();
    List<Producto> findByCategoriaIdCategoria(Long idCategoria);
    List<Producto> findByPrecioBetween(java.math.BigDecimal precioMin, java.math.BigDecimal precioMax);
    List<Producto> findByDescripcionContainingIgnoreCase(String descripcion);
}
